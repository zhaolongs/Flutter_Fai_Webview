import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_fai_webview');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterFaiWebview.platformVersion, '42');
  });
}
