package com.example.sigo_image_flutter.request;

import com.example.sigo_image_flutter.SigoImageFlutterPlugin;
import com.example.sigo_image_flutter.dispatcher.SigoImageDispatcher;
import com.example.sigo_image_flutter.loader.FlutterMultiFrameImage;
import com.example.sigo_image_flutter.loader.SigoImageLoader;
import com.example.sigo_image_flutter.loader.SigoImageLoaderProtocol;
import com.example.sigo_image_flutter.loader.SigoImageResult;

import java.util.HashMap;
import java.util.Map;

public abstract class SigoImageBaseRequest {
    protected static final String REQUEST_STATE_INITIALIZE_SUCCEED = "initializeSucceed";
    protected static final String REQUEST_STATE_INITIALIZE_FAILED = "initializeFailed";
    protected static final String REQUEST_STATE_LOAD_SUCCEED = "loadSucceed";
    protected static final String REQUEST_STATE_LOAD_FAILED = "loadFailed";
    protected static final String REQUEST_STATE_RELEASE_SUCCEED = "releaseSucceed";
    protected static final String REQUEST_STATE_RELEASE_FAILED = "releaseFailed";

    public static final String RENDER_TYPE_EXTERNAL = "external";
    public static final String RENDER_TYPE_TEXTURE = "texture";

    private SigoImageRequestConfig imageRequestConfig;
    String requestId;
    protected String imageTaskState;
    protected SigoImageResult realResult;

    public SigoImageBaseRequest(Map<String, Object> arguments) {
        requestId = (String) arguments.get("uniqueKey");
        imageRequestConfig = SigoImageRequestConfig.requestConfigWithArguments(arguments);
    }

    public boolean configTask() {
        boolean inited = imageRequestConfig != null;
        imageTaskState = inited ? REQUEST_STATE_INITIALIZE_SUCCEED
                : REQUEST_STATE_INITIALIZE_FAILED;
        return inited;
    }

    public boolean startLoading() {
        if (!REQUEST_STATE_INITIALIZE_SUCCEED.equals(imageTaskState)
                && !REQUEST_STATE_LOAD_FAILED.equals(imageTaskState)) {
            // 只有初始化好 或者 加载失败的情况可以重新加载
            return false;
        }
        if (imageRequestConfig == null) {
            return false;
        }
        performLoadImage();
        return true;
    }

    private void performLoadImage() {
        SigoImageLoader.getInstance().handleRequest(
                imageRequestConfig,
                new SigoImageLoaderProtocol.SigoImageResponse() {
                    @Override
                    public void onResult(SigoImageResult result) {
                        SigoImageBaseRequest.this.onLoadResult(result);
                    }
                }
        );
    }

    void onLoadResult(SigoImageResult result){
        this.realResult = result;
    }

    public void onLoadSuccess() {
        SigoImageDispatcher.getInstance().runOnMainThread(new Runnable() {
            @Override
            public void run() {
                SigoImageBaseRequest.this.imageTaskState = REQUEST_STATE_LOAD_SUCCEED;
                SigoImageFlutterPlugin.SigoImageEventSink.getInstance()
                        .sendImageStateEvent(SigoImageBaseRequest.this.encode(), true);
            }
        });
    }

    public void onLoadFailed(final String errMsg) {
        SigoImageDispatcher.getInstance().runOnMainThread(new Runnable() {
            @Override
            public void run() {
                SigoImageBaseRequest.this.imageTaskState = REQUEST_STATE_LOAD_FAILED;
                Map<String, Object> event = SigoImageBaseRequest.this.encode();
                event.put("errMsg", errMsg != null ? errMsg : "failed!");
                SigoImageFlutterPlugin.SigoImageEventSink.getInstance()
                        .sendImageStateEvent(event, false);
            }
        });
    }

    public boolean stopTask() {
        return false;
    }

    public Map<String, Object> encode() {
        Map<String, Object> encodedTask = new HashMap<>();
        encodedTask.put("uniqueKey", requestId);
        encodedTask.put("state", imageTaskState);
        if(realResult != null && realResult.success && realResult.image instanceof FlutterMultiFrameImage){
            encodedTask.put("_multiFrame", true);
        }
        return encodedTask;
    }
}
