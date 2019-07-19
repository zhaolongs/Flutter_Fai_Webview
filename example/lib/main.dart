import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    childWidget = buildDefaultWidget();
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

  //要显示的页面内容
  Widget childWidget;
  String htmlUrl = "https://blog.csdn.net/zl18603543572";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
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
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                  child: Text("默认"),
                  value: "1",
                ),
                PopupMenuItem<String>(
                  child: Text("小窗口加载"),
                  value: "2",
                ),
                PopupMenuItem<String>(
                  child: Text("混合加载"),
                  value: "3",
                ),
                PopupMenuItem<String>(
                  child: Text("Stack 底部窗口加载"),
                  value: "4",
                ),
                PopupMenuItem<String>(
                  child: Text("Column 底部窗口加载"),
                  value: "5",
                ),
                PopupMenuItem<String>(
                  child: Text("下拉刷新加载"),
                  value: "6",
                ),
              ],
              onSelected: (String action) {
                switch (action) {
                  case "1":
                    childWidget = buildDefaultWidget();
                    break;
                  case "2":
                    childWidget = buildMinWidget();
                    break;
                  case "3":
                    childWidget = buildHexWidget();
                    break;
                  case "4":
                    childWidget = buildBottomWidget();
                    break;
                  case "5":
                    childWidget = buildColumnBottomWidget();
                    break;
                  case "6":
                    childWidget = buildRefreshHexWidget();
                    break;
                }

                setState(() {});
              },
              onCanceled: () {
                print("onCanceled");
              },
            )
          ],
        ),
        body: childWidget,
      ),
    );
  }

  Widget buildDefaultWidget() {
    return Stack(
      children: <Widget>[
        FaiWebViewWidget(
          url: htmlUrl,
          callback: callBack,
          isLog: true,
        ),
        Positioned(
          left: 20,
          top: 20,
          child: Container(
            alignment: Alignment(0, 0),
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Color.fromARGB(90, 0, 0, 0),
          ),
        ),
      ],
    );
  }

  callBack(int code, String msg, content) {
    //加载页面完成后 对页面重新测量的回调

    if (code == 201) {
      webViewHeight = content;
      print("webViewHeight "+webViewHeight.toString());
    } else {
      //其他回调
    }
    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }

  //小窗口加载
  Widget buildMinWidget() {
    return Stack(
      children: <Widget>[
        Container(
          height: 200,
          padding: EdgeInsets.only(left: 10, right: 10),
          color: Color.fromARGB(90, 0, 0, 0),
          child: FaiWebViewWidget(
            url: htmlUrl,
            callback: callBack,
            isLog: true,
          ),
        ),
      ],
    );
  }

  Widget buildBottomWidget() {
    return Stack(
      children: <Widget>[
        Align(
          child: Container(
            height: 200,
            alignment: Alignment(0, 1),
            padding: EdgeInsets.all(10),
            color: Color.fromARGB(90, 0, 0, 0),
            child: FaiWebViewWidget(
              url: htmlUrl,
              callback: callBack,
              isLog: true,
            ),
          ),
          alignment: Alignment(0, 1),
        )
      ],
    );
  }

  Widget buildColumnBottomWidget() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Container(
          height: 200,
          alignment: Alignment(0, 1),
          padding: EdgeInsets.all(10),
          color: Color.fromARGB(90, 0, 0, 0),
          child: FaiWebViewWidget(
            url: htmlUrl,
            callback: callBack,
            isLog: true,
          ),
        ),
      ],
    );
  }

  Widget buildHexWidget() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Text("这里是标题部分"),
            color: Colors.grey,
          ),
          Container(
            height: webViewHeight,
            padding: EdgeInsets.all(10),
            color: Color.fromARGB(90, 0, 0, 0),
            child: webViewWidget,
          ),
        ],
      ),
    );
  }

  Widget buildRefreshHexWidget() {
    print("build "+webViewHeight.toString());
    return RefreshIndicator(
      //下拉刷新触发方法
      onRefresh: _onRefresh,
      //设置listView
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              child: Text("这里是标题部分"),
              color: Colors.grey,
            ),
            Container(
              height: webViewHeight,
              padding: EdgeInsets.all(10),
              color: Color.fromARGB(90, 0, 0, 0),
              child: webViewWidget,
            ),
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
}
