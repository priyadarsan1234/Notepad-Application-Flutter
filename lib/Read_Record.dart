import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Read_Note extends StatefulWidget {
  final String Title;
  final String Content;
  final String documentId;

  Read_Note({
    required this.Title,
    required this.Content,
    required this.documentId,
  });

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Read_Note> {
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Text(
                  '${widget.Title}',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '  *${widget.Content}*',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    }
  }
