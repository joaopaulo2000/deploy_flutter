import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projeto_final/appService.dart';
import 'package:projeto_final/view/animal_one_naming_page.dart';
import 'package:projeto_final/view/drawing_canvas/drawing_canvas.dart';
import 'package:projeto_final/view/drawing_canvas/models/drawing_mode.dart';
import 'package:projeto_final/view/drawing_canvas/models/sketch.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class DrawingPointsPage extends HookWidget {
  const DrawingPointsPage({Key? key}) : super(key: key);

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

    ScreenshotController screenshotController = ScreenshotController();

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
              padding: EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Ligue os pontos",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )
                ],
              )),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 10, right: 10),
                child: Screenshot(
                    controller: screenshotController,
                    child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.9,
                  ),
                  child: DrawingCanvas(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.9,
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
              Center(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 350),
                      child: CustomPaint(
                        painter: OpenPainter(),
                      ))),
            ],
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
                            String imageName = 'screenshotPoints_$testId.png';
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
                              'imagePoints': imageUrl,
                            });
                          }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AnimalOneNamingPage()),
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
      )),
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
class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xff000000)
      ..strokeCap = StrokeCap.round //rounded points
      ..strokeWidth = 5;

    var paint1 = Paint()
      ..color = const Color(0xff0a2283)
      ..strokeCap = StrokeCap.round //rounded points
      ..strokeWidth = 30;

    // Define os pontos e rótulos
    var points = [
      const Offset(200, 150),
      const Offset(200, 300),
      const Offset(130, 620),
      const Offset(50, 500),
      const Offset(80, 170),
      const Offset(110, 400),
      const Offset(320, 250),
      const Offset(350, 500),
      const Offset(200, 500),
      const Offset(50, 300),
    ];

    canvas.drawLine(
      const Offset(110, 400),
      const Offset(200, 150),
      paint,
    );

    canvas.drawLine(
      const Offset(200, 150),
      const Offset(320, 250),
      paint,
    );

    var labels = [
      "A",
      "B",
      "C",
      "D",
      "E",
      "1",
      "2",
      "3",
      "4",
      "5",
    ];

    var additionalLabels = [
      "Inicio", // Rótulo adicional para o ponto "A"
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "Fim", // Rótulo adicional para o ponto "5"
    ];

    // Desenha os pontos na tela e rótulos adicionais
    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 8, paint1);
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: 100,
      );
      textPainter.paint(
        canvas,
        Offset(points[i].dx + 17, points[i].dy - 17),
      );

      if (additionalLabels[i].isNotEmpty) {
        final additionalTextPainter = TextPainter(
          text: TextSpan(
            text: additionalLabels[i],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15, // Tamanho menor para rótulos adicionais
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        additionalTextPainter.layout(
          minWidth: 0,
          maxWidth: 100,
        );
        additionalTextPainter.paint(
          canvas,
          Offset(points[i].dx + 25, points[i].dy + 5),
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
