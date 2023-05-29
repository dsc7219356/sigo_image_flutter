import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class SigoTextureImageInfo extends SigoImageInfo {
  static ui.Image? dummy;

  final int? textureId;
  final int? width;
  final int? height;

  SigoTextureImageInfo(
      {this.textureId,
        this.width,
        this.height,
        required ui.Image image,
        double scale = 1.0,
        String? debugLabel})
      : super(image: image, scale: scale, debugLabel: debugLabel);

  ImageInfo clone() {
    return SigoTextureImageInfo(
      image: image.clone(),
      textureId: textureId,
      width: width,
      height: height,
      scale: scale,
      debugLabel: debugLabel,
    );
  }

  static FutureOr<SigoTextureImageInfo> create(
      {int? textureId, int? width, int? height}) async {
    if (dummy != null) {
      return SigoTextureImageInfo(
          textureId: textureId,
          width: width,
          height: height,
          image: dummy!.clone());
    }

    dummy = await _createImage(1, 1);
    return SigoTextureImageInfo(
        textureId: textureId,
        width: width,
        height: height,
        image: dummy!.clone());
  }
}

Future<ui.Image> _createImage(int width, int height) async {
  final Completer<ui.Image> completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    Uint8List.fromList(
        List<int>.filled(width * height * 4, 0, growable: false)),
    width,
    height,
    ui.PixelFormat.rgba8888,
        (ui.Image image) {
      completer.complete(image);
    },
  );
  return completer.future;
}

class SigoImageInfo extends ImageInfo {
  int? get width => image.width;
  int? get height => image.height;
  SigoImageInfo({required ui.Image image, double scale = 1.0, String? debugLabel})
      : super(image: image, scale: scale, debugLabel: debugLabel);

  ImageInfo clone() {
    return SigoImageInfo(
      image: image.clone(),
      scale: scale,
      debugLabel: debugLabel,
    );
  }
}
