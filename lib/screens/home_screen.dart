import 'package:assignment_5/Util.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final database = FirebaseDatabase.instance.ref('Persons');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kGreen,
        title: const Text('Assignment 5'),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Util.ShowDialog(context);
        },
        child: Container(
            height: 50,
            width: 45,
            decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: kGreen.withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 4)
                ]),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            )),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: database.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                          height: 40, child: CircularProgressIndicator(color: kGreen,)));
                } else {
                  Map m = snapshot.data!.snapshot.value as Map;
                  List<dynamic> lis = m.values.toList();
                  return ListView.builder(
                    itemCount: lis.length,
                    itemBuilder: (context, index) {
                      return Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          elevation: 2,
                          shadowColor: kGreen.withOpacity(0.7),
                          surfaceTintColor: kGreen,
                          margin: const EdgeInsets.all(12),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lis[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Divider(),
                                    PersonAttrib(
                                        title: lis[index]['email'],
                                        icon: Icons.email),
                                    PersonAttrib(
                                        title: lis[index]['mobile'],
                                        icon: Icons.phone),
                                    PersonAttrib(
                                        title: lis[index]['gender'],
                                        icon: FontAwesomeIcons.marsAndVenus),
                                  ],
                                ),
                                PopupMenuButton(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20),topRight: Radius.circular(20))
                                  ),
                                  color: kWhite,
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                          child: ListTile(
                                        onTap: () {
                                          Util.ShowDialog(context,
                                              id: lis[index]['id']);
                                        },
                                        title: const Text('Edit'),
                                        leading: const Icon(FontAwesomeIcons.pencil,
                                            color: kGreen),
                                      )),
                                      PopupMenuItem(
                                          child: ListTile(
                                        onTap: () {
                                          database
                                              .child(lis[index]['id'])
                                              .remove();
                                          Util.makeToast('Deleted Successfully!');
                                        },
                                        title: const Text('Delete'),
                                        leading: const Icon(
                                            FontAwesomeIcons.trashCan,
                                            color: kGreen),
                                      ))
                                    ];
                                  },
                                )
                              ],
                            ),
                          ));
                    },
                  );
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}

class PersonAttrib extends StatelessWidget {
  const PersonAttrib({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: kGreen,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(title),
        ],
      ),
    );
  }
}
