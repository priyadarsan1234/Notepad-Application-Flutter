import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ADDING extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<ADDING> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _uploadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mail = prefs.getString('email');

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference users = firestore.collection('users${mail}');

      String name = _nameController.text;
      String description = _descriptionController.text;

      await users.add({
        'name': name,
        'description': description,
        'email': mail,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data uploaded successfully'),
      ));
    } catch (e) {
      // Handle any errors that may occur during the process
      print('Error uploading data: $e');
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
            padding: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Data',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    maxLines: 10,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      hintText: 'Enter a description...',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      fillColor: Colors.grey[200], // Background color
                      filled: true,
                    ),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: _uploadData,
                            child: Text(' Add Data ',
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
                              _descriptionController.text = '';
                              _nameController.text = '';
                            },
                            child: Text('Clear Data',
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
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ));
    // );
  }
}
