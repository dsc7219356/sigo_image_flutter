package com.example.sigo_image_flutter.loader;

import com.example.sigo_image_flutter.request.SigoImageRequestConfig;


import java.util.HashMap;
import java.util.Map;
/**
 * created by Muke on 2021/7/22
 */
public class SigoImageLoader implements SigoImageLoaderProtocol {

    private final Map<String, SigoImageLoaderProtocol> imageLoaders;

    private SigoImageLoader() {
        imageLoaders = new HashMap<>();
    }

    private static class Holder {
        private final static SigoImageLoader instance = new SigoImageLoader();
    }

    public static SigoImageLoader getInstance() {
        return Holder.instance;
    }

    public void registerImageLoader(SigoImageLoaderProtocol loader, String imageType) {
        imageLoaders.put(imageType, loader);
    }

    @Override
    public void handleRequest(SigoImageRequestConfig request, SigoImageResponse response) {
        SigoImageLoaderProtocol imageLoader = imageLoaders.get(request.imageType);
        if (imageLoader == null) {
            throw new IllegalStateException("PowerImageLoader for "
                    + request.imageType + " has not been registered.");
        }
        imageLoader.handleRequest(request, response);
    }
}
