import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/logger.dart';
import 'package:map/widget/custom_marker.dart';
import 'package:path_provider/path_provider.dart';

/// google mapのマーカーはWidgetではなく、画像である必要があるため、
/// uint8Listに変換する。
///
///
/// このとき、Widgetを画像に変換する必要があるが、
/// 画像と吹き出し部分（customClipperを使用）は表示できない。
///
///
/// 画像が表示できないことに関してはissueが挙がっている。
///
/// https://github.com/flutter/flutter/issues/75316
final toUint8ListFromWidgetProvider =
    FutureProvider.autoDispose<Uint8List>((ref) async {
  logger.info('loading...');
  final widget = await getWidget();
  final image = await widget.toImage();
  logger.info('toImage...');
  final byteData =
      await image.toByteData(format: ui.ImageByteFormat.png) ?? ByteData(0);

  return byteData.buffer.asUint8List();
});

/// googleマップの影響かどうか調査するために、Widgetを画像にする。
///
/// その後、Fileに変換、Imgage.fileによりWidget化して表示（画面下部）
///
/// こちらも表示されないため、[GoogleMap()]の影響ではなく、
///
///
/// final widget = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
///
///
/// の問題と思われる。
final toImageFromWidgetProvider =
    FutureProvider.autoDispose<File?>((ref) async {
  logger.info('loading...');
  final widget = await getWidget();
  final image = await widget.toImage();
  logger.info('toImage...');
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final uint8List = byteData?.buffer.asUint8List();
  if (uint8List == null) return null;

  final directory = await getTemporaryDirectory();
  final imagePath =
      await File('${directory.path}/container_image.png').create();
  return await imagePath.writeAsBytes(uint8List);
});

Future<RenderRepaintBoundary> getWidget() async {
  final widget =
      globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (widget != null) {
    return widget;
  }
  await Future.delayed(const Duration(milliseconds: 30));
  return getWidget();
}

class MapPage extends ConsumerStatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

final globalKey = GlobalKey();

class _MapPageState extends ConsumerState<MapPage> {
  final _controller = Completer();

  static const _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 76, 167, 175),
      appBar: AppBar(title: const Text('Google MAP')),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // このWidgetを画像化する
              RepaintBoundary(
                key: globalKey,
                child: const CustomMarker(),
              ),
              const SizedBox(height: 50),

              // Google Mapの表示
              SizedBox(
                height: 300,
                child: ref.watch(toUint8ListFromWidgetProvider).when(
                      data: ((uint8List) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GoogleMap(
                              markers: {
                                Marker(
                                  markerId: const MarkerId('google_plex'),
                                  position: _kGooglePlex.target,
                                  icon: BitmapDescriptor.fromBytes(uint8List),
                                ),
                              },
                              mapType: MapType.normal,
                              initialCameraPosition: _kGooglePlex,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            ),
                          )),
                      error: (e, st) => Text(e.toString()),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                    ),
              ),
              const SizedBox(height: 50),

              // 画像にしたものをFile化してWidget表示
              ref.watch(toImageFromWidgetProvider).when(
                    data: (file) {
                      if (file == null) return const Text('image null');
                      return Image.file(file);
                    },
                    error: (e, st) => throw e,
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
            ],
          )),
    );
  }
}
