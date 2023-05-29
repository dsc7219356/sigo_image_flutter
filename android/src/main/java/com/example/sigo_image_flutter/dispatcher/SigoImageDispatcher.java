package com.example.sigo_image_flutter.dispatcher;
import android.os.Handler;
import android.os.Looper;
public class SigoImageDispatcher {
    private static volatile SigoImageDispatcher sInstance;

    private Handler workHandler;
    private Handler mainHandler;
    private Looper workLooper;

    public static SigoImageDispatcher getInstance() {
        if (sInstance == null) {
            synchronized (SigoImageDispatcher.class) {
                if (sInstance == null) {
                    sInstance = new SigoImageDispatcher();
                }
            }
        }
        return sInstance;
    }

    public void prepare() {
        mainHandler = new Handler(Looper.getMainLooper());
        Thread workThread = new Thread(new Runnable() {
            @Override
            public void run() {
                Looper.prepare();
                workLooper = Looper.myLooper();
                workHandler = new Handler();
                Looper.loop();
            }
        });
        workThread.setName("com.taobao.power_image.work");
        workThread.start();
    }

    public void runOnWorkThread(Runnable runnable) {
        if (runnable == null || workHandler == null) {
            return;
        }

        if (Looper.myLooper() == workLooper) {
            runnable.run();
            return;
        }
        workHandler.post(runnable);
    }

    public void runOnMainThread(Runnable runnable) {
        if (runnable == null || mainHandler == null) {
            return;
        }

        if (Looper.myLooper() == Looper.getMainLooper()) {
            runnable.run();
            return;
        }

        mainHandler.post(runnable);
    }

    public void runOnMainThreadDelayed(Runnable runnable, long delayMillis) {
        if (runnable == null || mainHandler == null) {
            return;
        }

        mainHandler.postDelayed(runnable, delayMillis);
    }
}
