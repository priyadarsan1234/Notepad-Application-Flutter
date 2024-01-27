import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/EditNote.dart';
import 'package:flutter_application_2/Add.dart';
import 'package:flutter_application_2/login.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Viewdata extends StatefulWidget {
  @override
  _ViewdataState createState() => _ViewdataState();
}

class _ViewdataState extends State<Viewdata> {
  late Future<String?> email;
  late CollectionReference? users;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    email = _getEmail();
  }

  Future<String?> _getEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mail = prefs.getString('email');

      if (mail == null || mail.isEmpty) {
        return null;
      }
      setState(() {
        users = FirebaseFirestore.instance.collection('users${mail ?? ""}');
      });
      return mail;
    } catch (e) {
      print('Error getting email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error getting email. Please try again.'),
        ),
      );
      return null;
    }
  }

  Future<void> _deleteUser(String documentId) async {
    await users!.doc(documentId).delete();
    setState(() {});
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('email');
    await prefs.remove('password');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _startSearch() {
    setState(() {
      isSearching = true;
    });
  }
  void _stopSearch() {
    setState(() {
      isSearching = false;
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching ? _buildSearchAppBar() : _buildNormalAppBar(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Click Above Card To View Full Or Update Note",
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 12,
                color: Colors.redAccent,
              ),
            ),
          ),
          FutureBuilder<String?>(
            future: email,
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return users == null
                    ? const Center(
                        child: Text('User data not loaded yet.'),
                      )
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            setState(() {});
                          },
                          child: FutureBuilder<QuerySnapshot>(
                            future: users!.get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                return ListView(
                                  children:
                                      snapshot.data!.docs.where((document) {
                                    Map<String, dynamic> data =
                                        document.data() as Map<String, dynamic>;
                                    String Title = data['Title'].toLowerCase();
                                    String query =
                                        searchController.text.toLowerCase();
                                    return Title.contains(query);
                                  }).map((DocumentSnapshot document) {
                                    Map<String, dynamic> data =
                                        document.data() as Map<String, dynamic>;
                                    String documentId = document.id;
                                    dynamic timestampValue = data['timestamp'];
                                    DateTime dateTime = timestampValue.toDate();
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(dateTime);
                                    String formattedTime =
                                        DateFormat('HH-mm-ss').format(dateTime);

                                    return Card(
                                      elevation: 5,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        tileColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        title: Text(
                                          data['Title'],
                                          style: const TextStyle(
                                            fontFamily: 'serif',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                          maxLines: 1,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Content: ${data['Content']}',
                                              style: const TextStyle(
                                                fontFamily: 'serif',
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 1,
                                            ),
                                            Text(
                                              'Created: ${formattedDate}',
                                              style: const TextStyle(
                                                fontFamily: 'serif',
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              'Time:${formattedTime}',
                                              style: const TextStyle(
                                                fontFamily: 'serif',
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Edit(
                                                Title: data['Title'],
                                                Content:
                                                    data['Content'],
                                                documentId: documentId,
                                              ),
                                            ),
                                          );
                                        },
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.red,
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text('Delete Note',
                                                          style: TextStyle(
                                                            fontFamily: 'serif',
                                                          )),
                                                  content: const Text(
                                                    'Are you sure you want to delete this Note?',
                                                    style: TextStyle(
                                                      fontFamily: 'serif',
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            fontFamily: 'serif',
                                                          )),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        _deleteUser(documentId)
                                                            .then((value) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'User deleted successfully'),
                                                            ),
                                                          );
                                                          setState(() {});
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                        ),
                      );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ADDING()),
          );
        },
        hoverColor: Colors.red,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildNormalAppBar() {
    return AppBar(
      title: const Text('My Notepad',
          style: TextStyle(
            fontFamily: 'serif',
          )),
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: _startSearch,
        ),
        IconButton(
          icon: Icon(
            Icons.logout,
            color: Colors.black,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Logout',
                      style: TextStyle(
                        fontFamily: 'serif',
                      )),
                  content: const Text('Are you sure you want to Logout?',
                      style: TextStyle(
                        fontFamily: 'serif',
                      )),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel',
                          style: TextStyle(
                            fontFamily: 'serif',
                          )),
                    ),
                    TextButton(
                      onPressed: () {
                        clearSharedPreferences();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  AppBar _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _stopSearch,
      ),
      title: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search by Title',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            searchController.clear();
          },
        ),
      ],
    );
  }
}