// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';

class NewStopWatch extends StatefulWidget {
  const NewStopWatch({Key? key}) : super(key: key);

  @override
  NewStopWatchState createState() => NewStopWatchState();
}

class NewStopWatchState extends State<NewStopWatch> {
  Stopwatch watch = Stopwatch();
  late Timer timer;
  bool startStop = true;
  static String elapsedTime = '';
  late String duration;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => startWatch());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          const Icon(Icons.timer),
          const SizedBox(width: 10),
          Text(elapsedTime, style: const TextStyle(fontSize: 20.0)),
        ],
      ),
    );
  }

  void updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  void startWatch() {
    setState(() {
      startStop = false;
      watch.start();
      timer = Timer.periodic(const Duration(milliseconds: 100), updateTime);
    });
  }

  String transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();
    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "$hoursStr:$minutesStr:$secondsStr";
  }

  String getElapsedTime() {
    return elapsedTime;
  }
}
