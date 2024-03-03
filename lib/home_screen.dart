import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/auth_gate.dart';
import 'check_symptoms_screen.dart';
import 'past_symptoms_screen.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home"),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.displayName != null ? "Welcome ${user.displayName!}" : "Welcome. You can add your name in the profile page."),
            const SizedBox(height: 75,)
            ,
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  SymptomPage(user:user)));
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(50)),
                child: const Text("Add Symptom",)),
            const SizedBox(
              height: 75,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>  PastSymptomsPage(user:user)));
              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(50)),
              child: const Text("Past Symptoms"),
            ),
            
            
          ],
        ),
      ),
    );
  }
}
