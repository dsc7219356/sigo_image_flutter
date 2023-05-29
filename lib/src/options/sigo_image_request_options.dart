import 'package:flutter/cupertino.dart';
import 'package:sigo_image_flutter/src/options/sigo_image_request_options_src.dart';


const String renderingTypeExternal = "external";
const String renderingTypeTexture = "texture";
const String defaultGlobalRenderType = renderingTypeTexture;

const String imageTypeNetwork = "network";
const String imageTypeNativeAssert = "nativeAsset";
const String imageTypeAssert = "asset";
const String imageTypeFile = "file";

class SigoImageRequestOptions {
  SigoImageRequestOptions(
      {required this.src,
      required this.imageType,
      required this.renderingType,
      this.imageWidth,
      this.imageHeight});

  SigoImageRequestOptions.network(String src,
      {required this.renderingType, this.imageWidth, this.imageHeight})
      : src = SigoImageRequestOptionsSrcNormal(src: src),
        imageType = imageTypeNetwork;

  SigoImageRequestOptions.nativeAsset(String src,
      {required this.renderingType, this.imageWidth, this.imageHeight})
      : src = SigoImageRequestOptionsSrcNormal(src: src),
        imageType = imageTypeNativeAssert;

  SigoImageRequestOptions.asset(String src,
      {String? package,
      required this.renderingType,
      this.imageWidth,
      this.imageHeight})
      : src = SigoImageRequestOptionsSrcAsset(src: src, package: package),
        imageType = imageTypeAssert;

  SigoImageRequestOptions.file(String src,
      {required this.renderingType, this.imageWidth, this.imageHeight})
      : src = SigoImageRequestOptionsSrcNormal(src: src),
        imageType = imageTypeFile;

  final SigoImageRequestOptionsSrc src;
  final String imageType;
  final String? renderingType;
  final double? imageWidth;
  final double? imageHeight;

  @override
  String toString() {
    return 'src: $src, imageType: $imageType, renderingType: $renderingType';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SigoImageRequestOptions &&
        other.src == src &&
        other.imageType == imageType &&
        other.imageWidth == imageWidth &&
        other.imageHeight == imageHeight;
  }

  @override
  //todo hashValues(src, imageType) will make different hashCode
  int get hashCode => hashValues(src, imageType, imageWidth, imageHeight);
}
