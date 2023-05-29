import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:sigo_image_flutter/src/common/sigo_image_channel.dart';
import 'package:sigo_image_flutter/src/common/sigo_image_platform_channel.dart';
import 'package:sigo_image_flutter/src/common/sigo_image_provider.dart';
import 'package:sigo_image_flutter/src/common/sigo_image_request.dart';
import 'package:sigo_image_flutter/src/common/sigo_image_setup_options.dart';
import 'package:sigo_image_flutter/src/image_ext/image_info_ext.dart';
import 'package:sigo_image_flutter/src/options/sigo_image_request_options.dart';
import 'package:sigo_image_flutter/src/options/sigo_image_request_options_src.dart';
import 'package:sigo_image_flutter/src/tools/sigo_image_monitor.dart';


class SigoImageCompleter {
  SigoImageRequest? request;
  Completer? completer;
}

class SigoImageLoader {
  static Map<String?, SigoImageCompleter> completers =
      <String?, SigoImageCompleter>{};

  static SigoImageLoader instance = SigoImageLoader._();

  SigoImageChannel channel = SigoImageChannel();

  String get globalRenderType => _globalRenderType;
  String _globalRenderType = defaultGlobalRenderType;

  SigoImageLoader._() {
    channel.impl = SigoImagePlatformChannel();
  }

  void setup(SigoImageSetupOptions? options) {
    _globalRenderType = options?.globalRenderType ?? defaultGlobalRenderType;
    SigoImageMonitor.instance().errorCallback = options?.errorCallback;
    SigoImageMonitor.instance().errorCallbackSamplingRate = options?.errorCallbackSamplingRate;
    channel.setup();
  }

  SigoImageCompleter loadImage(
      SigoImageRequestOptions options,
  ) {
    SigoImageRequest request = SigoImageRequest.create(options);
    channel.startImageRequests(<SigoImageRequest>[request]);
    SigoImageCompleter completer = SigoImageCompleter();
    completer.request = request;
    completer.completer = Completer<Map>();
    completers[request.uniqueKey()] = completer;
    return completer;
  }

  void onImageComplete(Map<dynamic, dynamic> map) async {
    String? uniqueKey = map['uniqueKey'];
    SigoImageCompleter? completer = completers.remove(uniqueKey);
    //todo null case
    completer?.completer?.complete(map);
  }

  void releaseImageRequest(SigoImageRequestOptions options) async {
    SigoImageRequest request = SigoImageRequest.create(options);
    channel.releaseImageRequests(<SigoImageRequest>[request]);
  }

  /// prefetch imageTypeNetwork image
  /// base of
  /// Future<ImageInfo> prefetch(
  ///       PowerImageRequestOptions options, BuildContext context)
  Future<SigoImageInfo?> prefetchNetworkImage(String url, BuildContext context,
      {String? renderingType,
      double? imageWidth,
      double? imageHeight,
      ImageErrorListener? onError}) {
    return prefetch(
        SigoImageRequestOptions(
            src: SigoImageRequestOptionsSrcNormal(src: url),
            renderingType: renderingType,
            imageType: imageTypeNetwork,
            imageWidth: imageWidth,
            imageHeight: imageHeight),
        context,
        onError: onError);
  }

  /// prefetch imageTypeNativeAssert image
  /// base of
  /// Future<ImageInfo> prefetch(
  ///       PowerImageRequestOptions options, BuildContext context)
  Future<SigoImageInfo?> prefetchNativeAssetImage(String src, BuildContext context,
      {String? renderingType,
      double? imageWidth,
      double? imageHeight,
      ImageErrorListener? onError}) {
    return prefetch(
        SigoImageRequestOptions(
            src: SigoImageRequestOptionsSrcNormal(src: src),
            renderingType: renderingType,
            imageType: imageTypeNativeAssert,
            imageWidth: imageWidth,
            imageHeight: imageHeight),
        context,
        onError: onError);
  }

  /// prefetch imageTypeAssert image
  /// base of
  /// Future<ImageInfo> prefetch(
  ///       PowerImageRequestOptions options, BuildContext context)
  Future<SigoImageInfo?> prefetchAssetImage(String src, BuildContext context,
      {String? renderingType,
      double? imageWidth,
      double? imageHeight,
      String? package,
      ImageErrorListener? onError}) {
    return prefetch(
        SigoImageRequestOptions(
            src: SigoImageRequestOptionsSrcAsset(src: src, package: package),
            renderingType: renderingType,
            imageType: imageTypeAssert,
            imageWidth: imageWidth,
            imageHeight: imageHeight),
        context,
        onError: onError);
  }

  /// prefetch imageTypeFile image
  /// base of
  /// Future<ImageInfo> prefetch(
  ///       PowerImageRequestOptions options, BuildContext context)
  Future<SigoImageInfo?> prefetchFileImage(String src, BuildContext context,
      {String? renderingType,
      double? imageWidth,
      double? imageHeight,
      ImageErrorListener? onError}) {
    return prefetch(
        SigoImageRequestOptions(
            src: SigoImageRequestOptionsSrcNormal(src: src),
            renderingType: renderingType,
            imageType: imageTypeFile,
            imageWidth: imageWidth,
            imageHeight: imageHeight),
        context,
        onError: onError);
  }

  /// prefetch image with type
  /// go [PowerImage.type] for more detail
  ///
  Future<SigoImageInfo?> prefetchTypeImage(
      String imageType, SigoImageRequestOptionsSrc src, BuildContext context,
      {String? renderingType,
      double? imageWidth,
      double? imageHeight,
      ImageErrorListener? onError}) {
    return prefetch(
        SigoImageRequestOptions(
            src: src,
            renderingType: renderingType,
            imageType: imageType,
            imageWidth: imageWidth,
            imageHeight: imageHeight),
        context,
        onError: onError);
  }

  /// prefetch image with options
  /// this will add image to ImageCache
  /// so the next time ,when you use equal options (==\hashCode),
  /// will directly use the cached image
  Future<SigoImageInfo?> prefetch(
      SigoImageRequestOptions options, BuildContext context,
      {ImageErrorListener? onError}) {
    ImageProvider provider = SigoImageProvider.options(options) as ImageProvider<Object>;
    return _precacheImage(provider, context, onError: onError);
  }

  Future<SigoImageInfo?> _precacheImage(
    ImageProvider provider,
    BuildContext context, {
    Size? size,
    ImageErrorListener? onError,
  }) {
    final ImageConfiguration config =
        createLocalImageConfiguration(context, size: size);
    final Completer<SigoImageInfo?> completer = Completer<SigoImageInfo?>();
    final ImageStream stream = provider.resolve(config);
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo image, bool sync) {
        if (!completer.isCompleted) {
          completer.complete(image as SigoImageInfo);
        }
        // Give callers until at least the end of the frame to subscribe to the
        // image stream.
        // See ImageCache._liveImages
        SchedulerBinding.instance!.addPostFrameCallback((Duration timeStamp) {
          stream.removeListener(listener);
        });
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
        stream.removeListener(listener);
        if (onError != null) {
          onError(exception, stackTrace);
        } else {
          FlutterError.reportError(FlutterErrorDetails(
            context: ErrorDescription('image failed to precache'),
            library: 'image resource service',
            exception: exception,
            stack: stackTrace,
            silent: true,
          ));
        }
      },
    );
    stream.addListener(listener);
    return completer.future;
  }
}
