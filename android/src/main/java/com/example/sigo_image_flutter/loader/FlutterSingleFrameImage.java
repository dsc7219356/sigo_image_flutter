package com.example.sigo_image_flutter.loader;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.view.Surface;


public class FlutterSingleFrameImage extends FlutterImage {
    private Bitmap bitmap;
    private final Rect srcRect;

    public FlutterSingleFrameImage(BitmapDrawable drawable) {
        this(drawable, false);
    }

    public FlutterSingleFrameImage(Drawable drawable,  boolean needRecycle) {
        super(drawable,  needRecycle);
        if(drawable instanceof BitmapDrawable){
            bitmap = ((BitmapDrawable) drawable).getBitmap();
        }
        srcRect = new Rect(0, 0, getWidth(), getHeight());
    }

    @Override
    public int getFrameCount() {
        return 1;
    }

    @Override
    public void release() {
        if (needRecycle && bitmap != null) {
            bitmap.recycle();
            bitmap = null;
        }
    }

    @Override
    public int getWidth() {
        return bitmap.getWidth();
    }

    @Override
    public int getHeight() {
        return bitmap.getHeight();
    }

    @Override
    public void draw(Surface surface, Rect destRect) {
        final Canvas canvas = surface.lockCanvas(null);
        canvas.drawBitmap(bitmap, srcRect, destRect, null);
        surface.unlockCanvasAndPost(canvas);
    }

    @Override
    public boolean isValid() {
        return bitmap != null && !bitmap.isRecycled();
    }
}
