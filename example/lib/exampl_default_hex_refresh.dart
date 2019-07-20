import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

/**
 *   混合页面加载
 *
 */
class DefaultHexRefreshPage extends StatefulWidget {
  @override
  MaxUrlHexRefreshState createState() => MaxUrlHexRefreshState();
}

class MaxUrlHexRefreshState extends State<DefaultHexRefreshPage> {
  FaiWebViewWidget webViewWidget;

  //原生 发送给 Flutter 的消息
  String message = "--";
  String htmlUrl = "https://blog.csdn.net/zl18603543572";
  double webViewHeight = 1;

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

  /**
   * 需要注意的是
   * RefreshIndicator 会覆盖 WebView 的滑动事件
   * 所有关于 监听 WebView 的滑动监听将会失效
   */
  Widget buildRefreshHexWidget() {

    return RefreshIndicator(
      //下拉刷新触发方法
      onRefresh: _onRefresh,
      //设置webViewWidget
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey,
              height: 220.0,
              child: Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
                  Center(child: Text("这里是 Flutter widget  "),)
              ],),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Text("以下是 Html 页面 "),
            ),
            Container(
              color: Colors.redAccent,
              height: 1.0,
            ),
            Container(
              height: webViewHeight,
              child: webViewWidget,
            )
          ],
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
      //更新高度
      webViewHeight = content;
      print("webViewHeight " + content.toString());
    } else {
      //其他回调
    }
    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }
}
