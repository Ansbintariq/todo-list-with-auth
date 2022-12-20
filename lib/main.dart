import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:signup_firebase_app/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'signUp Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController UpdateitemNameController = TextEditingController();
  TextEditingController UpdateditemPriceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
        children: [
          TextField(
            controller: itemNameController,
            decoration: const InputDecoration(label: Text("item")),
          ),
          TextField(
            controller: itemPriceController,
            decoration: const InputDecoration(label: Text("price")),
          ),
          ElevatedButton(
              onPressed: () {
                try {
                  FirebaseFirestore.instance.collection('items').doc().set(
                    {
                      'item': itemNameController.text,
                      'price': itemPriceController.text,
                      'uid': uid,
                      'fav': false,
                    },
                  );
                  itemNameController.clear();
                  itemPriceController.clear();
                } catch (e) {
                  print(e);
                }
              },
              child: const Text("ADD")),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('items')
                  .where("uid",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.docs.isEmpty
                      ? const Text("No Record")
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                title: Text(snapshot.data!.docs[index]['item']),
                                subtitle:
                                    Text(snapshot.data!.docs[index]['price']),
                                trailing: SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            var docID =
                                                snapshot.data!.docs[index].id;
                                            FirebaseFirestore.instance
                                                .collection('items')
                                                .doc(docID)
                                                .delete();
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color.fromARGB(
                                                255, 68, 123, 241),
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            var docID =
                                                snapshot.data!.docs[index].id;
                                            print(docID);

                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    child: AlertDialog(
                                                      title:
                                                          const Text("Update"),
                                                      actions: [
                                                        TextField(
                                                            controller:
                                                                UpdateitemNameController,
                                                            decoration: InputDecoration(
                                                                hintText: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        ['item']
                                                                    .toString())),
                                                        TextField(
                                                          controller:
                                                              UpdateditemPriceController,
                                                          decoration: InputDecoration(
                                                              hintText: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                      ['price']
                                                                  .toString()),
                                                        ),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'items')
                                                                  .doc(docID)
                                                                  .set(
                                                                {
                                                                  'item':
                                                                      UpdateitemNameController
                                                                          .text,
                                                                  'price':
                                                                      UpdateditemPriceController
                                                                          .text,
                                                                  'uid': uid
                                                                },
                                                              );
                                                              UpdateitemNameController
                                                                  .clear();
                                                              UpdateditemPriceController
                                                                  .clear();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                "update"))
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Color.fromARGB(
                                                255, 68, 100, 241),
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            var docID =
                                                snapshot.data!.docs[index].id;
                                            // print(docID);
                                            FirebaseFirestore.instance
                                                .collection('items')
                                                .doc(docID)
                                                .update({
                                              'fav': true,
                                            });
                                            try {
                                              FirebaseFirestore.instance
                                                  .collection('favorite')
                                                  .doc()
                                                  .set(
                                                {
                                                  'item': snapshot.data!
                                                      .docs[index]["item"],
                                                  'price': snapshot.data!
                                                      .docs[index]["price"],
                                                  'uid': uid,
                                                },
                                              );
                                            } catch (e) {
                                              print("favorite error=$e");
                                            }
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: snapshot.data!.docs[index]
                                                        ['fav'] ==
                                                    true
                                                ? const Color.fromARGB(
                                                    255, 216, 6, 6)
                                                : Colors.grey,
                                          ))
                                    ],
                                  ),
                                ));
                          },
                        );
                } else {
                  return const Text("Loading...");
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
