import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_final/appService.dart';
import 'package:projeto_final/view/drawing_canvas/models/drawing_mode.dart';
import 'package:projeto_final/view/drawing_canvas/models/sketch.dart';
import 'package:projeto_final/view/drawing_clock_page.dart';
import 'package:projeto_final/components/icons_box.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class DrawingCubePage extends StatefulWidget {
  const DrawingCubePage({super.key});

  @override
  _DrawingCubePageState createState() => _DrawingCubePageState();
}

class _DrawingCubePageState extends State<DrawingCubePage> {

  GlobalKey _containerKey = GlobalKey();

  Reference storageReference = FirebaseStorage.instance.ref();
  bool loading = false;

  void convertWidgetToImage() async {
    RenderObject? renderRepaintBoundary = _containerKey.currentContext!.findRenderObject();
    ui.Image boxImage = await renderRepaintBoundary!.toImage(pixelRatio: 1);
    ByteData? byteData = await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uInt8List = byteData!.buffer.asUint8List();
    this.setState(() {
      loading = true;
    });

    StorageUploadTask storageUploadTask = storageReference
        .child("IMG_${DateTime.now().millisecondsSinceEpoch}.png")
        .putData(uInt8List);

    await storageUploadTask.onComplete;
    this.setState(() {
      loading = false;
    });
  }

  Color selectedColor = Colors.black;
  double strokeSize = 5;
  double eraserSize = 20;
  DrawingMode drawingMode = DrawingMode.pencil;
  bool filled = false;
  int polygonSides = 0;
  GlobalKey canvasGlobalKey = GlobalKey();

  ValueNotifier<Sketch?> currentSketch = ValueNotifier(null);
  ValueNotifier<List<Sketch>> allSketches = ValueNotifier([]);

  ValueNotifier<String?> testIdAux = ValueNotifier<String?>('');

  Future<String?> getTestId(BuildContext context) async {
    return await context.read<AppService>().getLatestUnfinishedTestId();
  }

  @override
  void initState() {
    super.initState();
    getTestId(context).then((value) {
      setState(() {
        testIdAux.value = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

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
                      child: Image.asset('assets/images/cube.png',
                          height: 150, width: 150),
                    ))),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 20.0, bottom: 20),
              child: Row(
                children: [
                  IconsBox(
                    iconData: FontAwesomeIcons.pencil,
                    selected: drawingMode == DrawingMode.pencil,
                    onTap: () => drawingMode = DrawingMode.pencil,
                    tooltip: 'Pencil',
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 40),
                  ),
                  IconsBox(
                    iconData: FontAwesomeIcons.eraser,
                    selected: drawingMode == DrawingMode.eraser,
                    onTap: () => drawingMode = DrawingMode.eraser,
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
                          navigateToNextPage(context);
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

 void navigateToNextPage(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const DrawingClockPage()),
  );
}


}
