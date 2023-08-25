import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class TodoItems extends StatefulWidget {
  const TodoItems({
    super.key,
  });

  @override
  State<TodoItems> createState() => _TodoItemsState();
}

bool isDone = false;
final searchFilter = TextEditingController();
final todoController = TextEditingController();
final auth = FirebaseAuth.instance;
final ref = FirebaseDatabase.instance.ref('ToDos');

class _TodoItemsState extends State<TodoItems> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return FirebaseAnimatedList(
      query: ref,
      itemBuilder: (context, snapshot, animation, index) {
        final title = snapshot.child('title').value.toString();

        if (searchFilter.text.isEmpty) {
          return ListTile(
            leading: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      isDone = true;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tileColor: Colors.white,
                  leading: InkWell(
                    onTap: () {
                      setState(() {
                        isDone = false;
                      });
                    },
                    child: Icon(
                      isDone ? Icons.check_box : Icons.check_box_outline_blank,
                      color: tdBlue,
                    ),
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                        fontSize: 16,
                        color: tdBlack,
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: tdRed,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      color: Colors.white,
                      iconSize: 18,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref
                            .child(snapshot.child('id').value.toString())
                            .remove();
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (title.toLowerCase().contains(
              searchFilter.text.toLowerCase().toString(),
            )) {
          return ListTile(
            leading: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      isDone = true;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tileColor: Colors.white,
                  leading: InkWell(
                    onTap: () {
                      setState(() {
                        isDone = false;
                      });
                    },
                    child: Icon(
                      isDone ? Icons.check_box : Icons.check_box_outline_blank,
                      color: tdBlue,
                    ),
                  ),
                  title: Text(
                    snapshot.child('title').value.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        color: tdBlack,
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
