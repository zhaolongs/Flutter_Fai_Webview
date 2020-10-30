import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fai_webview/src/fai_webview_controller.dart';
import 'native_webview_event.dart';

/// 向 Flutter 中发送消息
/// code
/// 201 测量webview 成功
/// 202 JS调用
/// 203 图片点击回调
/// 301 滑动到顶部
/// 302 向下滑动
/// 303	向上滑动
/// 304 滑动到底部
/// 401 webview 开始加载
/// 402 webview 加载完成
/// 403 webview html中日志输出
/// 404 webview 加载出错
/// 501 webview 弹框回调
/// <p>
/// 1000 操作失败
///
/// @param map
/// code :203 图片点击回调
/// // url 当前点击图片的链接 index 当前点击Html页面中所有图片中的角标 urls 所有图片的集合
/// content: {"url":"http://pic.studyyoun.com/1543767087584","index":0,"urls":"http://pic.studyyoun.com/1543767087584,http://pic.studyyoun.com/1543767100547"}

class FaiWebViewWidget extends StatefulWidget {
  //加载的网页 URL
  final String url;

  //加载 完整html 文件数据 如 <html><head> .... .. </head></html>
  final String htmlData;

  //加载 html 代码块 如<p> .... </p>
  final String htmlBlockData;

  //日志输出
  final bool isLog;

  //HTML中的图片添加点击事件
  final bool htmlImageIsClick;

  ///下拉刷新回调
  final Function onRefresh;

  /// [code]  原生 Android iOS 回调 Flutter 的消息类型标识
  /// [message]  消息类型日志
  /// [content]  回调的基本数据
  final Function(int code, String message, dynamic content) callback;

  /// 图片点击回调
  ///[index] HTML 中图片索引
  /// [url] 当前点击的图片的地址
  /// [images] HTML中所有的图片的集合
  final Function(int index, String url, List<String> images) imageCallBack;

  ///操作webView的控制器
  final FaiWebViewController controller;

  final ScrollController scrollController;

  final Widget headerWidget;
  final Widget appBar;

  FaiWebViewWidget(
      {
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
      this.scrollController,
      this.headerWidget,
      this.onRefresh,
      this.appBar,
      this.showLoading = true,
      this.loadginWidget,
      Key key})
      : super(key: key);

  final bool showLoading;

  final Widget loadginWidget;

  @override
  State<StatefulWidget> createState() {
    return AndroidWebViewState();
  }
}

class AndroidWebViewState extends State<FaiWebViewWidget> {
  double webViewHeight = 40;

  ///滑动布局控制器
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: buildRefreshHexWidget(),
    );
  }

  double _dy = 0.0;

  findCurrentDy() {
    RenderBox findRenderObject = context.findRenderObject();
    if (findRenderObject != null) {
      Offset localOffset = findRenderObject.localToGlobal(Offset.zero);
      if (localOffset != null) {
        _dy = localOffset.dy;
      }
    }
  }

  /// 需要注意的是
  /// RefreshIndicator 会覆盖 WebView 的滑动事件
  /// 所有关于 监听 WebView 的滑动监听将会失效
  Widget buildRefreshHexWidget() {
    Widget itemWidget = SingleChildScrollView(
      controller: _scrollController,
      physics: _scrollPhysics,
      child: buildColumn(),
    );

    if (widget.onRefresh != null) {
      itemWidget = RefreshIndicator(
        //下拉刷新触发方法
        onRefresh: widget.onRefresh,
        //设置webViewWidget
        child: itemWidget,
      );
    }

    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        //滑动信息处理
        //根据不同的滑动信息来处理页面的特效
        //如Widget 移动 、放大、缩小、旋转等等
        notificationFunction(notification);
        //可滚动组件在滚动过程中会发出ScrollNotification之外，
        //还有一些其它的通知，
        //如SizeChangedLayoutNotification、
        //   KeepAliveNotification 、
        //   LayoutChangedNotification等
        //返回值类型为布尔值，当返回值为true时，阻止冒泡，
        //其父级Widget将再也收不到该通知；当返回值为false 时继续向上冒泡通知。
        return true;
      },
      child: itemWidget,
    );
  }

  notificationFunction(ScrollNotification notification) {
    //滑动信息的数据封装体
    ScrollMetrics metrics = notification.metrics;
    //当前位置
    double pixels = metrics.pixels;
    print("当前位置 $pixels");

    //滚动类型
    Type runtimeType = notification.runtimeType;

    switch (runtimeType) {
      case ScrollStartNotification:
        print("开始滚动");
        break;
      case ScrollUpdateNotification:
        print("正在滚动");
        break;
      case ScrollEndNotification:
        print("滚动停止");
        double offset = _scrollController.offset;
        if (offset == _scrollController.position.maxScrollExtent) {
          print("滚动停止  _scrollPhysics");
          _scrollPhysics = NeverScrollableScrollPhysics();
          setState(() {});
        }
        break;
      case OverscrollNotification:
        break;
    }
  }

  Widget buildColumn() {
    if (widget.headerWidget == null) {
      return buildContainer();
    } else {
      return Column(
        children: <Widget>[
          widget.headerWidget,
          buildContainer(),
        ],
      );
    }
  }

  Container buildContainer() {
    return Container(
      height: webViewHeight,
      child: Stack(
        children: [
          buildFaiWebViewItemWidget(),
          buildLoadingWidget(),
        ],
      ),
    );
  }

  Widget buildLoadingWidget() {
    if (widget.showLoading&&!isHideLoading) {
      if (widget.loadginWidget == null) {
        return Center(child: Text("加载中..."),);
      } else {
        return widget.loadginWidget;
      }
    } else {
      return Container();
    }
  }

  FaiWebViewItemWidget buildFaiWebViewItemWidget() {
    return FaiWebViewItemWidget(
      //webview 加载网页链接
      url: widget.url,
      htmlData: widget.htmlData,
      htmlBlockData: widget.htmlBlockData,
      htmlImageIsClick: widget.htmlImageIsClick,
      //webview 加载信息回调
      callback: callBack,
      //输出日志
      isLog: widget.isLog,
      controller: widget.controller,
    );
  }

  ScrollPhysics _scrollPhysics = ClampingScrollPhysics();

  ///是否需要滑动兼容处理
  bool isScrollHex = false;

  bool isHideLoading = false;

  callBack(int code, String msg, content) {
    //加载页面完成后 对页面重新测量的回调
    if (code == 201) {
      double widgetPerentHeight = MediaQuery.of(context).size.height * 3;
      findCurrentDy();
      double flagHeight = widgetPerentHeight - _dy;
      if (content <= widgetPerentHeight) {
        webViewHeight = content;
        isScrollHex = false;
      } else {
        webViewHeight = widgetPerentHeight;
        isScrollHex = true;
      }
      isHideLoading = true;
      //更新高度
      setState(() {});
      print("webViewHeight " + content.toString());
    } else if (code == 301 && widget.headerWidget != null) {
      print("_scrollPhysics 更新");
      //其他回调
      _scrollPhysics = ClampingScrollPhysics();
      setState(() {});
    }
    if (widget.callback != null) {
      widget.callback(code, msg, content);
    }
  }
}

@immutable
class FaiWebViewItemWidget extends StatefulWidget {
  //加载的网页 URL
  final String url;

  //加载 完整html 文件数据 如 <html><head> .... .. </head></html>
  final String htmlData;

  //加载 html 代码块 如<p> .... </p>
  final String htmlBlockData;

  //日志输出
  final bool isLog;

  //HTML中的图片添加点击事件
  final bool htmlImageIsClick;

  /// [code]  原生 Android iOS 回调 Flutter 的消息类型标识
  /// [message]  消息类型日志
  /// [content]  回调的基本数据
  final Function(int code, String message, dynamic content) callback;

  /// 图片点击回调
  ///[index] HTML 中图片索引
  /// [url] 当前点击的图片的地址
  /// [images] HTML中所有的图片的集合
  final Function(int index, String url, List<String> images) imageCallBack;

  ///操作webView的控制器
  final FaiWebViewController controller;

  FaiWebViewItemWidget({
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
    return FaiWebViewItemWidgetState(callback,
        url: url,
        htmlBlockData: htmlBlockData,
        isLog: isLog,
        htmlImageIsClick: htmlImageIsClick,
        imageCallBack: imageCallBack,
        htmlData: htmlData);
  }
}

class FaiWebViewItemWidgetState extends State<FaiWebViewItemWidget> {
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

  FaiWebViewItemWidgetState(this.callback,
      {this.url,
      this.htmlData,
      this.htmlBlockData,
      this.isLog,
      this.htmlImageIsClick = false,
      this.imageCallBack});

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller.setListener(webViewListener);
      widget.controller.setBackListener(webViewBackListener);
    }
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
      return Container(
        child: Text("暂不支持当前平台"),
      );
    }
  }

  Future<bool> webViewBackListener(int type, Map<String, dynamic> event) {
    if (type == 1) {
      return canGoBack();
    } else if (type == 2) {
      return canGoForward();
    } else {
      return Future.value(false);
    }
  }

  void webViewListener(type, event) {
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
  }

  @override
  void dispose() {
    super.dispose();
    // NativeEventMessage.getDefault().unregister();
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
      } else if (code == 201) {
        _streamController.add(1.0);
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
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('canGoBack');
    } else {
      return await _channel.invokeMethod('canGoBack') == "false" ? false : true;
    }
  }

  Future<bool> canGoForward() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('canGoForward');
    } else {
      return await _channel.invokeMethod('canGoForward') == "false"
          ? false
          : true;
    }
  }

  StreamController<double> _streamController = new StreamController();

  /// 监听Stream，每次值改变的时候，更新Text中的内容
  StreamBuilder<double> buildAndroidWebView() {
    return StreamBuilder<double>(
      ///绑定stream
      stream: _streamController.stream,

      ///默认的数据
      initialData: 0.0,

      ///构建绑定数据的UI
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        return buildStreamBuilder(snapshot.data);
      },
    );
  }

  Widget buildStreamBuilder(double data) {
    return Opacity(
      opacity: data,
      child: AndroidView(
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
          platformViewCreatedFunction(id);
        },
      ),
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
        platformViewCreatedFunction(id);
      },
    );
  }

  void platformViewCreatedFunction(int id) {
    viewId = id;
    print("onPlatformViewCreated " + id.toString());
    //创建通道
    _channel = new MethodChannel('com.flutter_to_native_webview_$viewId');
    //设置监听
    nativeMessageListener();
    //加载页面
    loadUrl();
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
