#import "FlutterFaiWebviewPlugin.h"
#import "FlutterIosWebViewFactory.h"

@implementation FlutterFaiWebviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_fai_webview"
            binaryMessenger:[registrar messenger]];
  FlutterFaiWebviewPlugin* instance = [[FlutterFaiWebviewPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

   [registrar registerViewFactory:[[FlutterIosWebViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"com.flutter_to_native_webview"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
