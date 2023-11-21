import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final_doctor_interface/appService.dart';
import 'package:projeto_final_doctor_interface/view/doctorregistrationpage.dart';
import 'package:projeto_final_doctor_interface/view/homepage.dart';
import 'package:projeto_final_doctor_interface/view/patientRegistrationPage.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:searchfield/searchfield.dart';

class TestDataPage extends StatefulWidget {
  const TestDataPage({super.key});

  @override
  TestDataPageState createState() => TestDataPageState();
}

class TestDataPageState extends State<TestDataPage> {
  String? patientName;
  String? patientId;
  late String textObs;
  late int totalHours;
  late int totalMinutes;
  late int totalSeconds;
  List<Duration> auxTimes = [];

  @override
  Widget build(BuildContext context) {
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
                            padding:
                                const EdgeInsets.only(bottom: 30, right: 30),
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
                            padding:
                                const EdgeInsets.only(bottom: 30, right: 30),
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
                            padding:
                                const EdgeInsets.only(bottom: 30, right: 30),
                            child: IconButton(
                                icon: const Icon(Icons.assignment,
                                    size: 60,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const TestDataPage()));
                                })),
                        const Text(
                          "Testes aplicados",
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ]),
                    ])),
              ),
              Expanded(
                  child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                            child: Text(
                          "Testes Aplicados",
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ))),
                    const Padding(
                        padding: EdgeInsets.only(top: 20, left: 50),
                        child: Text(
                          "Para visualizar os testes realizados por um paciente realize a busca pelo nome do paciente.",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
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
                              final patients =
                                  snapshot.data?.docs.reversed.toList();
                              if (!snapshot.hasData) {
                                return const SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              } else {
                                for (var patient in patients!) {
                                  patientItems.add(patient['name']);
                                }
                              }
                              return SearchField<String>(
                                searchInputDecoration: const InputDecoration(
                                    icon: Icon(Icons.search),
                                    border: InputBorder.none),
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
                                hint: 'Busca',
                                searchStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                validator: (x) {
                                  if (!patientItems.contains(x) || x!.isEmpty) {
                                    return 'Campo obrigatório';
                                  }
                                  return null;
                                },
                                onSuggestionTap:
                                    (SearchFieldListItem<String> x) {
                                  setState(() {
                                    patientName = x.item!;
                                    patientId = patients
                                        .firstWhere((patient) =>
                                            patient['name'] == patientName)
                                        .id;
                                  });
                                },
                              );
                            },
                          ),
                        )),
                    if (patientId != null)
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Tests')
                              .where('patientId', isEqualTo: patientId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            List<DocumentSnapshot> tests = snapshot.data!.docs;
                            if (tests.isEmpty) {
                              return const Center(
                                  child: Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Text(
                                        "Não foram encontrados testes realizados pelo paciente selecionado!",
                                        style: TextStyle(fontSize: 16),
                                      )));
                            }
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: tests.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> testData = tests[index]
                                      .data() as Map<String, dynamic>;

                                  dynamic timestampValue = testData['date'];

                                  int timestamp = timestampValue is int
                                      ? timestampValue
                                      : (timestampValue as Timestamp)
                                          .millisecondsSinceEpoch;

                                  DateTime date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          timestamp);

                                  String formattedDate =
                                      DateFormat('dd/MM/yyyy').format(date);

                                  if (testData['times'] != null &&
                                      testData['times'].isNotEmpty) {
                                    List<String> times =
                                        List<String>.from(testData['times']);

                                    Duration totalTime = Duration.zero;

                                    for (String time in times) {
                                      List<int> timeValues = time
                                          .split(':')
                                          .map(int.parse)
                                          .toList();
                                      Duration timeDuration = Duration(
                                          hours: timeValues[0],
                                          minutes: timeValues[1],
                                          seconds: timeValues[2]);
                                      auxTimes.add(timeDuration);
                                      totalTime += timeDuration;
                                    }

                                    totalHours = totalTime.inHours;
                                    totalMinutes = (totalTime.inMinutes % 60);
                                    totalSeconds = (totalTime.inSeconds % 60);
                                  }

                                  if (testData['obs'] != "") {
                                    textObs = "Observações: ";
                                  } else {
                                    textObs = " ";
                                  }
                                  return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40, right: 40),
                                      child: Card(
                                        child: ExpansionTile(
                                          title: Text(
                                            'Data da aplicação: $formattedDate\n',
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                              'Médico aplicador: ${testData['doctorName']}\n\nPaciente: $patientName\n\nPontuação total: ${testData['finalScore']}\n\nTempo total gasto: $totalHours horas, $totalMinutes minutos, $totalSeconds segundos',
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w100)),
                                          children: [
                                            const Text(
                                              "Visão Espacial",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30),
                                              child: Column(children: [
                                                Column(children: [
                                                  Image.network(
                                                    testData['imageCube'],
                                                    height: 400,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'Tempo gasto: ${auxTimes[0].inHours} horas, ${auxTimes[0].inMinutes} minutos, ${auxTimes[0].inSeconds} segundos',
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ]),
                                                const SizedBox(height: 20),
                                                Column(children: [
                                                  Image.network(
                                                    testData['imageClock'],
                                                    height: 400,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'Tempo gasto: ${auxTimes[1].inHours} horas, ${auxTimes[1].inMinutes} minutos, ${auxTimes[1].inSeconds} segundos',
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ]),
                                                const SizedBox(height: 20),
                                                Column(children: [
                                                  Image.network(
                                                    testData['imagePoints'],
                                                    height: 500,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'Tempo gasto: ${auxTimes[2].inHours} horas, ${auxTimes[2].inMinutes} minutos, ${auxTimes[2].inSeconds} segundos',
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ])
                                              ]),
                                            ),
                                            const SizedBox(height: 30),
                                            Text(
                                              "Pontuação: ${testData['scoreOne']}",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(height: 50),
                                            const Text(
                                              "Nomeação",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 10),
                                            Column(children: [
                                              Text(
                                                "${testData['namingOne']}",
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Tempo gasto: ${auxTimes[3].inHours} horas, ${auxTimes[3].inMinutes} minutos, ${auxTimes[3].inSeconds} segundos',
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              )
                                            ]),
                                            const SizedBox(height: 20),
                                            Column(children: [
                                              Text(
                                                "${testData['namingTwo']}",
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Tempo gasto: ${auxTimes[4].inHours} horas, ${auxTimes[4].inMinutes} minutos, ${auxTimes[4].inSeconds} segundos',
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              )
                                            ]),
                                            const SizedBox(height: 20),
                                            Column(children: [
                                              Text(
                                                "${testData['namingThree']}",
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Tempo gasto: ${auxTimes[5].inHours} horas, ${auxTimes[5].inMinutes} minutos, ${auxTimes[5].inSeconds} segundos',
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              )
                                            ]),
                                            const SizedBox(height: 30),
                                            Text(
                                              "Pontuação: ${testData['scoreTwo']}",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(height: 50),
                                            const Text(
                                              "Atenção",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              "Pontuação 1: ${testData['scoreThreePartOne']}",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              "Pontuação 2: ${testData['scoreThreePartTwo']}",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              "Pontuação 3: ${testData['scoreThreePartThree']}",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(height: 50),
                                            const Text(
                                              "Linguagem",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              "Pontuação 1: ${testData['scoreFourPartOne']}",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              "Pontuação 2: ${testData['scoreFourPartTwo']}",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(height: 50),
                                            const Text(
                                              "Abstração",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              "Pontuação: ${testData['scoreFive']}",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(height: 50),
                                            const Text(
                                              "Evocação Tardia",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              "Pontuação: ${testData['scoreSix']}",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(height: 50),
                                            const Text(
                                              "Orientação",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              "Pontuação: ${testData['scoreSeven']}",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(height: 50),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40,
                                                    top: 50.0,
                                                    bottom: 20),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        textObs,
                                                        style: const TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${testData['obs']}",
                                                        style: const TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ])),
                                          ],
                                        ),
                                      ));
                                });
                          })
                  ])),
                ],
              ))
            ],
          )),
        ],
      ),
    );
  }
}
