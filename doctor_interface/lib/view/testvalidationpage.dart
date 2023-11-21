// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_final_doctor_interface/appService.dart';
import 'package:projeto_final_doctor_interface/view/doctorregistrationpage.dart';
import 'package:projeto_final_doctor_interface/view/homepage.dart';
import 'package:projeto_final_doctor_interface/view/patientregistrationpage.dart';
import 'package:projeto_final_doctor_interface/view/testDataPage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ValidateTestPage extends StatefulWidget {
  final String? patientId;
  final String? testID;

  const ValidateTestPage(this.patientId, this.testID, {Key? key})
      : super(key: key);

  @override
  ValidateTestPageState createState() => ValidateTestPageState();
}

class ValidateTestPageState extends State<ValidateTestPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final obsTextController = TextEditingController();
  final score1Controller = TextEditingController();
  final score2Controller = TextEditingController();
  final score3Parte1Controller = TextEditingController();
  final score3Parte2Controller = TextEditingController();
  final score3Parte3Controller = TextEditingController();
  final score4Parte1Controller = TextEditingController();
  final score4Parte2Controller = TextEditingController();
  final score5Controller = TextEditingController();
  final score6Controller = TextEditingController();
  final score7Controller = TextEditingController();
  final namingOneTextController = TextEditingController();
  final namingTwoTextController = TextEditingController();
  final namingThreeTextController = TextEditingController();

  String? doctorName;
  String? patientName;
  bool? testStatus;
  late String testNamingOne;
  late String testNamingTwo;
  late String testNamingThree;
  late String testUrlImageOne;
  late String testUrlImageTwo;
  late String testUrlImageThree;
  late int aux1;
  late int aux2;
  late int aux3Part1;
  late int aux3Part2;
  late int aux3Part3;
  late int aux4Part1;
  late int aux4Part2;
  late int aux5;
  late int aux6;
  late int aux7;
  late int finalScore;
  late List<dynamic> testsTimes;
  late int totalHours;
  late int totalMinutes;
  late int totalSeconds;

  StreamSubscription<DocumentSnapshot>? _streamSubscription;

  Future<void> updateScoresAndObs(
      scoreOne,
      scoreTwo,
      scoreThreePartOne,
      scoreThreePartTwo,
      scoreThreePartThree,
      scoreFourPartOne,
      scoreFourPartTwo,
      scoreFive,
      scoreSix,
      scoreSeven,
      finalScore,
      obs,
      testId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('Tests').doc(testId).update({
      'scoreOne': scoreOne,
      'scoreTwo': scoreTwo,
      'scoreThreePartOne': scoreThreePartOne,
      'scoreThreePartTwo': scoreThreePartTwo,
      'scoreThreePartThree': scoreThreePartThree,
      'scoreFourPartOne': scoreFourPartOne,
      'scoreFourPartTwo': scoreFourPartTwo,
      'scoreFive': scoreFive,
      'scoreSix': scoreSix,
      'scoreSeven': scoreSeven,
      'finalScore': finalScore,
      'obs': obs,
    });
  }

  @override
  void initState() {
    super.initState();

    final testDocumentRef =
        FirebaseFirestore.instance.collection('Tests').doc(widget.testID);
    final stream = testDocumentRef.snapshots();

    _streamSubscription = stream.listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        bool testFinished = documentSnapshot.get('testFinished');
        String namingOne = documentSnapshot.get('namingOne');
        String namingTwo = documentSnapshot.get('namingTwo');
        String namingThree = documentSnapshot.get('namingThree');
        String urlImageOne = documentSnapshot.get('imageCube');
        String urlIImageTwo = documentSnapshot.get('imageClock');
        String urlIImageTree = documentSnapshot.get('imagePoints');
        List<dynamic> times = documentSnapshot.get('times');
        setState(() {
          testStatus = testFinished;
          testNamingOne = namingOne;
          testNamingTwo = namingTwo;
          testNamingThree = namingThree;
          testUrlImageOne = urlImageOne;
          testUrlImageTwo = urlIImageTwo;
          testUrlImageThree = urlIImageTree;
          testsTimes = times;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String? testIdAux = widget.testID;
    String? doctorName = context.read<AppService>().getDoctorName();

    Future<String?> getPatientName() async {
      return await context.read<AppService>().getPatientName(testIdAux);
    }

    getPatientName().then((value) {
      setState(() {
        patientName = value;
      });
    });

    List<Duration> auxTimes = [];
    Duration totalTime = Duration.zero;

    if (testsTimes != [] && testsTimes.isNotEmpty) {
      for (String time in testsTimes) {
        List<int> timeValues = time.split(':').map(int.parse).toList();
        Duration timeDuration = Duration(
            hours: timeValues[0],
            minutes: timeValues[1],
            seconds: timeValues[2]);
        totalTime += timeDuration;
        auxTimes.add(timeDuration);
      }

      totalHours = totalTime.inHours;
      totalMinutes = (totalTime.inMinutes % 60);
      totalSeconds = (totalTime.inSeconds % 60);
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
      Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child:
                  Image.asset('assets/images/img.png', height: 80, width: 80)),
          const SizedBox(width: 20),
          const Text("MOCA",
              style: TextStyle(
                fontSize: 26.0,
                color: Color(0xFF0097b2),
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(width: 5),
          const Text("GeriUFF",
              style: TextStyle(
                fontSize: 26.0,
                color: Color(0xFF8cbabd),
                fontWeight: FontWeight.bold,
              )),
          const Expanded(child: SizedBox()),
          Row(
            children: [
              IconButton(
                icon: Image.asset('assets/images/logout.png'),
                iconSize: 30,
                onPressed: () async {
                  await context.read<AppService>().signOut(context);
                },
              ),
              const Text("Sair",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xFF8cbabd),
                    fontWeight: FontWeight.w200,
                  ))
            ],
          ),
          const SizedBox(width: 50),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        height: 3,
        decoration: const BoxDecoration(color: Color(0xFF0097b2)),
      ),
      Expanded(
          child: Row(children: [
        Align(
            alignment: Alignment.topLeft,
            child: Container(
                width: 150,
                color: const Color(0xFF0097b2),
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Column(children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 30, right: 30),
                        child: IconButton(
                            icon: const Icon(Icons.assignment_add,
                                size: 60,
                                color: Color.fromARGB(255, 255, 255, 255)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                            })),
                    const Text(
                      "Aplicar teste",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ]),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 30, right: 30),
                        child: IconButton(
                            icon: const Icon(Icons.assignment_add,
                                size: 60,
                                color: Color.fromARGB(255, 255, 255, 255)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const PatientRegistration()));
                            })),
                    const Text(
                      "Cadastrar paciente",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ]),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 30, right: 30),
                        child: IconButton(
                            icon: const Icon(Icons.assignment_add,
                                size: 60,
                                color: Color.fromARGB(255, 255, 255, 255)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const DoctorRegistrationPage()));
                            })),
                    const Text(
                      "Cadastrar médico",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ]),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 30, right: 30),
                        child: IconButton(
                            icon: const Icon(Icons.assignment,
                                size: 60,
                                color: Color.fromARGB(255, 255, 255, 255)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const DoctorRegistrationPage()));
                            })),
                    const Text(
                      "Testes aplicados",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ]),
                ]))),
        Expanded(
            child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              const Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Avaliação do Teste",
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ))),
              const SizedBox(height: 20),
              if (patientName != null)
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          "Médico aplicador: ",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          doctorName!,
                          style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 40),
                    child: Row(
                      children: [
                        const Text(
                          "Paciente: ",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          patientName!,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                          ),
                        )
                      ],
                    ),
                  ),
                  if (testStatus == false)
                    const Column(children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Teste em progresso",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    ])
                  else
                    Column(children: [
                      const Text(
                        "Visão Espacial",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(children: [
                            Image.network(
                              testUrlImageOne,
                              height: 300,
                              width: 600,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tempo gasto: ${auxTimes[0].inHours} horas, ${auxTimes[0].inMinutes} minutos, ${auxTimes[0].inSeconds} segundos',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w300),
                            ),
                          ])),
                      Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(children: [
                            Image.network(
                              testUrlImageTwo,
                              height: 300,
                              width: 600,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tempo gasto: ${auxTimes[1].inHours} horas, ${auxTimes[1].inMinutes} minutos, ${auxTimes[1].inSeconds} segundos',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w300),
                            ),
                          ])),
                      Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(children: [
                            Image.network(
                              testUrlImageThree,
                              height: 300,
                              width: 600,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tempo gasto: ${auxTimes[2].inHours} horas, ${auxTimes[2].inMinutes} minutos, ${auxTimes[2].inSeconds} segundos',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w300),
                            )
                          ])),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: score1Controller,
                                decoration: const InputDecoration(
                                  labelText: 'Pontuação',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF6200EE),
                                  ),
                                  helperText: '_/5',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.blueAccent)),
                                ),
                              ))),
                      const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text(
                            "Nomeação",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(children: [
                            Text(
                              testNamingOne,
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tempo gasto: ${auxTimes[3].inHours} horas, ${auxTimes[3].inMinutes} minutos, ${auxTimes[3].inSeconds} segundos',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w300),
                            )
                          ])),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(children: [
                            Text(
                              testNamingTwo,
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tempo gasto: ${auxTimes[4].inHours} horas, ${auxTimes[4].inMinutes} minutos, ${auxTimes[4].inSeconds} segundos',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w300),
                            )
                          ])),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(children: [
                            Text(
                              testNamingThree,
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tempo gasto: ${auxTimes[5].inHours} horas, ${auxTimes[5].inMinutes} minutos, ${auxTimes[5].inSeconds} segundos',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w300),
                            )
                          ])),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: score2Controller,
                                decoration: const InputDecoration(
                                    labelText: 'Pontuação',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF6200EE),
                                    ),
                                    helperText: '_/3',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3,
                                            color: Colors.blueAccent))),
                              ))),
                      const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text(
                            "Atenção",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: score3Parte1Controller,
                                decoration: const InputDecoration(
                                    labelText: 'Pontuação 1',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF6200EE),
                                    ),
                                    helperText: '_/2',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3,
                                            color: Colors.blueAccent))),
                              ))),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: score3Parte2Controller,
                                decoration: const InputDecoration(
                                    labelText: 'Pontuação 2',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF6200EE),
                                    ),
                                    helperText: '_/1',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3,
                                            color: Colors.blueAccent))),
                              ))),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: score3Parte3Controller,
                                decoration: const InputDecoration(
                                    labelText: 'Pontuação 3',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF6200EE),
                                    ),
                                    helperText: '_/3',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3,
                                            color: Colors.blueAccent))),
                              ))),
                      const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text(
                            "Linguagem",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: score4Parte1Controller,
                                decoration: const InputDecoration(
                                    labelText: 'Pontuação 1',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF6200EE),
                                    ),
                                    helperText: '_/2',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3,
                                            color: Colors.blueAccent))),
                              ))),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: score4Parte2Controller,
                                decoration: const InputDecoration(
                                    labelText: 'Pontuação 2',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF6200EE),
                                    ),
                                    helperText: '_/1',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3,
                                            color: Colors.blueAccent))),
                              ))),
                      const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text(
                            "Abstração",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: score5Controller,
                                decoration: const InputDecoration(
                                    labelText: 'Pontuação',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF6200EE),
                                    ),
                                    helperText: '_/2',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3,
                                            color: Colors.blueAccent))),
                              ))),
                      const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text(
                            "Evocação Tardia",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: score6Controller,
                                decoration: const InputDecoration(
                                    labelText: 'Pontuação',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF6200EE),
                                    ),
                                    helperText: '_/5',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3,
                                            color: Colors.blueAccent))),
                              ))),
                      const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text(
                            "Orientação",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: score7Controller,
                                decoration: const InputDecoration(
                                    labelText: 'Pontuação',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF6200EE),
                                    ),
                                    helperText: '_/6',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3,
                                            color: Colors.blueAccent))),
                              ))),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 40, top: 50.0, bottom: 10),
                          child: Row(
                            children: [
                              const Text(
                                'Tempo total gasto: ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$totalHours horas, $totalMinutes minutos, $totalSeconds segundos',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 40, top: 20.0, bottom: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Observações: ",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                    width: 900,
                                    child: TextField(
                                      textAlign: TextAlign.start,
                                      controller: obsTextController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3,
                                                color: Colors.blueAccent)),
                                      ),
                                    ))
                              ])),
                      Padding(
                          padding: const EdgeInsets.only(
                              right: 10, top: 20.0, bottom: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                    height: 50,
                                    width: 150,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (score1Controller.text.isEmpty ||
                                            score2Controller.text.isEmpty ||
                                            score3Parte1Controller
                                                .text.isEmpty ||
                                            score3Parte2Controller
                                                .text.isEmpty ||
                                            score4Parte1Controller
                                                .text.isEmpty ||
                                            score4Parte2Controller
                                                .text.isEmpty ||
                                            score5Controller.text.isEmpty ||
                                            score6Controller.text.isEmpty ||
                                            score7Controller.text.isEmpty) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Atribua todas as pontuações antes de prosseguir!"),
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
                                          aux1 =
                                              int.parse(score1Controller.text);
                                          aux2 =
                                              int.parse(score2Controller.text);
                                          aux3Part1 = int.parse(
                                              score3Parte1Controller.text);
                                          aux3Part2 = int.parse(
                                              score3Parte2Controller.text);
                                          aux3Part3 = int.parse(
                                              score3Parte3Controller.text);
                                          aux4Part1 = int.parse(
                                              score4Parte1Controller.text);
                                          aux4Part2 = int.parse(
                                              score4Parte2Controller.text);
                                          aux5 =
                                              int.parse(score5Controller.text);
                                          aux6 =
                                              int.parse(score6Controller.text);
                                          aux7 =
                                              int.parse(score7Controller.text);
                                          finalScore = aux1 +
                                              aux2 +
                                              aux3Part1 +
                                              aux3Part2 +
                                              aux3Part3 +
                                              aux4Part1 +
                                              aux4Part2 +
                                              aux5 +
                                              aux6 +
                                              aux7;

                                          await updateScoresAndObs(
                                              score1Controller.text,
                                              score2Controller.text,
                                              score3Parte1Controller.text,
                                              score3Parte2Controller.text,
                                              score3Parte3Controller.text,
                                              score4Parte1Controller.text,
                                              score4Parte2Controller.text,
                                              score5Controller.text,
                                              score6Controller.text,
                                              score7Controller.text,
                                              finalScore,
                                              obsTextController.text,
                                              testIdAux);

                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TestDataPage()));
                                        }
                                      },
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Salvar',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.save,
                                            size: 15.0,
                                          ),
                                        ],
                                      ),
                                    ))
                              ]))
                    ])
                ])
              else
                const SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: Center(child: CircularProgressIndicator()),
                )
            ])),
          ],
        ))
      ]))
    ]));
  }
}
