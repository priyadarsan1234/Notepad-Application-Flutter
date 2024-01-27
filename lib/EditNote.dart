// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/All_Notes_Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edit extends StatefulWidget {
  final String Title;
  final String Content;
  final String documentId;

  Edit({
    required this.Title,
    required this.Content,
    required this.documentId,
  });

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  late TextEditingController _TitleController;
  late TextEditingController _ContentController;
  late CollectionReference users;

  @override
  void initState() {
    super.initState();
    _TitleController = TextEditingController(text: widget.Title);
    _ContentController = TextEditingController(text: widget.Content);
    _initializeUsersCollection();
  }

  void _initializeUsersCollection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mail = prefs.getString('email');
    users = FirebaseFirestore.instance.collection('users${mail ?? ""}');
  }

  @override
  void dispose() {
    _TitleController.dispose();
    _ContentController.dispose();
    super.dispose();
  }

  void _updateUserDetails() async {
    try {
      String updatedTitle = _TitleController.text;
      String updatedContent = _ContentController.text;

      if (widget.Title.trim() == updatedTitle.trim() &&
          widget.Content.trim() == updatedContent.trim()) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('No Change',
                  style: TextStyle(
                    fontFamily: 'serif',
                  )),
              content: const Text('Nothing Will Be Change To Update',
                  style: TextStyle(
                    fontFamily: 'serif',
                  )),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'ok',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Update',
                  style: TextStyle(
                    fontFamily: 'serif',
                  )),
              content: const Text('Are you sure you want to Update This Note?',
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
                    users.doc(widget.documentId).update({
                      'name': updatedTitle,
                      'description': updatedContent,
                    });
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User details updated successfully'),
                      ),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Viewdata()),
                    );
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error updating user details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating user details. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Notepad',
              style: TextStyle(
                fontFamily: 'serif',
              )),
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _TitleController,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Enter New Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Description',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  maxLines: 10,
                  controller: _ContentController,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Enter New Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _updateUserDetails();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}