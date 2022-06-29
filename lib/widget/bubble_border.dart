import 'package:flutter/material.dart';
import 'package:map/path_line.dart';

/// 吹き出しのボーダーを作る
class BubbleBorder extends ShapeBorder {
  const BubbleBorder({required this.width});

  final double width;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(
        rect.deflate(width / 2.0),
        textDirection: textDirection,
      );

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const r = 20.0;
    final w = rect.size.width;
    final h = rect.size.height;
    return pathLine(
      w: w,
      h: h,
      r: r,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white;
    canvas.drawPath(
      getOuterPath(
        rect.deflate(width / 2.0),
        textDirection: textDirection,
      ),
      paint,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}
