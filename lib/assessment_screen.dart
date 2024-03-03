

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:health_app/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssessmentPage extends StatefulWidget {
  final String symptoms;
  AssessmentPage({super.key, required this.symptoms, required this.user});
  final User user;
  final db = FirebaseFirestore.instance;
  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  String? result;

  @override
  void initState() {
    super.initState();
    callgpt();
    
  }

  void callgpt() async {
    OpenAI.apiKey = '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';
    const systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content:
          "Act as a medical professional. You will be given patient symptoms and respond with possible causes and remidies",
      role: OpenAIChatMessageRole.system,
    );
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: widget.symptoms,
      role: OpenAIChatMessageRole.user,
    );
    final requestMessages = [
      systemMessage,
      userMessage,
    ];

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo-1106",
      messages: requestMessages,
      temperature: 0.2,
      maxTokens: 500,
    );

    setState(() {
      result = chatCompletion.choices[0].message.content;
    });
  }

  void enterUserData() async {
    DateTime now = DateTime.now();

    // Add a new document with a generated ID
    widget.db
        .collection("users")
        .doc(widget.user.uid)
        .collection("Symptoms")
        .doc(now.millisecondsSinceEpoch.toString()).set(
      {
        "date": 
        // now.month.toString() +
        //     "/" +
        //     now.day.toString() +
        //     "/" +
        //     now.year.toString() +
        //     "   " +
        //     now.hour.toString() +
        //     ":" +
        //     now.minute.toString() + 
            now.toString(),
        "userMessage": widget.symptoms,
        "aiResponse": result!,
        "docID": now.millisecondsSinceEpoch.toString(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: Center(
        child: Column(
          children: result != null
              ? [
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      result!,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(padding:const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                      onPressed: () {
                        enterUserData();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage(user: widget.user)));
                      },
                      child: const Text("Return", style: TextStyle(fontSize:20),))
                ]
              : [
                  const SizedBox(
                    height: 50,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "loading",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
        ),
      ),
    );
    // return result != null
    //     ? Scaffold(
    //         body: Center(
    //           child: Text(result!),
    //         ),
    //       )
    //     : Text("Loading");
  }
}
