//
//  FlutterIosWebView.m
//  Runner
//
//  Created by  androidlongs on 2019/7/18.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "FlutterIosWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface FlutterIosWebView() <UIWebViewDelegate,UIScrollViewDelegate>

@end

@implementation FlutterIosWebView{
    //FlutterIosTextLabel 创建后的标识
    int64_t _viewId;
    UIWebView * _webView;
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
        _webView =[[UIWebView alloc] initWithFrame:frame];
        _webView.delegate=self;
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
            NSURL *requestUrl = [NSURL URLWithString:url];
            NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
            [_webView loadRequest:request];
        }else if(![htmlData isKindOfClass:[NSNull class]]&&htmlData!=nil){
            NSData *data =[htmlData dataUsingEncoding:NSUTF8StringEncoding];
            [_webView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
            
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
            [_webView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
            
        }
        
        
    }else  if ([[call method] isEqualToString:@"reload"]) {
        if (_webView!=nil) {
            [_webView reload];
        }
    }else  if ([[call method] isEqualToString:@"jsload"]) {
        NSDictionary *dict = call.arguments;
        NSString *jsMethod = dict[@"string"];
        if (_webView!=nil) {
            [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:%@",jsMethod]];
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


- (nonnull UIView *)view {
    return _webView;
}

//web view 代理相关
// Sent before a web view begins loading a frame.请求发送前都会调用该方法,返回NO则不处理这个请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}
// Sent after a web view starts loading a frame. 请求发送之后开始接收响应之前会调用这个方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:401] forKey:@"code"];
    [dict setObject:@"webview 开始加载" forKey:@"message"];
    [dict setObject:@"success" forKey:@"content"];
    
    [self messagePost:dict];
}

// Sent after a web view finishes loading a frame. 请求发送之后,并且服务器已经返回响应之后调用该方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:402] forKey:@"code"];
    [dict setObject:@"webview 加载完成" forKey:@"message"];
    [dict setObject:@"success" forKey:@"content"];
    
    [self messagePost:dict];
    
    
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //定义好JS要调用的方法, share就是调用的share方法名
    context[@"pageFinish"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        JSValue *height = args[0];
        NSLog(@"测量完成 %@",height);
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
        [dict2 setObject:[NSNumber numberWithInt:201] forKey:@"code"];
        [dict2 setObject:@"测量成功V" forKey:@"message"];
        [dict2 setObject:[NSNumber numberWithDouble:height.toDouble] forKey:@"content"];
        
        [self messagePost:dict2];
    };
    context[@"allImageUrls"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        JSValue *url = args[0];
        NSLog(@"allImageUrls完成 -> %@",url);
        NSArray * array = [url.toString componentsSeparatedByString:@","];
        self->mImageUrlArray=[NSMutableArray arrayWithArray:array];
        
    };
    context[@"showImageClick"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        JSValue *url = args[0];
        NSLog(@"图片点击事件完成 %@",url);
        //当前点击的图片的角标
        int index =0;
        if (self->mImageUrlArray!=nil) {
            for (int i=0; i<self->mImageUrlArray.count; i++) {
                NSString *itemUrl = self->mImageUrlArray[i];
                if ([itemUrl isEqualToString:url.toString]) {
                    index=i;
                    break;
                }
            }
            NSLog(@"图片点击事件完成  %d %@  %@",index,url,self->mImageUrlArray);
            
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithInt:203] forKey:@"code"];
            [dict setObject:@"图片点击 方法回调" forKey:@"message"];
            [dict setObject:url.toString forKey:@"content"];
            
             [dict setObject:url.toString forKey:@"url"];
            [dict setObject:[NSNumber numberWithInt:index] forKey:@"index"];
            if (self->mImageUrlArray!=nil) {
                [dict setObject:self->mImageUrlArray forKey:@"images"];
            }
            [self messagePost:dict];
            
        }
    };
    
    context[@"console"][@"log"] = ^(JSValue * msg) {
        NSLog(@"H5  log : %@", msg);
    };
    context[@"console"][@"warn"] = ^(JSValue * msg) {
        NSLog(@"H5  warn : %@", msg);
    };
    context[@"console"][@"error"] = ^(JSValue * msg) {
        NSLog(@"H5  error : %@", msg);
     
    };

    
    [webView stringByEvaluatingJavaScriptFromString:@"javascript:pageFinish(document.body.getBoundingClientRect().height)"];
   
    
    if (htmlImageIsClick) {
        [webView stringByEvaluatingJavaScriptFromString:@"javascript:getAllImgSrc(document.body.innerHTML)"];
        [webView stringByEvaluatingJavaScriptFromString:constjsGetImages];//注入js方法
        //执行
        NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];

        //添加图片可点击js
        
        [webView stringByEvaluatingJavaScriptFromString:imageClickStr];
        //获取所有的 image url
         [webView stringByEvaluatingJavaScriptFromString:imageUrlsStr];
        [webView stringByEvaluatingJavaScriptFromString:@"getImageUrls()"];
        
        [webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];
    }
    
    

    
    
}

// Sent if a web view failed to load a frame. 网页请求失败则会调用该方法
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:404] forKey:@"code"];
    [dict setObject:@"webview 加载出错" forKey:@"message"];
    [dict setObject:@"err" forKey:@"content"];
    
    [self messagePost:dict];
}

// 开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

// 结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
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
