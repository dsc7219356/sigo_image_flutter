import 'package:flutter/cupertino.dart';
import 'package:sigo_image_flutter/src/texture/sigo_texture_image.dart';
import 'package:sigo_image_flutter/src/texture/sigo_texture_image_provider.dart';
import '../sigo_image_flutter.dart';
import 'external/sigo_external_image.dart';
import 'external/sigo_external_image_provider.dart';
import 'image_ext/image_ext.dart';


class SigoImage extends StatefulWidget {
  /// 网络图，将从 native 图片库中获取图片。
  ///
  /// 关于 renderingType 渲染方式：renderingTypeExternal/renderingTypeTexture
  /// 可以设置全局  PowerImageLoader.instance.setup(PowerImageSetupOptions(renderingTypeExternal));
  /// 也可单独设置某张图的渲染方式
  ///
  SigoImage.network(
    String src, {
    Key? key,
    String? renderingType,
    double? imageWidth,
    double? imageHeight,
    this.width,
    this.height,
    this.frameBuilder,
    this.errorBuilder,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  })  : image = SigoImageProvider.options(SigoImageRequestOptions(
            src: SigoImageRequestOptionsSrcNormal(src: src),
            renderingType: renderingType,
            imageType: imageTypeNetwork,
            imageWidth: imageWidth ?? width,
            imageHeight: imageHeight ?? height)),
        imageBuilder = null,
        super(key: key);

  /// native 本地图片。
  ///
  /// 关于 renderingType 渲染方式：renderingTypeExternal/renderingTypeTexture
  /// 可以设置全局  PowerImageLoader.instance.setup(PowerImageSetupOptions(renderingTypeExternal));
  /// 也可单独设置某张图的渲染方式
  ///
  SigoImage.nativeAsset(
    String src, {
    Key? key,
    String? renderingType,
    double? imageWidth,
    double? imageHeight,
    this.width,
    this.height,
    this.frameBuilder,
    this.errorBuilder,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  })  : image = SigoImageProvider.options(SigoImageRequestOptions(
            src: SigoImageRequestOptionsSrcNormal(src: src),
            renderingType: renderingType,
            imageType: imageTypeNativeAssert,
            imageWidth: imageWidth ?? width,
            imageHeight: imageHeight ?? height)),
        imageBuilder = null,
        super(key: key);

  /// flutter 本地图片。
  ///
  /// 关于 renderingType 渲染方式：renderingTypeExternal/renderingTypeTexture
  /// 可以设置全局  PowerImageLoader.instance.setup(PowerImageSetupOptions(renderingTypeExternal));
  /// 也可单独设置某张图的渲染方式
  ///
  SigoImage.asset(
    String src, {
    Key? key,
    String? renderingType,
    double? imageWidth,
    double? imageHeight,
    String? package,
    this.width,
    this.height,
    this.frameBuilder,
    this.errorBuilder,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  })  : image = SigoImageProvider.options(SigoImageRequestOptions(
            src: SigoImageRequestOptionsSrcAsset(src: src, package: package),
            renderingType: renderingType,
            imageType: imageTypeAssert,
            imageWidth: imageWidth ?? width,
            imageHeight: imageHeight ?? height)),
        imageBuilder = null,
        super(key: key);

  /// native 本地图片文件。
  ///
  /// 关于 renderingType 渲染方式：renderingTypeExternal/renderingTypeTexture
  /// 可以设置全局  PowerImageLoader.instance.setup(PowerImageSetupOptions(renderingTypeExternal));
  /// 也可单独设置某张图的渲染方式
  ///
  SigoImage.file(
    String src, {
    Key? key,
    String? renderingType,
    double? imageWidth,
    double? imageHeight,
    this.width,
    this.height,
    this.frameBuilder,
    this.errorBuilder,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  })  : image = SigoImageProvider.options(SigoImageRequestOptions(
            src: SigoImageRequestOptionsSrcNormal(src: src),
            renderingType: renderingType,
            imageType: imageTypeFile,
            imageWidth: imageWidth ?? width,
            imageHeight: imageHeight ?? height)),
        imageBuilder = null,
        super(key: key);

  /// 自定义 imageType\src
  /// 效果：将src encode 后，完成地传递给 native 对应 imageType 注册的 loader
  /// 使用场景：
  /// 例如，自定义加载相册照片，通过自定义 imageType 为 "album"，
  /// native 侧注册 "album" 类型的 loader 自定义图片的加载。
  SigoImage.type(
    String imageType, {
    required SigoImageRequestOptionsSrc src,
    Key? key,
    String? renderingType,
    double? imageWidth,
    double? imageHeight,
    this.width,
    this.height,
    this.frameBuilder,
    this.errorBuilder,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  })  : image = SigoImageProvider.options(SigoImageRequestOptions(
            src: src,
            renderingType: renderingType,
            imageType: imageType,
            imageWidth: imageWidth ?? width,
            imageHeight: imageHeight ?? height)),
        imageBuilder = null,
        super(key: key);

  /// 更加灵活的方式，通过自定义options来展示图片
  ///
  /// PowerImageRequestOptions({
  ///   @required this.src,   //资源
  ///   @required this.imageType, //资源类型，如网络图，本地图或者自定义等
  ///   this.renderingType, //渲染方式，默认全局
  ///   this.imageWidth,  //图片的渲染的宽度
  ///   this.imageHeight, //图片渲染的高度
  /// });
  ///
  /// PowerExternalImageProvider（FFI[bitmap]方案）
  /// PowerTextureImageProvider（texture方案）
  ///
  /// 使用场景：
  /// 例如，自定义加载相册照片，通过自定义 imageType 为 "album"，
  /// native 侧注册 "album" 类型的 loader 自定义图片的加载。
  ///
  SigoImage.options(
      SigoImageRequestOptions options, {
    Key? key,
    this.width,
    this.height,
    this.frameBuilder,
    this.errorBuilder,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  })  : image = SigoImageProvider.options(options),
        imageBuilder = null,
        super(key: key);

  /// 完全自定义的方式，通过自定义 imageProvider 来获取图片，imageBuilder 为扩展的自定义展示，
  ///
  /// 如果使用 （FFI [bitmap pointer] 方案）或者（texture 方案）渲染方案，但要扩展，请使用 PowerImage.options 自定义 imageType，
  /// 详见对应接口注释
  ///
  /// 本接口仅限高阶使用，不要徒增复杂度
  ///
  /// 可能的使用场景：如通过 ffi 解析 decode 前的 data，使用 Hummer 外接 flutter解码库
  const SigoImage({
    Key? key,
    required this.image,
    this.imageBuilder,
    this.frameBuilder,
    this.errorBuilder,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  }) : super(key: key);

  final SigoImageProvider image;
  final ImageFrameBuilder? frameBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final CustomImageBuilder? imageBuilder;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;

  /// same as [Image]
  ///
  /// A Semantic description of the image.
  ///
  /// Used to provide a description of the image to TalkBack on Android, and
  /// VoiceOver on iOS.
  final String? semanticLabel;

  /// Whether to exclude this image from semantics.
  ///
  /// Useful for images which do not contribute meaningful information to an
  /// application.
  final bool excludeFromSemantics;

  @override
  SigoImageState createState() => SigoImageState();
}

class SigoImageState extends State<SigoImage> {
  @override
  Widget build(BuildContext context) {

    ImageErrorWidgetBuilder? errorWidgetBuilder = widget.errorBuilder;
    errorWidgetBuilder ??= (
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    ) {
      return SizedBox(
        width: widget.width ?? 0,
        height: widget.height ?? 0,
      );
    };

    if (widget.image.runtimeType == SigoTextureImageProvider) {
      return SigoTextureImage(
        provider: widget.image as SigoTextureImageProvider,
        frameBuilder: widget.frameBuilder,
        errorBuilder: errorWidgetBuilder,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
        semanticLabel: widget.semanticLabel,
        excludeFromSemantics: widget.excludeFromSemantics,
      );
    } else if (widget.image.runtimeType == SigoExternalImageProvider) {
      return SigoExternalImage(
        provider: widget.image as SigoExternalImageProvider,
        frameBuilder: widget.frameBuilder,
        errorBuilder: errorWidgetBuilder,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
        semanticLabel: widget.semanticLabel,
        excludeFromSemantics: widget.excludeFromSemantics,
      );
    }

    return ImageExt(
      image: widget.image,
      frameBuilder: widget.frameBuilder,
      errorBuilder: errorWidgetBuilder,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      alignment: widget.alignment,
      imageBuilder: widget.imageBuilder,
      semanticLabel: widget.semanticLabel,
      excludeFromSemantics: widget.excludeFromSemantics,
    );
  }
}
