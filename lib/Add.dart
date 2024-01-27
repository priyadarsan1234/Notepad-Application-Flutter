import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/view_users_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ADDING extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<ADDING> {
  final TextEditingController _TitleController = TextEditingController();
  final TextEditingController _ContentController = TextEditingController();

  Future<void> _uploadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mail = prefs.getString('email');

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference users = firestore.collection('users${mail}');

      String name = _TitleController.text;
      String description = _ContentController.text;

      await users.add({
        'Title': name,
        'Content': description,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Note uploaded successfully'),
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Viewdata()),
      );
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Notepad',
              style: TextStyle(
                fontFamily: 'serif',
              )),
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create New Note',
                    style: TextStyle(
                      fontFamily: 'serif',
                      color: Colors.blue,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _TitleController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Title',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    maxLines: 10,
                    controller: _ContentController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      hintText: 'Enter Content...',
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_TitleController.text.trim().isEmpty &&
                                  _TitleController.text.trim() == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Note Title Is Empty'),
                                ));
                              }
                              if (_ContentController.text.trim().isEmpty &&
                                  _ContentController.text.trim() == '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Note Content Is Empty'),
                                ));
                              }
                              else{
                                _uploadData();
                              }
                            
                            },
                            child: const Text(' Create  ',
                                style: TextStyle(
                                  fontFamily: 'serif',
                                )),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _TitleController.text = '';
                              _ContentController.text = '';
                            },
                            child: const Text('Clear Data',
                                style: TextStyle(
                                  fontFamily: 'serif',
                                )),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ));
  }
}
