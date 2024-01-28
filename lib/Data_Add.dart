import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Additon extends StatefulWidget{
  _AddingState createState()=> _AddingState();
}
class _AddingState extends State<Additon> {
  TextEditingController Name=TextEditingController();
  TextEditingController Course=TextEditingController();
  TextEditingController Mail=TextEditingController();
  Future<void> _Adddata()async {
   try {
      FirebaseFirestore fc = FirebaseFirestore.instance;
      CollectionReference c=fc.collection("UserData");
      await c.add({
        "Name":Name.text.trim(),
        "Course":Course.text.trim(),
        "Email":Mail.text.trim()
      });
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Note Created successfully'),
      ));
   } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text("${e}"),
      ));
   }
  }
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: Name,
            decoration: InputDecoration(
              labelText: "Name"
            ),
          ),
          TextField(
            controller: Course,
            decoration: InputDecoration(
              labelText: "Course"
            ),
          ),
          TextField(
            controller: Mail,
            decoration: InputDecoration(
              labelText: "Email"
            ),
          ),
          SizedBox(height: 15,),
          ElevatedButton(onPressed: (){
            _Adddata();
          }, child: Text("Add")),
          
        ],
      )
    );
  }
 }
class Retrieval extends StatefulWidget {
  _RetrievalState createState() => _RetrievalState();
}
class _RetrievalState extends State<Retrieval> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieve Data'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('UserData').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {         
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['Name']),
                  subtitle: Text('Course: ${data['Course']}, Email: ${data['Email']}  ${document.id}'),
                  trailing: IconButton(onPressed: (){
                    FirebaseFirestore.instance.collection('UserData').doc(document.id).delete();
                  }, icon: Icon(Icons.delete_forever),),
                  leading: IconButton(onPressed: (){
                    FirebaseFirestore.instance.collection('UserData').doc(document.id).update(
                      {
                        'Name': 'Updated Name',
                        'Course': 'Updated Course',
                        'Email': 'Updated Email'
                      }
                    );
                  }, icon: Icon(Icons.update),),
                );    
              }).toList(),
            );
        },
      ),
    );
  }
}