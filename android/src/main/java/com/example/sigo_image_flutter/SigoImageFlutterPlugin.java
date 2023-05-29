package com.example.sigo_image_flutter;

import androidx.annotation.NonNull;
import android.content.Context;

import java.util.List;
import java.util.Map;

import com.example.sigo_image_flutter.dispatcher.SigoImageDispatcher;
import com.example.sigo_image_flutter.request.SigoImageRequestManager;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** SigoImageFlutterPlugin */
public class SigoImageFlutterPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel methodChannel;
  private EventChannel eventChannel;
  private static Context sContext;

  public static Context getContext(){
    return sContext;
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    if(sContext == null){
      sContext = flutterPluginBinding.getApplicationContext();
    }
    methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "sigo_image_flutter/method");
    methodChannel.setMethodCallHandler(this);
    eventChannel = new EventChannel(
            flutterPluginBinding.getBinaryMessenger(), "sigo_image_flutter/event");
    eventChannel.setStreamHandler(SigoImageEventSink.getInstance());
    SigoImageRequestManager.getInstance()
            .configWithTextureRegistry(flutterPluginBinding.getTextureRegistry());
    SigoImageDispatcher.getInstance().prepare();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if ("startImageRequests".equals(call.method)) {
      if (call.arguments instanceof List) {
        List arguments = (List) call.arguments;
        List results = SigoImageRequestManager.getInstance()
                .configRequestsWithArguments(arguments);
        result.success(results);
        SigoImageRequestManager.getInstance().startLoadingWithArguments(arguments);
      } else {
        throw new IllegalArgumentException("startImageRequests require List arguments");
      }
    } else if ("releaseImageRequests".equals(call.method)) {
      if (call.arguments instanceof List) {
        List arguments = (List) call.arguments;
        List results = SigoImageRequestManager.getInstance().releaseRequestsWithArguments(arguments);
        result.success(results);
      } else {
        throw new IllegalArgumentException("stopImageRequests require List arguments");
      }
    } else {
      result.notImplemented();
    }
  }

  public static class SigoImageEventSink implements EventChannel.StreamHandler {

    private EventChannel.EventSink eventSink;

    private SigoImageEventSink() {
    }

    private static class Holder {
      private final static SigoImageEventSink instance = new SigoImageEventSink();
    }

    public static SigoImageEventSink getInstance() {
      return SigoImageEventSink.Holder.instance;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
      eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
      eventSink = null;
    }

    public void sendImageStateEvent(Map<String, Object> event, boolean success) {
      if (eventSink == null || event == null) {
        return;
      }

      event.put("eventName", "onReceiveImageEvent");
      event.put("success", success);
      eventSink.success(event);
    }

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    methodChannel.setMethodCallHandler(null);
    eventChannel.setStreamHandler(null);
  }
}
