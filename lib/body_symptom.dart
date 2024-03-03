
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:health_app/auth_gate.dart';

import 'body_question_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BodySymptomPage extends StatefulWidget {
  String? partSelected;
  BodySymptomPage({super.key, required this.user});
  final User user;
  @override
  State<BodySymptomPage> createState() => _BodySymptomPageState();
}

class _BodySymptomPageState extends State<BodySymptomPage> {
  @override
  Widget build(BuildContext context) {
    Widget submitButton = ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BodyQuestionPage(
                symptoms: widget.partSelected!,
                user: widget.user,
              ),
            ),
          );
        },
        child: const Text("Submit"));
    return Scaffold(
      appBar: AppBar(
        title: const Text("something"),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(children: [
            Image.asset("assets/image/body.png"),
            bodyPartButton(
              height: 45,
              width: 45,
              x: 65,
              y: 10,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "head";
                });
              },
            ),
            bodyPartButton(
              height: 45,
              width: 25,
              x: 135,
              y: 210,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "right hand";
                });
              },
            ),
            bodyPartButton(
              height: 45,
              width: 25,
              x: 15,
              y: 210,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "left hand";
                });
              },
            ),
            bodyPartButton(
              height: 25,
              width: 25,
              x: 115,
              y: 80,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "right shoulder";
                });
              },
            ),
            bodyPartButton(
              height: 25,
              width: 25,
              x: 35,
              y: 80,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "left shoulder";
                });
              },
            ),
            bodyPartButton(
              height: 100,
              width: 25,
              x: 125,
              y: 110,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "right arm";
                });
              },
            ),
            bodyPartButton(
              height: 100,
              width: 25,
              x: 25,
              y: 110,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "left arm";
                });
              },
            ),
            bodyPartButton(
              height: 50,
              width: 70,
              x: 53,
              y: 100,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "chest";
                });
              },
            ),
            bodyPartButton(
              height: 50,
              width: 70,
              x: 53,
              y: 150,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "stomach";
                });
              },
            ),
            bodyPartButton(
              height: 30,
              width: 70,
              x: 53,
              y: 200,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "pelvis";
                });
              },
            ),
            bodyPartButton(
              height: 70,
              width: 35,
              x: 90,
              y: 230,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "right thigh";
                });
              },
            ),
            bodyPartButton(
              height: 70,
              width: 35,
              x: 45,
              y: 230,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "left thigh";
                });
              },
            ),
            bodyPartButton(
              height: 30,
              width: 30,
              x: 90,
              y: 300,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "right knee";
                });
              },
            ),
            bodyPartButton(
              height: 30,
              width: 30,
              x: 50,
              y: 300,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "left knee";
                });
              },
            ),
            bodyPartButton(
              height: 60,
              width: 30,
              x: 90,
              y: 330,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "right shin/calf";
                });
              },
            ),
            bodyPartButton(
              height: 60,
              width: 30,
              x: 50,
              y: 330,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "left shin/calf";
                });
              },
            ),
            bodyPartButton(
              height: 30,
              width: 30,
              x: 90,
              y: 390,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "right foot";
                });
              },
            ),
            bodyPartButton(
              height: 30,
              width: 30,
              x: 50,
              y: 390,
              onTapFunction: () {
                setState(() {
                  widget.partSelected = "left foot";
                });
              },
            ),
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.partSelected == null
                ? [const Text("Please select a body part.")]
                : [
                    Text("you have selected ${widget.partSelected}"),
                    submitButton
                  ],
          ),
        ],
      ),
    );
  }
}

class bodyPartButton extends StatefulWidget {
  //final String bodyPart;
  final double height, width, x, y;
  final Function onTapFunction;
  //final Widget parentWidget;

  const bodyPartButton(
      {super.key,
      //required this.bodyPart,
      //required this.parentWidget,
      required this.height,
      required this.width,
      required this.x,
      required this.y,
      required this.onTapFunction});

  @override
  State<bodyPartButton> createState() => _bodyPartButtonState();
}

class _bodyPartButtonState extends State<bodyPartButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.x,
      top: widget.y,
      child: GestureDetector(
        child: Container(
          width: widget.width,
          height: widget.height,
          color: const Color.fromARGB(0, 173, 151, 151),
        ),
        onTap: () {
          widget.onTapFunction();
        },
      ),
    );
  }
}
