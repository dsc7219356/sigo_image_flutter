import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sigo_image_flutter/sigo_image_flutter.dart';

void main() {
  SigoImageBinding();
  SigoImageLoader.instance.setup(SigoImageSetupOptions(renderingTypeTexture,
      errorCallbackSamplingRate: null,
      errorCallback: (SigoImageLoadException exception) {}));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SigoImage.network('https://images.vsigo.cn/products/contacts/700-700/202355111244471.jpg'),
        ),
      ),
    );
  }
}
