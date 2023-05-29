package com.example.sigo_image_flutter_example.sigo_image_loader;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.Transformation;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.load.engine.Resource;
import com.bumptech.glide.load.resource.gif.GifDrawable;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.target.SimpleTarget;
import com.bumptech.glide.request.target.Target;
import com.bumptech.glide.request.transition.Transition;
import com.example.sigo_image_flutter.loader.FlutterSingleFrameImage;
import com.example.sigo_image_flutter.loader.SigoImageLoaderProtocol;
import com.example.sigo_image_flutter.loader.SigoImageResult;
import com.example.sigo_image_flutter.request.SigoImageRequestConfig;
import com.example.sigo_image_flutter_example.GlideMultiFrameImage;


import java.security.MessageDigest;

/**
 * created by Muke on 2021/7/25
 */
public class SigoImageNetworkLoader implements SigoImageLoaderProtocol {

    private Context context;

    public SigoImageNetworkLoader(Context context) {
        this.context = context;
    }

    @Override
    public void handleRequest(SigoImageRequestConfig request, SigoImageResponse response) {
        Glide.with(context).asDrawable().load(request.srcString()).listener(new RequestListener<Drawable>() {
            @Override
            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                response.onResult(SigoImageResult.genFailRet("Native加载失败: " + (e != null ? e.getMessage() : "null")));
                return true;
            }

            @Override
            public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                if (resource instanceof GifDrawable) {
                    response.onResult(SigoImageResult.genSucRet(new GlideMultiFrameImage((GifDrawable) resource, false)));
                } else {
                    if (resource instanceof BitmapDrawable) {
                        response.onResult(SigoImageResult.genSucRet(new FlutterSingleFrameImage((BitmapDrawable) resource)));
                    } else {
                        response.onResult(SigoImageResult.genFailRet("Native加载失败:  resource : " + String.valueOf(resource)));
                    }
                }
                return true;
            }
        }).submit(request.width <= 0 ? Target.SIZE_ORIGINAL : request.width,
                request.height <= 0 ? Target.SIZE_ORIGINAL : request.height);
    }
}
