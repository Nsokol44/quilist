import 'package:flutter/material.dart';
import 'navigationmenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecondRoute extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quilist'),
        centerTitle: true,
      ),
      drawer: NavigationMenu(),
      body: Card(
        margin: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('quils').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('BUMMER No Quils, dude!');
            } else {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 15.0),
                    child: ListTile(
                      title: Text(data['title']),
                      subtitle: Text(data['description']),
                      isThreeLine: true,
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
}
