import 'package:flutter/material.dart';
import 'package:map/widget/bubble_border.dart';
import 'package:map/widget/bubble_clipper.dart';

/// マーカーを作るWidget
///
/// CustomClipperを使用して吹き出しの形にContainerをくり抜く。
///
/// CustomClipperだけでは、吹き出しを作れないため、
/// ShapeBorderによりContainerを吹き出しの形に変更したのち、くり抜く。
///
/// ShapeBorderは形を変えたとしてもchildの形を変えてくれない。
class CustomMarker extends StatelessWidget {
  const CustomMarker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BubbleClipper(),
      child: Container(
        width: 100,
        height: 100,
        decoration: const ShapeDecoration(
            color: Colors.white, shape: BubbleBorder(width: 1)),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: AssetImage('assets/images/flutter_dash.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 画像だけのマーカー
///
/// これでもマーカとして表示できない。
class CustomMarker2 extends StatelessWidget {
  const CustomMarker2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/flutter_dash.png',
      width: 100,
      height: 100,
    );
  }
}
