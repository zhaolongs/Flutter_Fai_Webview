import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

/**
 *  加载 Html 标签
 *  嵌入 适配移动端的 默认样式
 *  实现 覆盖 Html 页面中的所有的图片添加点击事件
 */
class DefaultHtmlBlockImageClickPage extends StatefulWidget {
  @override
  DefaultHtmlBlockDataPageState createState() =>
      DefaultHtmlBlockDataPageState();
}

class DefaultHtmlBlockDataPageState
    extends State<DefaultHtmlBlockImageClickPage> {
  @override
  void initState() {
    super.initState();

    //使用插件 FaiWebViewWidget
    webViewWidget = FaiWebViewWidget(
      //webview 加载网页链接
      htmlBlockData: htmlBlockData,
      //图片添加点击事件
      htmlImageIsClick: true,
      //webview 加载信息回调
      callback: callBack,
      //图片信息的回调
      imageCallBack: imageCallBack,
      //输出日志
      isLog: true,
    );
  }

  FaiWebViewWidget webViewWidget;

  //原生 发送给 Flutter 的消息
  String message = "--";
  double webViewHeight = 100;

  //要显示的页面内容
  Widget childWidget;
  String htmlBlockData =
      "<!DOCTYPE html><html> <head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">  <meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1\"> </head> <body><p><br/></p><p>生物真题&nbsp;</p><p><img src=\"http://pic.studyyoun.com/1543767087584\" title=\"\" alt=\"\"/></p><p><img src=\"http://pic.studyyoun.com/1543767100547\" title=\"\" alt=\"\"/></p><p><br/></p><p><br/></p><p><br/></p> <script > function testAlert(){ console.log(\"console.log\"); alert(\"alert\")} </script> </body></html>";

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
      body: Stack(
        children: <Widget>[
          Container(
            child: webViewWidget,
          ),
          imageUrl != null
              ? Container(
                  color: Colors.grey,
                  padding: EdgeInsets.all(20),
                  child: Image.network(imageUrl),
                )
              : Container(),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(onPressed: () {
              webViewWidget.loadJsMethod("testAlert()");
              print("调用js 方法");
            },child: Text("JS",style: TextStyle(color: Colors.white),),),
          )
        ],
      ),
    );
  }

  String imageUrl = null;

  imageCallBack(int code, String url, List<String> images) {
    imageUrl = url;
    setState(() {});
  }

  callBack(int code, String msg, content) {
    //加载页面完成后 对页面重新测量的回调
    //这里没有使用到
    //当FaiWebViewWidget 被嵌套在可滑动的 widget 中，必须设置 FaiWebViewWidget 的高度
    //设置 FaiWebViewWidget 的高度 可通过在 FaiWebViewWidget 嵌套一层 Container 或者 SizeBox
    if (code == 201) {
      webViewHeight = content;
      print("webViewHeight " + webViewHeight.toString());
    } else if (code == 203) {
    } else {
      //其他回调
    }
    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }
}
