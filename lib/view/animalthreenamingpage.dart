// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moca_geriuff_user_interface/appservice.dart';
import 'package:moca_geriuff_user_interface/components/newstopwatch.dart';
import 'package:moca_geriuff_user_interface/view/initialpage.dart';
import 'package:provider/provider.dart';

class AnimalThreeNamingPage extends StatefulWidget {
  const AnimalThreeNamingPage({Key? key}) : super(key: key);

  @override
  AnimalThreeNamingPageState createState() => AnimalThreeNamingPageState();
}

class AnimalThreeNamingPageState extends State<AnimalThreeNamingPage> {
  final textController = TextEditingController();
  String? testId;

  @override
  void initState() {
    super.initState();
    getTestId(context).then((value) {
      setState(() {
        testId = value;
      });
    });
  }

  Future<String?> getTestId(BuildContext context) async {
    return await context.read<AppService>().getLatestUnfinishedTestId();
  }

  Future<void> updateNamingThree(text) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('Tests').doc(testId).update({
      'namingThree': text,
    });
  }

  Future<void> updateTestFinished() async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('Tests').doc(testId).update({
      'testFinished': true,
    });
  }

  getTimes(String time, testID) async {
    DocumentReference patientRef =
        FirebaseFirestore.instance.collection('Tests').doc(testID);
    await patientRef.update({
      'times': FieldValue.arrayUnion([time]),
    });
  }

  NewStopWatch stopWatch = const NewStopWatch();
  NewStopWatchState stopWatchState = NewStopWatchState();

  @override
  Widget build(BuildContext context) {
    String elapsedTime = stopWatchState.getElapsedTime();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65,
        title: const Center(child: Text('Nomeação')),
        actions: const [NewStopWatch()],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image.asset('assets/images/animal_three.png',
                    height: 250, width: 350),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Nomeie o animal",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: SizedBox(
                width: 500,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: "Digite a resposta aqui",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 100.0, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                    width: 170,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        String varName = textController
                            .text; // Obtenha o valor do controlador de texto

                        await updateNamingThree(varName);
                        if (varName.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                      "Digite a resposta antes de finalizar o teste!"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              });
                        } else {
                          getTimes(elapsedTime, testId);
                          await updateTestFinished();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InitialPage(),
                            ),
                          );
                        }
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Finalizar',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
