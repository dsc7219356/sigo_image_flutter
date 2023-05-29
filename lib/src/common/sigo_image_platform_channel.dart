import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sigo_image_flutter/src/common/sigo_image_channel.dart';
import 'package:sigo_image_flutter/src/common/sigo_image_loader.dart';
import 'package:sigo_image_flutter/src/common/sigo_image_request.dart';


typedef EventHandler = void Function(Map<dynamic, dynamic> event);

class SigoImagePlatformChannel extends SigoImageChannelImpl {

  StreamSubscription? _subscription;

  SigoImagePlatformChannel() {
    eventHandlers['onReceiveImageEvent'] = (Map<dynamic, dynamic> event) {
      SigoImageLoader.instance.onImageComplete(event);
    };
  }

  @override
  void setup() {
    startListening();
  }

  StreamSubscription? startListening() {
    _subscription ??= eventChannel.receiveBroadcastStream().listen(onEvent);
    return _subscription;
  }

  Map<String, EventHandler?> eventHandlers = <String, EventHandler?>{};

  void onEvent(dynamic val) {
    assert(val is Map<dynamic, dynamic>);
    final Map<dynamic, dynamic> event = val;
    String? eventName = event['eventName'];
    EventHandler? eventHandler = eventHandlers[eventName!];
    if (eventHandler != null) {
      eventHandler(event);
    } else {
      //TODO 发来了不认识的事件,需要处理一下
    }
  }

  void registerEventHandler(String eventName, EventHandler eventHandler) {
    assert(eventName.isNotEmpty);
    eventHandlers[eventName] = eventHandler;
  }

  void unregisterEventHandler(String eventName) {
    eventHandlers[eventName] = null;
  }

  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('sigo_image_flutter/method');

  @visibleForTesting
  EventChannel eventChannel = const EventChannel('sigo_image_flutter/event');

  @override
  void startImageRequests(List<SigoImageRequest> requests) async {
    await methodChannel.invokeListMethod(
        'startImageRequests', encodeRequests(requests));
  }

  @override
  void releaseImageRequests(List<SigoImageRequest> requests) async {
    await methodChannel.invokeListMethod(
        'releaseImageRequests', encodeRequests(requests));
  }
}
