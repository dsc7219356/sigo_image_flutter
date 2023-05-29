package com.example.sigo_image_flutter.loader;

import android.graphics.Bitmap;

import com.example.sigo_image_flutter.request.SigoImageRequestConfig;
/**
 * created by Muke on 2021/7/22
 */
public interface SigoImageLoaderProtocol {

    interface SigoImageResponse {
        void onResult(SigoImageResult result);
    }

    void handleRequest(SigoImageRequestConfig request, SigoImageResponse response);

}
