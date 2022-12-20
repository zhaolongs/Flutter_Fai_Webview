import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

///  加载 Html 标签
///  嵌入 适配移动端的 默认样式
///  实现 覆盖 Html 页面中的所有的图片添加点击事件
class DefaultHtmlVideoPage extends StatefulWidget {
  @override
  DefaultHtmlBlockDataPageState createState() =>
      DefaultHtmlBlockDataPageState();
}

class DefaultHtmlBlockDataPageState extends State<DefaultHtmlVideoPage> {
  //原生 发送给 Flutter 的消息
  String message = "--";
  double webViewHeight = 100;

  String url =
      "http://192.168.1.107:7073/learncoal/h5/news/video/details/249.html";

  //要显示的页面内容
  Widget? childWidget;
  String htmlBlockData =
      "<iframe src='https://player.bilibili.com/player.html?aid=511854345&bvid=BV1Mg411o7Bs&cid=725857961&page=1' scrolling='no' border='0' frameborder='no' framespacing='0' allowfullscreen='true'> </iframe>";
  bool _isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        onPressed: () {
          if (_isFullScreen) {
            _isFullScreen = false;
            // 强制竖屏
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
          } else {
            _isFullScreen = true;
            // 强制横屏
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight
            ]);
          }
          refreshHtmlPage();
          setState(() {});
        },
      ),
      appBar: _isFullScreen
          ? null
          : AppBar(
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
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FaiWebViewWidget(
              webViewHeight:
                  _isFullScreen ? MediaQuery.of(context).size.height : 240,
              controller: faiWebViewController,
              //webview 加载网页链接
              url: url,
              // htmlBlockData: htmlBlockData,
              //图片添加点击事件
              htmlImageIsClick: false,
              //webview 加载信息回调
              callback: callBack,
              //图片信息的回调
              imageCallBack: imageCallBack,
              //输出日志
              isLog: true,
            ),
          ),
          imageUrl != null
              ? Container(
                  color: Colors.grey,
                  padding: EdgeInsets.all(20),
                  child: Image.network(imageUrl!),
                )
              : Container(),
          isShowFloat
              ? Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      print("调用js 方法");
                    },
                    child: Text(
                      "JS",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  FaiWebViewController faiWebViewController = new FaiWebViewController();

  void refreshHtmlPage() {
    Future.delayed(
        Duration(
          seconds: 1,
        ), () {
      ///向JS方法中传的参数
      Map<String, dynamic> map = new Map();
      map["test"] = "这是Flutter中传的参数33333";

      ///参数一为调用JS的方法名称
      ///参数二为向JS中传递的参数
      faiWebViewController.toJsFunction(
          jsMethodName: "updateVideoWidth", parameterMap: map);
    });
  }

  //当前点击的图片 URL
  String? imageUrl = null;

  //是否显示浮动按钮
  bool isShowFloat = false;

  /**
   * code 当前点击图片的 位置
   * url 当前点击图片对应的 链接
   * images 当前 Html 页面中所有的图片集合
   */
  void imageCallBack(int code, String url, List<String> images) {
    imageUrl = url;
    setState(() {});
  }

  void callBack(int? code, String? msg, content) {
    String call = "回调 code:" +
        code.toString() +
        " msg:" +
        msg.toString() +
        " content:" +
        content.toString();
    if (code == 201) {
      //加载页面完成后 对页面重新测量的回调
      //这里没有使用到
      //当FaiWebViewWidget 被嵌套在可滑动的 widget 中，必须设置 FaiWebViewWidget 的高度
      //设置 FaiWebViewWidget 的高度 可通过在 FaiWebViewWidget 嵌套一层 Container 或者 SizeBox
      webViewHeight = content;
    } else if (code == 202) {
      // Html 页面中 Js 的回调
      // Html 页面中的开发需要使用 Js 调用
      // 【 Android 中 使用 controll.otherJsMethodCall( json )】
      // 【iOS中 直接调用 otherJsMethodCall( json ) 】
      // 在 Flutter 中解析 json 然后加载不同的功能
      String jsJson = content;
    } else if (code == 203) {
      // 为 Html 页面中的图片添加 点击事件后，点击图片会回调此方法
      // content 为当前点击图片的 地址
      // 实现更多功能 比如 一个 Html 页面中 有5张图片，点击放大查看并可右右滑动
      // 这个功能可以在 imageCallBack 回调中处理

    } else if (code == 301) {
      //当 WebView 滑动到顶部的回调
    } else if (code == 302) {
      //当 WebView 开始向下滑动时的回调
      //隐藏按钮
      isShowFloat = true;
    } else if (code == 303) {
      //当 WebView 开始向上滑动时的回调
      //显示按钮
      isShowFloat = false;
    } else if (code == 304) {
      //当 WebView 滑动到底部的回调
    } else if (code == 401) {
      //当 WebView 开始加载的回调
    } else if (code == 402) {
      //当 WebView 加载完成的回调
    } else if (code == 403) {
      // WebView 中 Html中日志输出回调
    } else if (code == 401) {
      // WebView 加载 Html 页面出错的回调
    } else if (code == 501) {
      // 当 Html 页面中有 Alert 弹框弹出时 回调消息

    } else if (code == 1000) {
      // 操作失败 例如 空指针异常 等等
    } else {
      //其他回调
    }
    setState(() {
      message = call;
    });
  }

  @override
  void dispose() {
    // 强制竖屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }
}
