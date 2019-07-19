import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

/**
 *  满屏加载地址 可下拉刷新
 */
class DefaultMaxUrlRefreshPage extends StatefulWidget {
  @override
  MaxUrlRefreshState createState() => MaxUrlRefreshState();
}

class MaxUrlRefreshState extends State<DefaultMaxUrlRefreshPage> {
  @override
  void initState() {
    super.initState();

    //使用插件 FaiWebViewWidget
    webViewWidget = FaiWebViewWidget(
      //webview 加载网页链接
      url: htmlUrl,
      //webview 加载信息回调
      callback: callBack,
      //输出日志
      isLog: true,
    );
  }

  FaiWebViewWidget webViewWidget;

  //原生 发送给 Flutter 的消息
  String message = "--";
  double webViewHeight = 100;
  String htmlUrl = "https://blog.csdn.net/zl18603543572";

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

  Widget buildRefreshHexWidget() {
    print("build " + webViewHeight.toString());
    return RefreshIndicator(
      //下拉刷新触发方法
      onRefresh: _onRefresh,
      //设置listView
      child: SingleChildScrollView(
        child: Container(
          height: webViewHeight,
          color: Color.fromARGB(90, 0, 0, 0),
          child: webViewWidget,
        ),
      ),
    );
  }

  Future<Null> _onRefresh() async {
    return await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      webViewWidget.refresh();
    });
  }

  callBack(int code, String msg, content) {
    //加载页面完成后 对页面重新测量的回调

    if (code == 201) {
      webViewHeight = content;
      print("webViewHeight " + webViewHeight.toString());
    } else {
      //其他回调
    }
    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }
}
