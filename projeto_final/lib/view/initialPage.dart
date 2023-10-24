// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(child: Padding(padding: const EdgeInsets.only(top:150.0),
            child: Image.asset('assets/images/home_img.png', height: 400, width: 400))
          ),
        ]
      )
    );
  }
}

