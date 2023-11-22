import 'package:flutter/material.dart';
import 'package:moca_geriuff_user_interface/appservice.dart';
import 'package:moca_geriuff_user_interface/firebaseoptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moca_geriuff_user_interface/view/homepage.dart';
import 'package:moca_geriuff_user_interface/view/initialpage.dart';
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
    return FutureBuilder<String?>(
      future: context.read<AppService>().getLatestUnfinishedTestId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final lastTest = snapshot.data;
          if (lastTest != null) {
            return const HomePage();
          }
          return const InitialPage();
        } else {
          return const SizedBox(
            height: 50.0,
            width: 50.0,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
