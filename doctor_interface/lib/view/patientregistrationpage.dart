// ignore_for_file: constant_identifier_names
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:projeto_final_doctor_interface/appService.dart';
import 'package:projeto_final_doctor_interface/view/doctorregistrationpage.dart';
import 'package:projeto_final_doctor_interface/view/homepage.dart';
import 'package:projeto_final_doctor_interface/view/testDataPage.dart';
import 'package:provider/provider.dart';

enum Gender { MALE, FEMALE }

class PatientRegistration extends StatefulWidget {
  const PatientRegistration({super.key});

  @override
  PatientRegistrationState createState() => PatientRegistrationState();
}

class PatientRegistrationState extends State<PatientRegistration> {
  final GlobalKey<FormState> patientRegistrationKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final cpf = TextEditingController();
  final medicalRecordNumber = TextEditingController();
  var birthdate = TextEditingController();

  Gender genderAux = Gender.FEMALE;
  String gender = 'Feminino';
  String message = "";
  String alertMessage = "";
  List<String> testsDone = [];

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
                child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: Form(
                              key: patientRegistrationKey,
                              child: Column(
                                children: <Widget>[
                                  const Text(
                                    "Cadastro de paciente",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 15, 10, 0),
                                    child: TextFormField(
                                      controller: name,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(),
                                        labelText: 'Nome',
                                      ),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Este campo é obrigatório';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 15, 10, 0),
                                    child: TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        CpfInputFormatter(),
                                      ],
                                      controller: cpf,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(),
                                        labelText: 'CPF',
                                      ),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Este campo é obrigatório';
                                        }
                                        if (!GetUtils.isCpf(value)) {
                                          return 'CPF inválido';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 15, 10, 10),
                                    child: TextFormField(
                                      controller: medicalRecordNumber,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(),
                                        labelText: 'Número do prontuário',
                                      ),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Este campo é obrigatório';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(children: [
                                    TextButton.icon(
                                      label: const Text('Feminino',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                      icon: Radio(
                                          value: Gender.FEMALE,
                                          groupValue: genderAux,
                                          onChanged: null),
                                      onPressed: () {
                                        setState(() {
                                          genderAux = Gender.FEMALE;
                                          gender = "Feminino";
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    TextButton.icon(
                                      label: const Text('Masculino',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                      icon: Radio(
                                          value: Gender.MALE,
                                          groupValue: genderAux,
                                          onChanged: null),
                                      onPressed: () {
                                        setState(() {
                                          genderAux = Gender.MALE;
                                          gender = "Masculino";
                                        });
                                      },
                                    ),
                                  ]),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 10),
                                      child: TextFormField(
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Este campo é obrigatório';
                                          }
                                          return null;
                                        },
                                        controller: birthdate,
                                        decoration: const InputDecoration(
                                            icon: Icon(Icons.calendar_today),
                                            labelText: "Data de nascimento"),
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1920),
                                                  lastDate: DateTime(2101));

                                          if (pickedDate != null) {
                                            String formattedDate =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(pickedDate);

                                            setState(() {
                                              birthdate.text =
                                                  formattedDate.toString();
                                            });
                                          }
                                        },
                                      )),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color(0xFF0097b2),
                                        ),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.fromLTRB(
                                                40.0, 20.0, 40.0, 20.0)),
                                      ),
                                      child: const Text('Confirmar',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white)),
                                      onPressed: () {
                                        if (patientRegistrationKey.currentState!
                                            .validate()) {
                                          context
                                              .read<AppService>()
                                              .patientRegistration(
                                                  name.text,
                                                  cpf.text,
                                                  medicalRecordNumber.text,
                                                  gender,
                                                  birthdate.text,
                                                  testsDone)
                                              .then((value) {
                                            alertMessage = value;
                                            if (alertMessage == "Signed Up") {
                                              setState(() {
                                                message =
                                                    "Cadastro realizado com sucesso!";
                                                name.clear();
                                                cpf.clear();
                                                medicalRecordNumber.clear();
                                                birthdate.clear();
                                              });
                                            } else {
                                              setState(() {
                                                message =
                                                    "Erro ao efetuar cadastro";
                                              });
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  if (message ==
                                          "Cadastro realizado com sucesso!" ||
                                      message == "Erro ao efetuar cadastro")
                                    Container(
                                      color: const Color(0xFF8cbabd),
                                      child: ListTile(
                                          title: Text(message,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0)),
                                          leading: const Icon(Icons.error),
                                          trailing: IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                setState(() {
                                                  message = "";
                                                });
                                              })),
                                    ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ]),
              )
            ],
          ),
        )
      ],
    ));
  }
}
