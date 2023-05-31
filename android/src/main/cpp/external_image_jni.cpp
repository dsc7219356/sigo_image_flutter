#include <jni.h>
#include <android/bitmap.h>
#include <android/log.h>

#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, "sigo_image_flutter_jni", __VA_ARGS__)

//extern "C" JNIEXPORT jlong JNICALL
//Java_com_example_sigo_1image_1flutter_request_SigoImageExternalRequest_getByteBufferPtr(
//        JNIEnv* env,
//        jobject clazz,
//        jobject byte_buffer) {
//    jbyte *cData = (jbyte*)env->GetDirectBufferAddress(byte_buffer);//获取指针
//    return (jlong)cData;
//}
//
//extern "C" JNIEXPORT jlong JNICALL
//Java_com_example_sigo_1image_1flutter_request_SigoImageExternalRequest_getBitmapPixelsPtr(
//        JNIEnv* env,
//        jobject clazz,
//        jobject bitmap) {
//    void *addrPtr;
//    int ret = AndroidBitmap_lockPixels(env, bitmap, &addrPtr);
//    if (ret < 0) {
//        LOGE("AndroidBitmap_lockPixels failed : %d", ret);
//        return 0;
//    }
//    return (jlong)addrPtr;
//}
//
//extern "C" JNIEXPORT void JNICALL
//Java_com_com_example_1sigo_1image_flutter_request_SigoImageExternalRequest_releaseBitmapPixels(
//        JNIEnv* env,
//        jobject clazz,
//        jobject bitmap) {
//    int ret = AndroidBitmap_unlockPixels(env,bitmap);
//    if (ret < 0) {
//        LOGE("AndroidBitmap_unlockPixels failed : %d", ret);
//    }
//}
extern "C"
JNIEXPORT jlong JNICALL
Java_com_example_sigo_1image_1flutter_request_SigoImageExternalRequest_getBitmapPixelsPtr(
        JNIEnv *env, jobject thiz, jobject bitmap) {
    // TODO: implement getBitmapPixelsPtr()
        void *addrPtr;
    int ret = AndroidBitmap_lockPixels(env, bitmap, &addrPtr);
    if (ret < 0) {
        LOGE("AndroidBitmap_lockPixels failed : %d", ret);
        return 0;
    }
    return (jlong)addrPtr;
}
extern "C"
JNIEXPORT void JNICALL
Java_com_example_sigo_1image_1flutter_request_SigoImageExternalRequest_releaseBitmapPixels(
        JNIEnv *env, jobject thiz, jobject bitmap) {
    // TODO: implement releaseBitmapPixels()
    //    int ret = AndroidBitmap_unlockPixels(env,bitmap);
    int ret = AndroidBitmap_unlockPixels(env,bitmap);
    if (ret < 0) {
        LOGE("AndroidBitmap_unlockPixels failed : %d", ret);
    }
}