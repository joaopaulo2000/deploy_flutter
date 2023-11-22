// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moca_geriuff_user_interface/appservice.dart';
import 'package:moca_geriuff_user_interface/components/iconbox.dart';
import 'package:moca_geriuff_user_interface/components/newstopwatch.dart';
import 'package:moca_geriuff_user_interface/components/drawingcanvas/drawingcanvas.dart';
import 'package:moca_geriuff_user_interface/components/drawingcanvas/drawingmode.dart';
import 'package:moca_geriuff_user_interface/components/drawingcanvas/sketch.dart';
import 'package:moca_geriuff_user_interface/view/drawingclockpage.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class DrawingCubePage extends HookWidget {
  DrawingCubePage({Key? key}) : super(key: key);

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final selectedColor = useState(Colors.black);
    final strokeSize = useState<double>(5);
    final eraserSize = useState<double>(20);
    final drawingMode = useState(DrawingMode.pencil);
    final filled = useState<bool>(false);
    final polygonSides = useState<int>(0);
    final canvasGlobalKey = GlobalKey();
    bool saveButtonPressed = false;

    ValueNotifier<Sketch?> currentSketch = useState(null);
    ValueNotifier<List<Sketch>> allSketches = useState([]);

    final testIdAux = useState<String?>('');

    Future<String?> getTestId(BuildContext context) async {
      return await context.read<AppService>().getLatestUnfinishedTestId();
    }

    getTestId(context).then((value) {
      testIdAux.value = value;
    });

    getTimes(String time, testID) async {
      DocumentReference patientRef =
          FirebaseFirestore.instance.collection('Tests').doc(testID);
      await patientRef.update({
        'times': FieldValue.arrayUnion([time]),
      });
    }

    String? testId = testIdAux.value;

    NewStopWatch stopWatch = const NewStopWatch();
    NewStopWatchState stopWatchState = NewStopWatchState();
    String elapsedTime = stopWatchState.getElapsedTime();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65,
        title: const Center(child: Text('Visuoespacial/Executiva')),
        actions: [stopWatch],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Copie o cubo",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/cube.png',
                      height: 150, width: 150),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 10, right: 10),
                child: Screenshot(
                  controller: screenshotController,
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: DrawingCanvas(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.6,
                      drawingMode: drawingMode,
                      selectedColor: selectedColor,
                      strokeSize: strokeSize,
                      eraserSize: eraserSize,
                      currentSketch: currentSketch,
                      allSketches: allSketches,
                      canvasGlobalKey: canvasGlobalKey,
                      filled: filled,
                      polygonSides: polygonSides,
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20.0, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    IconBox(
                      iconData: FontAwesomeIcons.pencil,
                      selected: drawingMode.value == DrawingMode.pencil,
                      onTap: () => drawingMode.value = DrawingMode.pencil,
                      tooltip: 'Pencil',
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 40),
                    ),
                    IconBox(
                      iconData: FontAwesomeIcons.eraser,
                      selected: drawingMode.value == DrawingMode.eraser,
                      onTap: () => drawingMode.value = DrawingMode.eraser,
                      tooltip: 'Eraser',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: SizedBox(
                        height: 50,
                        width: 170,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            saveButtonPressed = true;
                            Uint8List? imageBytes =
                                await screenshotController.capture();
                            if (imageBytes != null) {
                              String imageName = 'screenshotCube_$testId.png';
                              final imageReference = FirebaseStorage.instance
                                  .ref()
                                  .child('screenshots')
                                  .child(imageName);
                              await imageReference.putData(imageBytes);
                              final imageUrl =
                                  await imageReference.getDownloadURL();
                              try {
                                final firestore = FirebaseFirestore.instance;
                                await firestore
                                    .collection('Tests')
                                    .doc(testId)
                                    .update({
                                  'imageCube': imageUrl,
                                });
                              } catch (error) {
                                print("Error: $error");
                              }
                            }
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Salvar',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.save,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ]),
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                          height: 50,
                          width: 170,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (saveButtonPressed == true) {
                                getTimes(elapsedTime, testId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DrawingClockPage()),
                                );
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Salve o desenho para prosseguir!"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Próximo',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                ),
                              ],
                            ),
                          ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
