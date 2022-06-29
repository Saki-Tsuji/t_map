import 'package:flutter/material.dart';

/// 吹き出しの形を形作るPath
Path pathLine({
  required double w,
  required double h,
  required double r,
}) {
  final triangleWidth = w * 0.2;
  final triangleHeight = h * 0.2;

  return Path()
    ..moveTo(r, 0)
    ..lineTo(w - r, 0)
    ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
    ..lineTo(w, h - r)
    ..arcToPoint(Offset(w - r, h), radius: Radius.circular(r))
    ..lineTo((w + triangleWidth) / 2, h)
    ..lineTo(w / 2, h + triangleHeight)
    ..lineTo((w - triangleWidth) / 2, h)
    ..lineTo(r, h)
    ..arcToPoint(Offset(0, h - r), radius: Radius.circular(r))
    ..lineTo(0, h / 2)
    ..lineTo(0, r)
    ..arcToPoint(Offset(r, 0), radius: Radius.circular(r));
}
