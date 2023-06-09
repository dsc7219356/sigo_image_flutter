import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sigo_image_flutter/sigo_image_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('sigo_image_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SigoImageFlutter.platformVersion, '42');
  });
}
