import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateQuil extends StatefulWidget {
  @override
  CreateQuilState createState() {
    return CreateQuilState();
  }
}

class CreateQuilState extends State<CreateQuil> {
  final _quilKey = GlobalKey<FormState>();
  List todos = List.empty();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Create New Quilist',
          ),
          backgroundColor: Colors.yellow[700],
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Card(
                elevation: 8.0,
                child: Form(
                  key: _quilKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.edit_document),
                          hintText: 'Enter The Group Name',
                          labelText: 'Group Name',
                        ),
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Enter Emails of People To Invite',
                          labelText: 'Participants',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Map<String, String> dataToSave = {
                              'title': _titleController.text,
                              'description': _descriptionController.text,
                            };

                            FirebaseFirestore.instance
                                .collection('quils')
                                .add(dataToSave);

                            Navigator.of(context).pop();
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
