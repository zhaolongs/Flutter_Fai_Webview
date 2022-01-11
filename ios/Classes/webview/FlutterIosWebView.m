//
//  FlutterIosWebView.m
//  Runner
//
//  Created by  androidlongs on 2019/7/18.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "FlutterIosWebView.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface FlutterIosWebView() <WKUIDelegate,UIScrollViewDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@end

@implementation FlutterIosWebView{
    //FlutterIosTextLabel 创建后的标识
    int64_t _viewId;
    WKWebView * _webView;
    //消息回调
    FlutterMethodChannel* _channel;
    BOOL htmlImageIsClick;
    NSMutableArray* mImageUrlArray;
}

-(instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        if (frame.size.width==0) {
            frame=CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 22);
        }
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];

            config.preferences = [[WKPreferences alloc] init];

            config.preferences.minimumFontSize = 10;

            config.preferences.javaScriptEnabled = YES;

            config.preferences.javaScriptCanOpenWindowsAutomatically = NO;

           
        
       
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:self name:@"otherJsMethodCall"];

        config.userContentController = userContentController;

            config.processPool = [[WKProcessPool alloc] init];

        _webView = [[WKWebView alloc] initWithFrame:frame configuration:config];
    
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.scrollView.delegate = self;
        _viewId = viewId;
        
        //接收 初始化参数
        NSDictionary *dic = args;
        NSString *content = dic[@"content"];
        htmlImageIsClick = dic[@"htmlImageIsClick"];
        
        
        // 注册flutter 与 ios 通信通道
        NSString* channelName = [NSString stringWithFormat:@"com.flutter_to_native_webview_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall *  call, FlutterResult  result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
    }
    return self;
    
}

-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)results{
    if ([[call method] isEqualToString:@"load"]) {
        //获取参数
        NSDictionary *dict = call.arguments;
        NSString *url = dict[@"url"];
        NSString *htmlData = dict[@"htmlData"];
        NSString *htmlDataBlock = dict[@"htmlBlockData"];
        if (![url isKindOfClass:[NSNull class]]&& url!=nil) {
            
            //只需在webView的loadHTMLString:baseURL:方法执行之前或之后将webView的高度强行设置为0，
            //此时webView貌似就放弃了那个倔强的缺省高度，而是按照真实的内容来返回了
            CGRect frame = _webView.frame;
               frame.size.height = 0;
            _webView.frame = frame;
            
            
            NSURL *requestUrl = [NSURL URLWithString:url];
            NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
            [_webView loadRequest:request];
        }else if(![htmlData isKindOfClass:[NSNull class]]&&htmlData!=nil){
            NSData *data =[htmlData dataUsingEncoding:NSUTF8StringEncoding];
            
          
        [_webView loadData:data MIMEType:@"text/html" characterEncodingName:@"utf-8" baseURL:nil];
            
            
        }else if(![htmlDataBlock isKindOfClass:[NSNull class]]&&htmlDataBlock!=nil){
            
           
            
            /**
             *1、在Info.plist中添加 NSAppTransportSecurity 类型 Dictionary ;
             *2、在 NSAppTransportSecurity 下添加 NSAllowsArbitraryLoads 类型Boolean ,值设为 YES
             *
             */
            NSArray * array = [htmlDataBlock componentsSeparatedByString:@"</head>"];
            if(array.count==2){
                htmlDataBlock=[NSString stringWithFormat:@"%@ %@  %@ %@ ",array[0],@"<meta name=\"viewport\" content=\"width=divice-width,initial-scale=1.0\" > ",@" <style>html{margin:0;padding:0;font-family: sans-serif;font-size:14px} body{margin:10px;padding:0} img{width:99%;height:auto;}</style>  </head> ",array[1]];
            }else{
                htmlDataBlock=[NSString stringWithFormat:@"<html><head> <meta name=\"viewport\" content=\"width=divice-width,initial-scale=1.0\" >  <style>html{margin:0;padding:0;font-family: sans-serif;font-size:14px} body{margin:10px;padding:0} img{width:99%%;height:auto;}</style> <body> %@ </body></html>",htmlDataBlock];
            }
             if (htmlImageIsClick) {
                 //htmlDataBlock =[self htmlCotentSupportImagePreview:htmlDataBlock];
             }
            NSData *data =[htmlDataBlock dataUsingEncoding:NSUTF8StringEncoding];
            [_webView loadData:data MIMEType:@"text/html" characterEncodingName:@"utf-8" baseURL:nil];
            
        }
        
        
    }else  if ([[call method] isEqualToString:@"reload"]) {
        if (_webView!=nil) {
            [_webView reload];
        }
    }else  if ([[call method] isEqualToString:@"jsload"]) {
        NSDictionary *dict = call.arguments;
        NSString *jsMethod = dict[@"string"];
        if (_webView!=nil) {
            [_webView evaluateJavaScript:jsMethod completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@"%@--%@",result,error);
            }];

        }
    }else  if ([[call method] isEqualToString:@"goBack"]) {
        if (_webView!=nil&&[_webView canGoBack]) {
            [_webView goBack];
        }
    }else  if ([[call method] isEqualToString:@"goForward"]) {
        if (_webView!=nil&&[_webView canGoForward]) {
            [_webView goForward];
        }
    }else  if ([[call method] isEqualToString:@"canGoForward"]) {
        if (_webView!=nil) {
            results([NSString stringWithFormat:@"%@",[_webView canGoForward]?@"true":@"false"]);
        }
    }else  if ([[call method] isEqualToString:@"canGoBack"]) {
        if (_webView!=nil) {
            results([NSString stringWithFormat:@"%@",[_webView canGoBack]?@"true":@"false"]);
        }
    }else{
        //其他方法的回调
    }
}

#pragma mark -- 实现WKNavigationDelegate委托协议

//开始加载时调用

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"开始加载");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:401] forKey:@"code"];
    [dict setObject:@"webview 开始加载" forKey:@"message"];
    [dict setObject:@"success" forKey:@"content"];
    
    [self messagePost:dict];

}

//当内容开始返回时调用

-(void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"内容开始返回");

}

//加载完成之后调用

-(void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"加载完成");
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:402] forKey:@"code"];
    [dict setObject:@"webview 加载完成" forKey:@"message"];
    [dict setObject:@"success" forKey:@"content"];
    
    [self messagePost:dict];
    
    
    
//    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    //定义好JS要调用的方法, share就是调用的share方法名
//    context[@"pageFinish"] = ^() {
//
//        NSArray *args = [JSContext currentArguments];
//        JSValue *height = args[0];
//        NSLog(@"测量完成 %@",height);
//        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
//        [dict2 setObject:[NSNumber numberWithInt:201] forKey:@"code"];
//        [dict2 setObject:@"测量成功V" forKey:@"message"];
//        [dict2 setObject:[NSNumber numberWithDouble:height.toDouble] forKey:@"content"];
//
//        [self messagePost:dict2];
//    };
//    context[@"allImageUrls"] = ^() {
//
//        NSArray *args = [JSContext currentArguments];
//        JSValue *url = args[0];
//        NSLog(@"allImageUrls完成 -> %@",url);
//        NSArray * array = [url.toString componentsSeparatedByString:@","];
//        self->mImageUrlArray=[NSMutableArray arrayWithArray:array];
//
//    };
//    context[@"showImageClick"] = ^() {
//
//        NSArray *args = [JSContext currentArguments];
//        JSValue *url = args[0];
//        NSLog(@"图片点击事件完成 %@",url);
//        //当前点击的图片的角标
//        int index =0;
//        if (self->mImageUrlArray!=nil) {
//            for (int i=0; i<self->mImageUrlArray.count; i++) {
//                NSString *itemUrl = self->mImageUrlArray[i];
//                if ([itemUrl isEqualToString:url.toString]) {
//                    index=i;
//                    break;
//                }
//            }
//            NSLog(@"图片点击事件完成  %d %@  %@",index,url,self->mImageUrlArray);
//
//
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            [dict setObject:[NSNumber numberWithInt:203] forKey:@"code"];
//            [dict setObject:@"图片点击 方法回调" forKey:@"message"];
//            [dict setObject:url.toString forKey:@"content"];
//
//             [dict setObject:url.toString forKey:@"url"];
//            [dict setObject:[NSNumber numberWithInt:index] forKey:@"index"];
//            if (self->mImageUrlArray!=nil) {
//                [dict setObject:self->mImageUrlArray forKey:@"images"];
//            }
//            [self messagePost:dict];
//
//        }
//    };
//
//            context[@"otherJsMethodCall"] = ^() {
//
//                NSArray *args = [JSContext currentArguments];
//                JSValue *url = args[0];
//                NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
//                [dict2 setObject:[NSNumber numberWithInt:202] forKey:@"code"];
//                [dict2 setObject:@"js 方法回调" forKey:@"message"];
//                [dict2 setObject:url.toString forKey:@"content"];
//                 [self messagePost:dict2];
//
//            };
//    context[@"console"][@"log"] = ^(JSValue * msg) {
//        NSLog(@"H5  log : %@", msg);
//    };
//    context[@"console"][@"warn"] = ^(JSValue * msg) {
//        NSLog(@"H5  warn : %@", msg);
//    };
//    context[@"console"][@"error"] = ^(JSValue * msg) {
//        NSLog(@"H5  error : %@", msg);
//
//    };

    
  
    
    NSString * jsStr  =@"javascript:pageFinish(document.body.getBoundingClientRect().height)";

        [webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {

          
           

        }];
    
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError *_Nullable error) {
            //获取页面高度
            CGFloat scrollHeight = [result doubleValue];
            NSLog(@"scrollHeight 即为所求：%f",scrollHeight);
        NSLog(@"测量完成 %f",scrollHeight);
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
        [dict2 setObject:[NSNumber numberWithInt:201] forKey:@"code"];
        [dict2 setObject:@"测量成功V" forKey:@"message"];
        [dict2 setObject:[NSNumber numberWithFloat:scrollHeight] forKey:@"content"];
        
        [self messagePost:dict2];
        }];

}
//实现js注入方法的协议方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // message.name   message.body 获取参数
    //找到对应js端的方法名,获取messge.body
    
    NSLog(@"实现js注入方法的协议方法body %@", message.body);
    NSLog(@"实现js注入方法的协议方法 name %@", message.name);
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
                   [dict2 setObject:[NSNumber numberWithInt:202] forKey:@"code"];
                   [dict2 setObject:@"js 方法回调" forKey:@"message"];
                   [dict2 setObject:message.body forKey:@"content"];
                    [self messagePost:dict2];
    
}

//加载失败时调用

-(void)webView:(WKWebView *)webView didFailLoadWithError:(nonnull NSError *)error{
    NSLog(@"加载失败 error : %@",error.description);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:404] forKey:@"code"];
    [dict setObject:@"webview 加载出错" forKey:@"message"];
    [dict setObject:@"err" forKey:@"content"];
    [self messagePost:dict];

}
- (nonnull UIView *)view {
    return _webView;
}



int _lastPosition;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
        NSLog(@"ScrollUp now");
        //向上滑动
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSNumber numberWithInt:303] forKey:@"code"];
        [dict setObject:@"webview 向上滑动" forKey:@"message"];
        [dict setObject:@"scroll " forKey:@"content"];
        
        [self messagePost:dict];
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        NSLog(@"ScrollDown now");
        //向下滑动
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSNumber numberWithInt:302] forKey:@"code"];
        [dict setObject:@"webview 向下滑动" forKey:@"message"];
        [dict setObject:@"scroll" forKey:@"content"];
        
        [self messagePost:dict];
    }
    
    
    
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)conOffset{
    
    if (velocity.y > 0.0f) {
        //不在顶部
        NSLog(@"ScrollDown now");
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
        CGFloat maximumOffset = size.height;
        //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。
        if(currentOffset>=maximumOffset){
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithInt:304] forKey:@"code"];
            [dict setObject:@"webview 滑动到了底部" forKey:@"message"];
            [dict setObject:@"scroll" forKey:@"content"];
            [self messagePost:dict];
        }
        
        
    }else if (velocity.y < - 0.0f ){
        //在顶部
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSNumber numberWithInt:301] forKey:@"code"];
        [dict setObject:@"webview 滑动到了顶部" forKey:@"message"];
        [dict setObject:@"scroll" forKey:@"content"];
        
        [self messagePost:dict];
        
    }else{
        //在中间
    }
    
}





-(void) messagePost:(NSDictionary *)dict{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [self->_channel invokeMethod:@"ios" arguments:dict];
    });
}




static NSString *constjsGetImages =@"function getImages(){\    var objs = document.getElementsByTagName(\"img\");\    var imgScr = '';\    for(var i=0;i    imgScr = imgScr + objs[i].src + '+';\    };\    return imgScr;\};";

static NSString *imageClickStr =@" function registerImageClickAction(){\
var imgs=document.getElementsByTagName('img');console.log('test log');  var length=imgs.length; for(var i=0;i<length;i++){\ img=imgs[i]; console.log('test img 1'); img.onclick=function(){\ console.log('test img click '+this.src); showImageClick(this.src,imageUrls); }\ }\ }\ ";
static NSString *imageUrlsStr =@" var imageUrls=\"\" ; function getImageUrls(){\
var imgs=document.getElementsByTagName('img'); console.log('test img 4'); var length=imgs.length; for(var i=0;i<length;i++){\ img=imgs[i]; if(i==0){imageUrls=img.src;}else{imageUrls+=\",\"+img.src;}\ }\ allImageUrls(imageUrls); }\ ";

@end
