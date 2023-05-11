import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'createquil.dart';
import 'signin.dart';

class NavigationMenu extends StatelessWidget {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.amber,
              //image: DecorationImage(
              //    image: AssetImage("images/geoscenebanner.jpg"),
              //   fit: BoxFit.cover)
            ),
            child: Text(''),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
            ),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.list_alt_sharp,
            ),
            title: const Text('My Lists'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people,
            ),
            title: const Text('My People'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.library_add,
            ),
            title: const Text('Create New Quilist'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateQuil()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: const Text('Sign Out'),
            onTap: () {
              signOut();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyHomePage(title: 'Quilist - Plan Your Life')));
            },
          ),
        ],
      ),
    );
  }
}
