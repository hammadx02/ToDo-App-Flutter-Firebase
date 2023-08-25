import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool isDone = false;
final searchFilter = TextEditingController();
final todoController = TextEditingController();
final auth = FirebaseAuth.instance;
final ref = FirebaseDatabase.instance.ref('ToDos');

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                searchBox(),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: const Text(
                          'All ToDo\'s',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: FirebaseAnimatedList(
                          query: ref,
                          itemBuilder: (context, snapshot, animation, index) {
                            final title =
                                snapshot.child('title').value.toString();

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
                                          isDone
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
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
                                        padding: EdgeInsets.all(0),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 12),
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          color: tdRed,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: IconButton(
                                          color: Colors.white,
                                          iconSize: 18,
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            ref
                                                .child(snapshot
                                                    .child('id')
                                                    .value
                                                    .toString())
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
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
                                          isDone
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: tdBlue,
                                        ),
                                      ),
                                      title: Text(
                                        snapshot
                                            .child('title')
                                            .value
                                            .toString(),
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
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 20,
                            right: 20,
                            left: 20,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 10.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: todoController,
                            decoration: const InputDecoration(
                                hintText: 'Add a new todo item',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 20,
                          right: 20,
                        ),
                        child: ElevatedButton(
                          // ignore: sort_child_properties_last
                          child: const Text(
                            '+',
                            style: TextStyle(
                              fontSize: 40,
                            ),
                          ),
                          onPressed: () {
                            String id = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();
                            ref.child(id).set({
                              'id': id,
                              'title': todoController.text.toString()
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tdBlue,
                            minimumSize: const Size(60, 60),
                            elevation: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: searchFilter,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      leading: const Icon(
        Icons.menu,
        color: tdBlack,
        size: 30,
      ),
      actions: [
        // ignore: sized_box_for_whitespace
        Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: const CircleAvatar(
            backgroundImage: AssetImage('assets/avater.jpg'),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }
}
