import 'package:flutter/material.dart';
import 'package:map/path_line.dart';

/// 吹き出しの形にくり抜く
class BubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const r = 20.0;
    final w = size.width;
    final h = size.height;

    return pathLine(
      w: w,
      h: h,
      r: r,
    );
  }

  @override
  bool shouldReclip(BubbleClipper oldClipper) => false;
}
