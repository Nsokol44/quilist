import 'package:quilist/pages/chat_page.dart';
import 'package:quilist/pages/group_info.dart';
import 'package:quilist/service/database_service.dart';
import 'package:quilist/widgets/message_tile.dart';
import 'package:quilist/widgets/widgets.dart';
import 'package:quilist/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ListPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Stream<QuerySnapshot>? todos;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  bool isChecked = false;
  List<bool> checkboxValues = [];
  var newLength;

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  getChatandAdmin() {
    DatabaseService().getTodos(widget.groupId).then((val) {
      setState(() {
        todos = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  // Add widgets here.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()))),
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: admin,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Column(
        children: <Widget>[
          // chat messages here
          Expanded(
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    quilistItems(),
                    SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Add a Todo...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    addTodo();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  nextScreen(
                      context,
                      ListPage(
                        userName: widget.userName,
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                      ));
                },
                child: Text('List')),
            SizedBox(),
            ElevatedButton(
                onPressed: () {
                  nextScreen(
                      context,
                      ChatPage(
                        userName: widget.userName,
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                      ));
                },
                child: Text('Chat')),
          ]),
        ],
      ),
    );
  }

//View all Todos
  quilistItems() {
    return StreamBuilder(
      stream: todos,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> docs = snapshot.data!.docs;
          if (checkboxValues.length != docs.length) {
            checkboxValues =
                List<bool>.filled(snapshot.data!.docs.length, false);
          }
        }
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  bool? isChecked = checkboxValues[index];

                  return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: FlutterLogo(size: 56.0),
                        title: Text(snapshot.data.docs[index]['todoItem']),
                        subtitle: Text(snapshot.data.docs[index]['sender']),
                        trailing: Wrap(
                          spacing: 2,
                          children: <Widget>[
                            Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  checkboxValues[index] = value ?? false;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                DocumentSnapshot docSnapshot =
                                    snapshot.data.docs[index];
                                DocumentReference docRef =
                                    docSnapshot.reference;
                                docRef.delete();
                              },
                            ),
                          ],
                        ),
                      ));
                },
              )
            : Container();
      },
    );
  }

//Add a new todo.
  addTodo() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> listItem = {
        "todoItem": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().addListItem(widget.groupId, listItem);
      setState(() {
        messageController.clear();
      });
    }
  }

//Update checkboxValues length
//Remove a todo
//  removeTodo() {
//    DatabaseService().removeListItem(widget.groupId);
  // }
}
