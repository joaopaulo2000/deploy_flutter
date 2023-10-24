import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_final/appService.dart';
import 'package:projeto_final/view/drawing_canvas/drawing_canvas.dart';
import 'package:projeto_final/view/drawing_canvas/models/drawing_mode.dart';
import 'package:projeto_final/view/drawing_canvas/models/sketch.dart';
import 'package:projeto_final/view/drawing_clock_page.dart';
import 'package:projeto_final/view/drawing_points_page.dart';
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

    ValueNotifier<Sketch?> currentSketch = useState(null);
    ValueNotifier<List<Sketch>> allSketches = useState([]);

    final testIdAux = useState<String?>('');

    Future<String?> getTestId(BuildContext context) async {
      return await context.read<AppService>().getLatestUnfinishedTestId();
    }

    getTestId(context).then((value) {
      testIdAux.value = value;
    });

    String? testId = testIdAux.value;
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visuoespacial/Executiva'),
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
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/cube.png',
                      height: 150, width: 150),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 10, right: 10),
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
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 20.0, bottom: 20),
              child: Row(
                children: [
                  _IconBox(
                    iconData: FontAwesomeIcons.pencil,
                    selected: drawingMode.value == DrawingMode.pencil,
                    onTap: () => drawingMode.value = DrawingMode.pencil,
                    tooltip: 'Pencil',
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 40),
                  ),
                  _IconBox(
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          // Capture the screenshot
                          Uint8List? imageBytes =
                              await screenshotController.capture();
                          if (imageBytes != null) {
                            // Upload the screenshot to Firebase Storage
                            String imageName = 'screenshotCube_$testId.png';
                            final imageReference = FirebaseStorage.instance
                                .ref()
                                .child('screenshots')
                                .child(imageName);
                            await imageReference.putData(imageBytes);
                            final imageUrl =
                                await imageReference.getDownloadURL();

                            // Store the image URL in Firestore
                            final firestore = FirebaseFirestore.instance;
                            await firestore
                                .collection('Test')
                                .doc(testId)
                                .update({
                              'imageCube': imageUrl,
                            });
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DrawingClockPage()),
                          );
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData? iconData;
  final Widget? child;
  final bool selected;
  final VoidCallback onTap;
  final String? tooltip;

  const _IconBox({
    Key? key,
    this.iconData,
    this.child,
    this.tooltip,
    required this.selected,
    required this.onTap,
  })  : assert(child != null || iconData != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? Colors.grey[900]! : Colors.grey,
              width: 1.5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Tooltip(
            message: tooltip,
            preferBelow: false,
            child: child ??
                Icon(
                  iconData,
                  color: selected ? Colors.grey[900] : Colors.grey,
                  size: 20,
                ),
          ),
        ),
      ),
    );
  }
}
