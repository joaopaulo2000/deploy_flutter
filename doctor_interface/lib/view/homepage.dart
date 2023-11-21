import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final_doctor_interface/appService.dart';
import 'package:projeto_final_doctor_interface/view/doctorregistrationpage.dart';
import 'package:projeto_final_doctor_interface/view/patientRegistrationPage.dart';
import 'package:projeto_final_doctor_interface/view/testDataPage.dart';
import 'package:projeto_final_doctor_interface/view/testValidationPage.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<FormState> homeKey = GlobalKey();
  String patientName = "";
  String? patientId;
  String? img1 = "";
  String? img2 = "";
  String? img3 = "";
  String? naming1 = "";
  String? naming2 = "";
  String? naming3 = "";
  String? doctorName = "";
  String? testId;
  String? scoreOne = "";
  String? scoreTwo = "";
  String? scoreThreePartOne = "";
  String? scoreThreePartTwo = "";
  String? scoreThreePartThree = "";
  String? scoreFourPartOne = "";
  String? scoreFourPartTwo = "";
  String? scoreFive = "";
  String? scoreSix = "";
  String? scoreSeven = "";
  String? finalScore = "";
  String? obs = "";
  List<String> times = [];

  @override
  Widget build(BuildContext context) {
    doctorName = context.read<AppService>().getDoctorName();
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
      children: [
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Image.asset('assets/images/img.png',
                    height: 80, width: 80)),
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
          child: Row(
            children: [
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
                              padding:
                                  const EdgeInsets.only(bottom: 30, right: 30),
                              child: IconButton(
                                  icon: const Icon(Icons.assignment_add,
                                      size: 60,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()));
                                  })),
                          const Text(
                            "Aplicar teste",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ]),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 30, right: 30),
                              child: IconButton(
                                  icon: const Icon(Icons.assignment_add,
                                      size: 60,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PatientRegistration()));
                                  })),
                          const Text(
                            "Cadastrar paciente",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ]),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 30, right: 30),
                              child: IconButton(
                                  icon: const Icon(Icons.assignment_add,
                                      size: 60,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            const DoctorRegistrationPage()));
                                  })),
                          const Text(
                            "Cadastrar médico",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ]),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 30, right: 30),
                              child: IconButton(
                                  icon: const Icon(Icons.assignment,
                                      size: 60,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TestDataPage()));
                                  })),
                          const Text(
                            "Testes aplicados",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ]),
                      ]))),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Form(
                    key: homeKey,
                    child: Column(children: <Widget>[
                      const Text(
                        "Aplicação do teste MOCA",
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(children: [
                            const Text("Médico aplicador: ",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text(doctorName!,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200))
                          ])),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(children: [
                            const Text("Paciente: ",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Patients')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        List<String> patientItems = [];
                                        final patients = snapshot
                                            .data?.docs.reversed
                                            .toList();
                                        if (!snapshot.hasData) {
                                          const SizedBox(
                                            height: 50.0,
                                            width: 50.0,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          );
                                        } else {
                                          final patients = snapshot
                                              .data?.docs.reversed
                                              .toList();

                                          for (var patient in patients!) {
                                            patientItems.add(
                                              patient['name'],
                                            );
                                          }
                                        }
                                        return SearchField<String>(
                                          searchInputDecoration:
                                              const InputDecoration(
                                                  icon: Icon(Icons.search),
                                                  border: InputBorder.none),
                                          suggestions: patientItems
                                              .map(
                                                (e) =>
                                                    SearchFieldListItem<String>(
                                                  e,
                                                  item: e,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(e),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          hint: 'Selecione o nome do paciente',
                                          searchStyle: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                          onSuggestionTap:
                                              (SearchFieldListItem<String> x) {
                                            setState(() {
                                              patientName = x.item!;
                                              patientId = patients!
                                                  .firstWhere((patient) =>
                                                      patient['name'] ==
                                                      patientName)
                                                  .id;
                                            });
                                          },
                                        );
                                      })),
                            ),
                          ])),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF0097b2),
                            ),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
                            ),
                          ),
                          child: const Text('Iniciar teste',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white)),
                          onPressed: () async {
                            if (patientId != null) {
                              context.read<AppService>().createTest(
                                  patientId!,
                                  doctorName!,
                                  true,
                                  false,
                                  DateTime.now(),
                                  img1!,
                                  img2!,
                                  img3!,
                                  naming1!,
                                  naming2!,
                                  naming3!,
                                  scoreOne!,
                                  scoreTwo!,
                                  scoreThreePartOne!,
                                  scoreThreePartTwo!,
                                  scoreThreePartThree!,
                                  scoreFourPartOne!,
                                  scoreFourPartTwo!,
                                  scoreFive!,
                                  scoreSix!,
                                  scoreSeven!,
                                  finalScore!,
                                  obs!,
                                  times);
                              testId = await context
                                  .read<AppService>()
                                  .getLatestUnfinishedTestId();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ValidateTestPage(patientId, testId)));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        "Selecione um paciente antes de iniciar o teste!",
                                        style: TextStyle(fontSize: 16),
                                      ),
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
                            }
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
