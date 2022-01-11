import 'dart:async';

import 'package:flutter/services.dart';
export 'src/native_webview.dart';
export 'src/fai_webview_controller.dart';

class FlutterFaiWebview {
  static const MethodChannel _channel =
      const MethodChannel('flutter_fai_webview');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
