import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

///   混合页面加载
///   一般用于商品详情页面的添加
///   如这里的上半部分是 Flutter Widget 内容  下半部分是 WebView
class DefaultHexRefreshPage extends StatefulWidget {
  @override
  MaxUrlHexRefreshState createState() => MaxUrlHexRefreshState();
}

class MaxUrlHexRefreshState extends State<DefaultHexRefreshPage> {
  //原生 发送给 Flutter 的消息
  String message = "--";
  String htmlUrl = "https://blog.csdn.net/zl18603543572";
  double webViewHeight = 1;


  ///滑动布局控制器
  ScrollController _scrollController = new ScrollController();
  ///滚动标识
  int scrollFlag = 1;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 28,
          alignment: Alignment(0, 0),
          color: Color.fromARGB(90, 0, 0, 0),
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
      body: buildRefreshHexWidget(),
    );
  }

  GlobalKey _globalKey = GlobalKey();

  double _dy = 0.0;

  findCurrentDy() {
    RenderObject? findRenderObject = context.findRenderObject();
    if (findRenderObject != null) {
      Size size = findRenderObject.paintBounds.size;
      var vector = findRenderObject.getTransformTo(null).getTranslation();
      _dy= vector.y;
    }
  }

  /// 需要注意的是
  /// RefreshIndicator 会覆盖 WebView 的滑动事件
  /// 所有关于 监听 WebView 的滑动监听将会失效
  Widget buildRefreshHexWidget() {
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
      child: RefreshIndicator(
        //下拉刷新触发方法
        onRefresh: _onRefresh,
        //设置webViewWidget
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: _scrollPhysics,
          child: buildColumn(),
        ),
      ),
    );
  }
   notificationFunction(ScrollNotification notification) {

    //滑动信息的数据封装体
    ScrollMetrics metrics = notification.metrics;
    //当前位置
    double pixels = metrics.pixels;
    print("当前位置 $pixels");

    //滚动类型
    Type  runtimeType = notification.runtimeType;

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
          _scrollPhysics = NeverScrollableScrollPhysics();
          setState(() {});
        }
        break;
      case OverscrollNotification:

        break;
    }
  }

  Column buildColumn() {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey,
          height: 220.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text("这里是 Flutter widget  "),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment(0, 0),
          child: Text("以下是 Html 页面 "),
        ),
        Container(
          color: Colors.redAccent,
          height: 1.0,
        ),
        buildContainer(),
      ],
    );
  }

  Container buildContainer() {
    return Container(
      height: webViewHeight,
      child: FaiWebViewWidget(
        key: _globalKey,
        //webview 加载网页链接
        url: htmlUrl,
        //webview 加载信息回调
        callback: callBack,
        //输出日志
        isLog:false,
        scrollController: _scrollController,
      ),
    );
  }

  Future<Null> _onRefresh() async {
    return await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
    });
  }

  ScrollPhysics _scrollPhysics = ClampingScrollPhysics();

  callBack(int ?code, String ?msg, content) {
    //加载页面完成后 对页面重新测量的回调
    if (code == 201) {
      double widgetPerentHeight = MediaQuery.of(context).size.height;
      findCurrentDy();
      double flagHeight = widgetPerentHeight - _dy;

      if (content <= flagHeight) {
        webViewHeight = content;
      } else {
        webViewHeight = flagHeight;
      }
      //更新高度
      setState(() {});
      print("webViewHeight " + content.toString());
    } else if (code == 301) {
      //其他回调
      _scrollPhysics = ClampingScrollPhysics();
        setState(() {});
    }

    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }
}
