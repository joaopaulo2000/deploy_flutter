import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projeto_final_doctor_interface/appService.dart';
import 'package:projeto_final_doctor_interface/firebase_options.dart';
import 'package:projeto_final_doctor_interface/view/doctorRegistration_page.dart';
import 'package:projeto_final_doctor_interface/view/home_page.dart';
import 'package:projeto_final_doctor_interface/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projeto_final_doctor_interface/view/patientRegistration_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AppService>(
            create: (_) => AppService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<AppService>().authStateChanges,
            initialData: null,
          )
        ],
        child: MaterialApp(
          title: 'MOCA GeriUFF',
          theme: ThemeData(primarySwatch: Colors.blue),
          debugShowCheckedModeBanner: false,
          home: const AuthenticationWrapper(),
          initialRoute: '/',
          routes: {
            '/doctorRegistration': (context) => const DoctorRegistrationPage(),
            '/patientRegistration': (context) => const PatientRegistration(),
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: const [Locale('pt', 'BR')],
        )
    );
  }
}

// Decide baseado na existência ou não de um usuário logado, se retorna a HomePage ou a tela de Login
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      context.read<AppService>().fetchDoctorData();
      
      return const HomePage();
    }
    return const LoginPage();
  }
}


