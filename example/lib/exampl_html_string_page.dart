import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

///  加载 HTML 字符
class ExamplHtmlStringPage extends StatefulWidget {
  @override
  ExamplHtmlStringPageState createState() => ExamplHtmlStringPageState();
}

class ExamplHtmlStringPageState extends State<ExamplHtmlStringPage> {



  //原生 发送给 Flutter 的消息
  String message = "--";


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
      body: Container(child: buildHtmlWidget(),),
    );

  }

  String htmlData = "<!DOCTYPE html><html> <head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">  <meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1\"> </head> <body><p><br/></p><p>生物真题&nbsp;</p><p><img src=\"https://p3-tt.byteimg.com/origin/pgc-image/664f54d215a84cb0b0cb7c07a8a26caf?from=app\" title=\"\" alt=\"\"/></p><p><img src=\"http://pic.studyyoun.com/1543767100547\" title=\"\" alt=\"\"/></p><p><br/></p><p><br/></p><p><br/></p></body></html>";

  buildHtmlWidget() {
    return FaiWebViewWidget(
      //webview 加载网页链接
      htmlData: htmlData,
      //webview 加载信息回调
      callback: callBack,
      //输出日志
      isLog: true,
    );
  }
  callBack(int code, String msg, content) {
    //加载页面完成后 对页面重新测量的回调
    //这里没有使用到
    //当FaiWebViewWidget 被嵌套在可滑动的 widget 中，必须设置 FaiWebViewWidget 的高度
    //设置 FaiWebViewWidget 的高度 可通过在 FaiWebViewWidget 嵌套一层 Container 或者 SizeBox
    if (code == 201) {
      double webViewHeight = content;
      print("webViewHeight " + webViewHeight.toString());
    } else {
      //其他回调
    }
    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }


}
