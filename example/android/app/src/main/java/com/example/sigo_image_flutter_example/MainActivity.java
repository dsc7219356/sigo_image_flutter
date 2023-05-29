package com.example.sigo_image_flutter_example;

import com.example.sigo_image_flutter.loader.SigoImageLoader;
import com.example.sigo_image_flutter_example.sigo_image_loader.SigoImageFileLoader;
import com.example.sigo_image_flutter_example.sigo_image_loader.SigoImageFlutterAssetLoader;
import com.example.sigo_image_flutter_example.sigo_image_loader.SigoImageNativeAssetLoader;
import com.example.sigo_image_flutter_example.sigo_image_loader.SigoImageNetworkLoader;

import io.flutter.embedding.android.FlutterActivity;
import android.os.Bundle;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SigoImageLoader.getInstance().registerImageLoader(
                new SigoImageNetworkLoader(this.getApplicationContext()), "network");
        SigoImageLoader.getInstance().registerImageLoader(
                new SigoImageNativeAssetLoader(this.getApplicationContext()), "nativeAsset");
        SigoImageLoader.getInstance().registerImageLoader(
                new SigoImageFlutterAssetLoader(this.getApplicationContext()), "asset");
        SigoImageLoader.getInstance().registerImageLoader(
                new SigoImageFileLoader(this.getApplicationContext()), "file");
    }
}
