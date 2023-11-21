// ignore_for_file: library_private_types_in_public_api
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:projeto_final_doctor_interface/appService.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final textEmail = TextEditingController();
  final textPassword = TextEditingController();
  final textEmailReset = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> resetPasswordKey = GlobalKey<FormState>();

  String message = "";
  String alertMessage = "";
  bool? resetPassword;
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        body: Column(children: <Widget>[
          Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Image.asset('assets/images/logo.png',
                      height: 300, width: 350))),
          SizedBox(
            width: 600,
            height: 310,
            child: Form(
              key: loginKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                    child: TextFormField(
                      controller: textEmail,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: 'E-mail',
                        hintText: 'exemplo@gmail.com',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 88, 79, 79),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'E-mail obrigatório';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                    child: TextFormField(
                      controller: textPassword,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(),
                          labelText: 'Senha',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 88, 79, 79),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Senha obrigatória';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF0097b2)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0)),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      onPressed: () async {
                        if (loginKey.currentState!.validate()) {
                          context
                              .read<AppService>()
                              .signIn(textEmail.text, textPassword.text)
                              .then((value) {
                            alertMessage = value;
                            if (alertMessage ==
                                "The password is invalid or the user does not have a password.") {
                              setState(() {
                                message = "Senha ou e-mail inválidos!";
                              });
                            }
                            if (alertMessage != "Signed In" &&
                                alertMessage != "" &&
                                alertMessage !=
                                    "The password is invalid or the user does not have a password.") {
                              setState(() {
                                message = "Erro ao efetuar login!";
                              });
                            }
                            return "";
                          });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "Esqueceu a senha?",
                              ),
                              TextSpan(
                                text: "       Recuperar senha",
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Esqueceu sua senha?',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            content: SizedBox(
                                                height: 245,
                                                width: 200,
                                                child: Column(children: [
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 30),
                                                      child: Text(
                                                          "Informe seu e-mail cadastrado para enviarmos as instruções de redefinição da senha.")),
                                                  Form(
                                                    key: resetPasswordKey,
                                                    child: Column(
                                                      children: <Widget>[
                                                        TextFormField(
                                                          controller:
                                                              textEmailReset,
                                                          decoration: const InputDecoration(
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText:
                                                                  'E-mail',
                                                              hintText:
                                                                  'exemplo@gmail.com'),
                                                          validator:
                                                              (String? value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Este campo é obrigatório';
                                                            }
                                                            if (!EmailValidator
                                                                .validate(
                                                                    value)) {
                                                              return 'E-mail inválido';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 24),
                                                          child: ElevatedButton(
                                                              style: ButtonStyle(
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0))),
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          const Color(
                                                                              0xFF0097b2)),
                                                                  padding: MaterialStateProperty.all(
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          40.0,
                                                                          20.0,
                                                                          40.0,
                                                                          20.0))),
                                                              child: const Text(
                                                                'Enviar',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              onPressed: () {
                                                                if (resetPasswordKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  context
                                                                      .read<
                                                                          AppService>()
                                                                      .resetPassword(
                                                                          textEmailReset
                                                                              .text)
                                                                      .then(
                                                                          (value) {
                                                                    resetPassword =
                                                                        value;
                                                                    if (resetPassword ==
                                                                        true) {
                                                                      setState(
                                                                          () {
                                                                        message =
                                                                            "E-mail enviado!";
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        message =
                                                                            "Erro ao enviar e-mail";
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                    }
                                                                  });
                                                                }
                                                              }),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ])),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("Fechar"),
                                                onPressed: () {
                                                  setState(() {
                                                    message = "";
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (message == "Senha ou e-mail inválidos!" ||
                      message == "Erro ao efetuar login!")
                    Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Container(
                          color: const Color(0xFF8cbabd),
                          child: ListTile(
                              title: Text(message,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16.0)),
                              leading: const Icon(Icons.error),
                              trailing: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      message = "";
                                    });
                                  })),
                        )),
                  if (message == "E-mail enviado!" ||
                      message == "Erro ao enviar e-mail")
                    Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Container(
                          color: const Color(0xFF8cbabd),
                          child: ListTile(
                              title: Text(message,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16.0)),
                              leading: const Icon(Icons.error),
                              trailing: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      message = "";
                                    });
                                  })),
                        )),
                ],
              ),
            ),
          ),
        ]));
  }
}
