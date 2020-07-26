import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fai_webview/src/fai_webview_controller.dart';

import 'native_webview_event.dart';

@immutable
class FaiWebViewWidget extends StatefulWidget {
  //加载的网页 URL
  final String url;

  //加载 完整html 文件数据 如 <html><head> .... .. </head></html>
  final String htmlData;

  //加载 html 代码块 如<p> .... </p>
  final String htmlBlockData;

  //日志输出
  final bool isLog;

  final bool htmlImageIsClick;

  /**
   * 向 Flutter 中发送消息
   * code
   * 201 测量webview 成功
   * 202 JS调用
   * 203 图片点击回调
   * 301 滑动到顶部
   * 302 向下滑动
   * 303	向上滑动
   * 304 滑动到底部
   * 401 webview 开始加载
   * 402 webview 加载完成
   * 403 webview html中日志输出
   * 404 webview 加载出错
   * 501 webview 弹框回调
   * <p>
   * 1000 操作失败
   *
   * @param map
   */

  /// code 原生 Android iOS 回调 Flutter 的消息类型标识
  /// message 消息类型日志
  /// content 回调的基本数据
  final Function(int code, String message, dynamic content) callback;

  /// 图片点击回调
  /// code :203 图片点击回调
  /// // url 当前点击图片的链接 index 当前点击Html页面中所有图片中的角标 urls 所有图片的集合
  /// content: {"url":"http://pic.studyyoun.com/1543767087584","index":0,"urls":"http://pic.studyyoun.com/1543767087584,http://pic.studyyoun.com/1543767100547"}
  ///
  final Function(int index, String url, List<String> images) imageCallBack;

  ///操作webView的控制器
  final FaiWebViewController controller;

  FaiWebViewWidget({
    //webview 加载网页链接
    this.url,
    //webview 加载 完整的 html 文件数据  如 <html> .... </html>
    // 不完整的 html 文件数据 如 <p></p> 配置到此项，用此属性来加载，只会渲染 <p> ... </p> 中已有的样式 不会适配移动端显示
    this.htmlData,
    //webview 加载完整的 html 文件数据 或者是 不完整的 html 文件数据 如 <p></p>
    //不完整的 html 文件数据 如 <p></p> 配置到此项，会自动将不完整的 html 文件数据 添加 <html><head> .. </head> <body> 原来的内容 </body></html>,并适配移动端
    this.htmlBlockData,
    //输出 Log 日志功能
    this.isLog = false,
    // 为 Html 页面中所有的图片添加 点击事件 并通过回调 通知 Flutter 页面
    // 只有使用 htmlBlockData 属性加载的页面才会有此效果
    this.htmlImageIsClick = false,
    // Html 页面中图片点击回调
    this.imageCallBack,
    // Html 页面中所有的消息回调
    this.callback,
    this.controller,
  });

  @override
  State<StatefulWidget> createState() {
    return AndroidWebViewState(callback,
        url: url,
        htmlBlockData: htmlBlockData,
        isLog: isLog,
        htmlImageIsClick: htmlImageIsClick,
        imageCallBack: imageCallBack,
        htmlData: htmlData);
  }

  void refresh({String htmlData, String htmlBlockData, String htmlUrl}) {
    NativeEventMessage.getDefault().post({
      "code": 100,
      "htmlUrl": htmlUrl,
      "htmlBlockData": htmlBlockData,
      "htmlData": htmlData,
    });
  }

  void loadJsMethod(String string) {
    NativeEventMessage.getDefault().post({
      "code": 101,
      "string": string,
    });
  }
}

class AndroidWebViewState extends State<FaiWebViewWidget> {
  //加载的网页 URL
  String url;

  //自定义网页中的所有的图片的点击事件处理
  bool htmlImageIsClick = false;

  //加载 完整html 文件数据 如 <html><head> .... .. </head></html>
  String htmlData;

  //加载 html 代码块 如<p> .... </p>
  String htmlBlockData;

  //日志输出
  bool isLog = false;
  int viewId = -1;
  MethodChannel _channel;

  //回调
  Function(int code, String message, dynamic content) callback;
  Function(int index, String url, List<String> images) imageCallBack;

  AndroidWebViewState(this.callback,
      {this.url,
      this.htmlData,
      this.htmlBlockData,
      this.isLog,
      this.htmlImageIsClick = false,
      this.imageCallBack});

  @override
  void initState() {
    super.initState();
    NativeEventMessage.getDefault().register((event) {
      int code = event["code"];
      if (code == 100) {
        String htmlData = event["htmlData"];
        String htmlBlockData = event["htmlBlockData"];
        String htmlUrl = event["htmlUrl"];

        if (htmlData != null) {
          this.htmlData = htmlData;
        }
        if (htmlBlockData != null) {
          this.htmlBlockData = htmlBlockData;
        }
        if (htmlUrl != null) {
          this.url = htmlUrl;
        }
        refresh();
      } else if (code == 101) {
        String string = event["string"];
        loadJsMethod(string);
      }
    });

    if (widget.controller != null) {
      widget.controller.setListener((type, event) {
        ///刷新页面方法
        ///目前1.0.0版本还不可动态修改内容
        if (type == 1) {
          String htmlData = event["htmlData"];
          String htmlBlockData = event["htmlBlockData"];
          String htmlUrl = event["htmlUrl"];

          if (htmlData != null) {
            this.htmlData = htmlData;
          }
          if (htmlBlockData != null) {
            this.htmlBlockData = htmlBlockData;
          }
          if (htmlUrl != null) {
            this.url = htmlUrl;
          }
          refresh();
        } else if (type == 2) {
          String jsMethodName = event["jsMethodName"];

          ///Flutter调用 Html中的Js方法
          loadJsMethod("$jsMethodName('${json.encode(event)}')");
        } else if (type == 3) {
          ///返回历史
          goBack();
        } else if (type == 4) {
          ///返回历史
          goForward();
        }
      });

      widget.controller.setBackListener((int type, Map<String, dynamic> event) {
        if (type == 1) {
          return canGoBack();
        } else if (type == 2) {
          return canGoForward();
        } else {
          return Future.value(false);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // NativeEventMessage.getDefault().unregister();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      //ios相关代码
      return buildIosWebView();
    } else if (Platform.isAndroid) {
      //android相关代码
      return buildAndroidWebView();
    } else {
      return Container();
    }
  }

  /// 设置消息监听
  /// code
  /// 201 测量webview 成功 加载完成
  /// 202 JS调用
  /// 301 滑动到顶部
  /// 302 向下滑动
  /// 303	向上滑动
  /// 304 滑动到底部
  /// 401 webview 开始加载
  /// 402 webview 加载完成
  /// 403 webview html中日志输出
  /// 404 webview 加载出错
  ///
  /// @param map
  void nativeMessageListener() async {
    _channel.setMethodCallHandler((resultCall) {
      //处理原生 Android iOS 发送过来的消息
      MethodCall call = resultCall;
      //String method = call.method;
      Map arguments = call.arguments;

      int code = arguments["code"];
      String message = arguments["message"];
      dynamic content = arguments["content"];
      print("native_webview:code-> " +
          code.toString() +
          " ; message:" +
          message.toString() +
          "; content " +
          content.toString());

      if (code == 203) {
        int index = arguments["index"];
        String url = arguments["url"];
        List<String> urls = arguments["urls"];
        if (imageCallBack != null) {
          imageCallBack(index, url, urls);
        }
      }

      if (callback != null) {
        print("native_webview callback");
        callback(code, message, content);
      } else {
        print("native_webview callback is null ");
      }
      return Future.value(true);
    });
  }

  void loadUrl() async {
    _channel.invokeMethod('load', {
      "url": url,
      "htmlData": htmlData,
      "htmlBlockData": htmlBlockData,
    });
  }

  void reLoad() async {
    _channel.invokeMethod('reload');
  }

  void goBack() {
    _channel.invokeMethod('goBack');
  }

  void goForward() {
    _channel.invokeMethod('goForward');
  }

  Future<bool> canGoBack() async {
    if(Platform.isAndroid){
      return await _channel.invokeMethod('canGoBack');
    }else{
      return await _channel.invokeMethod('canGoBack')=="false"?false:true;
    }
  }

  Future<bool> canGoForward() async {
    if(Platform.isAndroid){
      return await _channel.invokeMethod('canGoForward');
    }else{
      return await _channel.invokeMethod('canGoForward')=="false"?false:true;
    }

  }

  Widget buildAndroidWebView() {
    return AndroidView(
      //调用标识
      viewType: "com.flutter_to_native_webview",
      //参数初始化
      creationParams: {
        //调用view参数标识
        "isScrollListen": true,
        "htmlImageIsClick": htmlImageIsClick
      },
      //参数的编码方式
      creationParamsCodec: const StandardMessageCodec(),
      //webview 创建后的回调
      onPlatformViewCreated: (id) {
        viewId = id;
        print("onPlatformViewCreated " + id.toString());
        //创建通道
        _channel = new MethodChannel('com.flutter_to_native_webview_$viewId');
        //设置监听
        nativeMessageListener();
        //加载页面
        loadUrl();
      },
    );
  }

  Widget buildIosWebView() {
    return UiKitView(
      //调用标识
      viewType: "com.flutter_to_native_webview",
      //参数初始化
      creationParams: {
        //调用view参数标识
        "isScrollListen": true,
        "htmlImageIsClick": htmlImageIsClick
      },
      //参数的编码方式
      creationParamsCodec: const StandardMessageCodec(),
      //webview 创建后的回调
      onPlatformViewCreated: (id) {
        viewId = id;
        print("onPlatformViewCreated " + id.toString());
        //创建通道
        _channel = new MethodChannel('com.flutter_to_native_webview_$viewId');
        //设置监听
        nativeMessageListener();
        //加载页面
        loadUrl();
      },
    );
  }

  void refresh() {
    reLoad();
  }

  void loadJsMethod(String string) async {
    _channel.invokeMethod('jsload', {
      "string": string,
    });
  }
}
