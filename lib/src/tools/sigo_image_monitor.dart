import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:sigo_image_flutter/src/common/sigo_image_provider.dart';


typedef SigoImageErrorCallback = void Function(
    SigoImageLoadException exception);

/// setup with PowerImageSetupOptions;
class SigoImageMonitor {
  SigoImageMonitor._internal() {
    _init();
  }

  static final SigoImageMonitor _singleton = SigoImageMonitor._internal();

  void _init() {}

  static SigoImageMonitor instance() {
    return _singleton;
  }

  SigoImageErrorCallback? errorCallback;
  bool _needCallError = false;
  set errorCallbackSamplingRate(double? r) {
    r = (r ?? 1.00).clamp(0.000, 1.000);
    if (0.0 == r) {
      _needCallError = false;
      return;
    } else if (1.0 == r) {
      _needCallError = true;
      return;
    }
    final int num = (r * 1000).toInt().clamp(0, 1000);
    final int randomNum = Random().nextInt(1000) + 1;
    _needCallError = randomNum <= num;
  }

  void anErrorOccurred(SigoImageLoadException exception) {
    if (_needCallError) {
      errorCallback?.call(exception);
    }
  }

  @visibleForTesting
  bool get needCallError => _needCallError;
}
