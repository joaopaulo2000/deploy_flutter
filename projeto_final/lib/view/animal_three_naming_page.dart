// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AnimalThreeNamingPage extends StatefulWidget {
  const AnimalThreeNamingPage({super.key});
  

  @override
  _AnimalThreeNamingPageState createState() => _AnimalThreeNamingPageState();
}

class _AnimalThreeNamingPageState extends State<AnimalThreeNamingPage> {
  FlutterSound flutterSound = FlutterSound();
  bool _playAudio = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Nomeação'),  
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top:50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Nomeie o animal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)
              ],
              )
          ),
          Center(child: Padding(padding: const EdgeInsets.only(top:50.0),
            child: Image.asset('assets/images/animal_three.png', height: 250, width: 350))
          ),
          Padding(
            padding: const EdgeInsets.only(top:50.0),
            child:  SizedBox(
            height: 80,
            width: 80,
            child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                )
              )
            ),
            onPressed: () {
              setState(() {
                  _playAudio = !_playAudio;
                });
                if (_playAudio) playFunc();
                if (!_playAudio) stopPlayFunc();
              },
              child: _playAudio  ? const Icon(
                      Icons.stop,
                      size: 50.0
                    )
                  : const Icon(
                    Icons.mic,
                    size: 50.0
                  ),

          ))
          ),
          Padding(
            padding: const EdgeInsets.only(top:200.0, left: 230),
            child:  SizedBox(
            height: 50,
            width: 170,
            child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )
              )
            ),
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnimalThreeNamingPage()),
             );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Próximo', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22, color: Colors.white)), 
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20.0,
                ),
              ],
            ),
          ))
          ),
        ]
      ),
      
    );
  }
  
  void playFunc() {
    print("play");
  }
  
  void stopPlayFunc() {
     print("stop");
  }
}

