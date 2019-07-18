//
//  FlutterIosWebViewFactory.m
//  Runner
//
//  Created by  androidlongs on 2019/7/18.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "FlutterIosWebViewFactory.h"
#import "FlutterIosWebView.h"

@implementation FlutterIosWebViewFactory{
    NSObject<FlutterBinaryMessenger>*_messenger;
}
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
}

//设置参数的编码方式
-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

//用来创建 ios 原生view
- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    //args 为flutter 传过来的参数
    FlutterIosWebView *webView = [[FlutterIosWebView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return webView;
}


@end
