

import 'package:flutter/widgets.dart';
import 'package:sigo_image_flutter/src/image_ext/image_cache_ext.dart';




class SigoImageBinding extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    // TODO: implement createImageCache
    return ImageCacheExt();
  }
}