import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projeto_final_doctor_interface/appService.dart';
import 'package:projeto_final_doctor_interface/firebaseoptions.dart';
import 'package:projeto_final_doctor_interface/view/homepage.dart';
import 'package:projeto_final_doctor_interface/view/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: const [Locale('pt', 'BR')],
        ));
  }
}

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
