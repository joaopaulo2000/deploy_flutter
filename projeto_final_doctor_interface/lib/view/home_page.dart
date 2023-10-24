// ignore_for_file: library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final_doctor_interface/appService.dart';
import 'package:projeto_final_doctor_interface/view/doctorRegistration_page.dart';
import 'package:projeto_final_doctor_interface/view/patientRegistration_page.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  

  @override
  _HomePageState createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> homeKey = GlobalKey();
  String? patientName;
  String? doctorName; 
  String? patientId;
  List<String> img1 = [];
  List<String> img2 = [];
  List<String> img3 = [];


  @override
  Widget build(BuildContext context) {
    doctorName = context.read<AppService>().getDoctorName(); // ou defina um valor padrão apropriado

    return Scaffold(
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
                    await context.read<AppService>().signOut();
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
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            const DoctorRegistrationPage()));
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
                        "Teste MOCA GeriUFF",
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
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
                      Row(children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: Text("Paciente: ",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const Padding(padding: EdgeInsets.all(4)),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Patients')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                List<String> patientItems = [];
                                final patients =
                                    snapshot.data?.docs.reversed.toList();
                                if (!snapshot.hasData) {
                                  const CircularProgressIndicator();
                                } else {
                                  final patients =
                                      snapshot.data?.docs.reversed.toList();

                                  for (var patient in patients!) {
                                    patientItems.add(
                                      patient['name'],
                                    );
                                  }
                                }
                                return SearchField<String>(
                                  suggestions: patientItems
                                      .map(
                                        (e) => SearchFieldListItem<String>(
                                          e,
                                          item: e,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 10),
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
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                  validator: (x) {
                                    if (!patientItems.contains(x) ||
                                        x!.isEmpty) {
                                      return 'Campo obrigatório';
                                    }
                                    return null;
                                  },
                                  onSuggestionTap:
                                      (SearchFieldListItem<String> x) {
                                    setState(() {
                                      patientName = x.item!;
                                      patientId = patients!
                                          .firstWhere((patient) =>
                                              patient['name'] == patientName)
                                          .id; // Obtenha o ID do paciente selecionado
                                    });
                                  },
                                );
                              }),
                        ),
                      ]),
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
                                    img1, 
                                    img2, 
                                    img3
                                  );
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

