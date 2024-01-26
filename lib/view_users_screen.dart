import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/EditScreen.dart';
import 'package:flutter_application_2/add_user_screen.dart';
import 'package:flutter_application_2/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Viewdata extends StatefulWidget {
  @override
  _ViewdataState createState() => _ViewdataState();
}

class _ViewdataState extends State<Viewdata> {
  late Future<String?> email;
  late CollectionReference? users;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notepad'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              clearSharedPreferences();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top:8.0),
            child: Text(
              "ClickAbove To View Full Or Update Record",
              style: TextStyle(
                fontSize: 13,
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
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data =
                                        document.data() as Map<String, dynamic>;
                                    String documentId = document.id;

                                    return Card(
                                      elevation: 5,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(16),
                                        tileColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        title: Text(
                                          data['name'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                          maxLines: 1,
                                        ),
                                        subtitle: Text(
                                          'Description: ${data['description']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 1,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Edit(
                                                name: data['name'],
                                                description: data['description'],
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
                                                  title: const Text('Delete User'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this user?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        _deleteUser(documentId)
                                                            .then((value) {
                                                          ScaffoldMessenger.of(context)
                                                              .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      'User deleted successfully'),
                                                                ),
                                                              );
                                                          setState(() {});
                                                        });
                                                        Navigator.of(context).pop();
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
}
