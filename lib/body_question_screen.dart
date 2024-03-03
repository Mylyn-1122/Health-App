import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:health_app/api_key.dart';
import 'package:health_app/auth_gate.dart';
import 'assessment_screen.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BodyQuestionPage extends StatefulWidget {
  final String symptoms;
  const BodyQuestionPage(
      {super.key, required this.symptoms, required this.user});
  final User user;
  @override
  State<BodyQuestionPage> createState() => _BodyQuestionPageState();
}

class _BodyQuestionPageState extends State<BodyQuestionPage> {
  String? result;

  @override
  void initState() {
    super.initState();
    callgpt();
  }

  void callgpt() async {
    OpenAI.apiKey = openAI_key;
    const systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content:
          "Act as a medical professional. You will be given a body part that a patient is having trouble with and give a follow up question.",
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

  @override
  Widget build(BuildContext context) {
    String userResponce = "";
    return Scaffold(
        appBar: AppBar(
          title: const Text("Result"),
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
        body: result != null
            ? Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Text(
                      result!,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 20),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type response here',
                      ),
                      onChanged: (value) {
                        userResponce = value;
                      },
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20)),
                      onPressed: () {
                        String symptomString =
                            "I'm having trouble with my ${widget.symptoms}. $userResponce";
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AssessmentPage(
                              symptoms: symptomString,
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 25),
                      ))
                ],
              )
            : const Center(
                child: Text("Loading"),
              ));
  }
}
