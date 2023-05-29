import 'dart:async';

import 'package:flutter/painting.dart';
import 'package:sigo_image_flutter/src/common/sigo_image_loader.dart';
import 'package:sigo_image_flutter/src/common/sigo_image_provider.dart';
import 'package:sigo_image_flutter/src/image_ext/image_info_ext.dart';
import 'package:sigo_image_flutter/src/options/sigo_image_request_options.dart';


class SigoTextureImageProvider extends SigoImageProvider {
  SigoTextureImageProvider(SigoImageRequestOptions options) : super(options);

  @override
  FutureOr<ImageInfo> createImageInfo(Map map) {
    int? textureId = map['textureId'];
    int? width = map['width'];
    int? height = map['height'];
    return SigoTextureImageInfo.create(
        textureId: textureId, width: width, height: height);
  }

  @override
  void dispose() {
    SigoImageLoader.instance.releaseImageRequest(options);
    super.dispose();
  }
}
