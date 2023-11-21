// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final/appservice.dart';
import 'package:projeto_final/components/newstopwatch.dart';
import 'package:projeto_final/view/animalthreenamingpage.dart';
import 'package:provider/provider.dart';

class AnimalTwoNamingPage extends StatefulWidget {
  const AnimalTwoNamingPage({Key? key}) : super(key: key);

  @override
  AnimalTwoNamingPageState createState() => AnimalTwoNamingPageState();
}

class AnimalTwoNamingPageState extends State<AnimalTwoNamingPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTestId(context).then((value) {
      setTestId(value);
    });
  }

  Future<String?> getTestId(BuildContext context) async {
    return await context.read<AppService>().getLatestUnfinishedTestId();
  }

  String? testId;

  void setTestId(String? value) {
    setState(() {
      testId = value;
    });
  }

  Future<void> updateNamingTwo(text) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('Tests').doc(testId).update({
      'namingTwo': text,
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
                    child: Image.asset('assets/images/animal_two.png',
                        height: 250, width: 350))),
            const Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Nomeie o animal",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    )
                  ],
                )),
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
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          )),
                    ))),
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 100.0, bottom: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                SizedBox(
                  height: 50,
                  width: 170,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      String varName = textController
                          .text; // Obtenha o valor do controlador de texto

                      await updateNamingTwo(varName);

                      if (varName.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    "Digite a resposta antes de prosseguir!"),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AnimalThreeNamingPage(),
                          ),
                        );
                      }
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Próximo',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
