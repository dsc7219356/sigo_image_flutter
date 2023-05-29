package com.example.sigo_image_flutter.loader;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;


import com.example.sigo_image_flutter.SigoImageFlutterPlugin;

import java.util.Map;

public class SigoImageResult {
    public final FlutterImage image;
    public final boolean success;
    public final String errMsg;
    public final ExtData ext;

    public interface ExtData {
        Map<String, Object> encode();
    }

    public SigoImageResult(FlutterImage image, boolean success, String errMsg, ExtData ext) {
        this.image = image;
        this.success = success;
        this.errMsg = errMsg;
        this.ext = ext;
    }

    public SigoImageResult(Bitmap bitmap, boolean success, String errMsg, ExtData ext) {
        if(bitmap != null){
            Context context = SigoImageFlutterPlugin.getContext();
            if(context != null){
                this.image = new FlutterSingleFrameImage(new BitmapDrawable(context.getResources(), bitmap));
            }else {
                this.image = null;
            }
        }else {
            this.image = null;
        }
        this.success = success;
        this.errMsg = errMsg;
        this.ext = ext;
    }


    public static SigoImageResult genSucRet(Bitmap bitmap) {
        return genSucRet(bitmap, null);
    }

    public static SigoImageResult genSucRet(Bitmap bitmap, ExtData ext) {
        return new SigoImageResult(bitmap, true, null, ext);
    }


    public static SigoImageResult genSucRet(FlutterImage image) {
        return genSucRet(image, null);
    }

    public static SigoImageResult genSucRet(FlutterImage image, ExtData ext) {
        return new SigoImageResult(image, true, null, ext);
    }



    public static SigoImageResult genFailRet(String errMsg, ExtData ext) {
        return new SigoImageResult((FlutterImage)null, false, errMsg, ext);
    }

    public static SigoImageResult genFailRet(String errMsg) {
        return genFailRet(errMsg, null);
    }


}
