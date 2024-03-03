import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/auth_gate.dart';

// class PastSymptomsPage extends StatelessWidget {
//   PastSymptomsPage({super.key, required this.user});
//   final User user;
//   final FirebaseFirestore db = FirebaseFirestore.instance;
//   @override
//   Widget build (BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text("Past Symptoms")), body: Container());
//   }
// }

class PastSymptomsPage extends StatefulWidget {
  PastSymptomsPage({super.key, required this.user});
  final User user;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Item>? pastSymptomsList;
  @override
  State<PastSymptomsPage> createState() => _PastSymptomsPageState();
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
    required this.docID,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
  String docID;
}

class _PastSymptomsPageState extends State<PastSymptomsPage> {
  @override
  void initState() {
    super.initState();
    callDB();
  }

  List<Item> generateItems(List<Map<String, dynamic>> pastSymptoms) {
    // return List<Item>.generate(1, (int index) {
    //   return Item(
    //     headerValue: 'Panel $index',
    //     expandedValue: 'This is item number $index',
    //   );
    // }
    //);
    return pastSymptoms.map(
      (symptomData) {
        String conversation = "${"${"user: " +
            symptomData["userMessage"]}\n \nresponse: " +
            symptomData["aiResponse"]}\n";
        return Item(
          headerValue: symptomData["date"],
          expandedValue: conversation,
          docID: symptomData["docID"],
        );
      },
    ).toList();
  }

  void callDB() async {
    await widget.db
        .collection("users")
        .doc(widget.user.uid)
        .collection("Symptoms")
        .get()
        .then((event) {
      //return event.docs;
      //return event.docs.map((doc) => doc.data()).toList();
      setState(
        () {
          widget.pastSymptomsList =
              generateItems(event.docs.reversed.map((doc) => doc.data()).toList());
          print(widget.pastSymptomsList);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //callDB();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Symptoms"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthGate(),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: widget.pastSymptomsList == null
          ? const Text("Loading")
          : SingleChildScrollView(
              child: Container(
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      widget.pastSymptomsList![index].isExpanded = isExpanded;
                    });
                  },
                  children:
                      widget.pastSymptomsList!.map<ExpansionPanel>((Item item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(item.headerValue),
                        );
                      },
                      body: ListTile(
                        title: Text(item.expandedValue),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            widget.db
                                .collection("users")
                                .doc(widget.user.uid)
                                .collection("Symptoms")
                                .doc(item.docID)
                                .delete();
                            setState(() {
                              widget.pastSymptomsList!.removeWhere(
                                  (Item currentItem) => item == currentItem);
                            });
                          },
                        ),
                      ),
                      isExpanded: item.isExpanded,
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
