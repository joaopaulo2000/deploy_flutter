import 'package:flutter/material.dart';
import 'package:projeto_final/appService.dart';
import 'package:projeto_final/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projeto_final/view/drawing_clock_page.dart';
import 'package:projeto_final/view/home_page.dart';
import 'package:projeto_final/view/initialPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
          routes: {
            '/drawing_clock_page': (context) => const DrawingClockPage(),
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

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: context.read<AppService>().getLatestUnfinishedTestId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final lastTest = snapshot.data;
          //print(lastTest);
          if (lastTest != null) {
            return const HomePage();
          }
          return const InitialPage();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}


