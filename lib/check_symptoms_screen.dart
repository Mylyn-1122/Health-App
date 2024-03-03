import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/auth_gate.dart';
import 'body_symptom.dart';
import 'assessment_screen.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class SymptomPage extends StatefulWidget {
  const SymptomPage({super.key, required this.user});
  final User user;
  @override
  State<SymptomPage> createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> {
  Map<String, bool> allSymptoms = {
    "fever": false,
    "dry cough": false,
    "wet cough": false,
    "soar throat": false,
    "sneezing": false,
    "runny nose": false,
    "headache": false,
    "stomach ache": false,
    "fatigue": false,
    "difficulty breathing": false,
  };

  @override
  Widget build(BuildContext context) {
    List<Widget> symptomButtons = allSymptoms.keys.map((key) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              allSymptoms[key] = !allSymptoms[key]!;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: allSymptoms[key]! ? Colors.blue : Colors.grey,
            padding: const EdgeInsets.all(8.0),
          ),
          child: Text(key),
        ),
      );
    }).toList();
    symptomButtons.add(
      Container(
        child: ElevatedButton(
          onPressed: () {
            List selectedSymptoms = allSymptoms.keys
                .where((element) => allSymptoms[element]!)
                .toList();
            String symptomString = "I have a ${selectedSymptoms.join(" and ")}";
            if (selectedSymptoms.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AssessmentPage(
                    symptoms: symptomString,
                    user:widget.user,
                  ),
                ),
              );
            }
          },
          child: const Text("submit"),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Symptoms"),
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BodySymptomPage(user:widget.user),
                ),
              );
            },
            child: Image.asset(
              "assets/image/body.png",
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: symptomButtons,
          )
        ],
      ),
    );
  }
}
