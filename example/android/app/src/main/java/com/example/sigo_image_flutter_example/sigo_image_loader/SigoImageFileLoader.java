package com.example.sigo_image_flutter_example.sigo_image_loader;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.load.resource.gif.GifDrawable;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.target.Target;
import com.bumptech.glide.request.transition.Transition;
import com.example.sigo_image_flutter.loader.SigoImageLoaderProtocol;
import com.example.sigo_image_flutter.loader.SigoImageResult;
import com.example.sigo_image_flutter.request.SigoImageRequestConfig;

/**
 * created by Muke on 2021/8/12
 */
public class SigoImageFileLoader implements SigoImageLoaderProtocol {

    private final Context context;

    public SigoImageFileLoader(Context context) {
        this.context = context;
    }

    @Override
    public void handleRequest(SigoImageRequestConfig request, SigoImageResponse response) {
        String name = request.srcString();
        if (name == null || name.length() <= 0) {
            response.onResult(SigoImageResult.genFailRet("src 为空"));
            return;
        }
        Uri asset = Uri.parse("file://" + name);
        Glide.with(context).asBitmap().load(asset).listener(new RequestListener<Bitmap>() {
            @Override
            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
                response.onResult(SigoImageResult.genFailRet("Native加载失败: " + (e != null ? e.getMessage() : "null")));
                return true;
            }

            @Override
            public boolean onResourceReady(Bitmap resource, Object model, Target<Bitmap> target, DataSource dataSource, boolean isFirstResource) {
                response.onResult(SigoImageResult.genSucRet(resource));
                return true;
            }
        }).submit(request.width <= 0 ? Target.SIZE_ORIGINAL : request.width,
                request.height <= 0 ? Target.SIZE_ORIGINAL : request.height);
    }
}
