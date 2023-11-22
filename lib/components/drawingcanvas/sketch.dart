import 'package:flutter/material.dart';
import 'package:moca_geriuff_user_interface/components/drawingcanvas/drawingmode.dart';

class Sketch {
  final List<Offset> points;
  final Color color;
  final double size;
  final SketchType type;
  final bool filled;
  final int sides;

  Sketch({
    required this.points,
    this.color = Colors.black,
    this.type = SketchType.scribble,
    this.filled = true,
    this.sides = 3,
    required this.size,
  });

  factory Sketch.fromDrawingMode(
      Sketch sketch, DrawingMode drawingMode, bool filled) {
    return Sketch(
      points: sketch.points,
      color: sketch.color,
      size: sketch.size,
      filled:
          drawingMode == DrawingMode.pencil || drawingMode == DrawingMode.eraser
              ? false
              : filled,
      sides: sketch.sides,
      type: () {
        switch (drawingMode) {
          case DrawingMode.eraser:
          case DrawingMode.pencil:
            return SketchType.scribble;
          default:
            return SketchType.scribble;
        }
      }(),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map> pointsMap = points.map((e) => {'dx': e.dx, 'dy': e.dy}).toList();
    return {
      'points': pointsMap,
      'color': color,
      'size': size,
      'filled': filled,
      'type': type.toRegularString(),
      'sides': sides,
    };
  }

  factory Sketch.fromJson(Map<String, dynamic> json) {
    List<Offset> points =
        (json['points'] as List).map((e) => Offset(e['dx'], e['dy'])).toList();
    return Sketch(
      points: points,
      color: (json['color']),
      size: json['size'],
      filled: json['filled'],
      type: (json['type'] as String).toSketchTypeEnum(),
      sides: json['sides'],
    );
  }
}

enum SketchType { scribble }

extension SketchTypeX on SketchType {
  toRegularString() => toString().split('.')[1];
}

extension SketchTypeExtension on String {
  toSketchTypeEnum() =>
      SketchType.values.firstWhere((e) => e.toString() == 'SketchType.$this');
}
