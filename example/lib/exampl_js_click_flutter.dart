import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

///  JS 与 Flutter的双向互调
class JSandFlutterUsePage extends StatefulWidget {
  @override
  DefaultHtmlBlockDataPageState createState() =>
      DefaultHtmlBlockDataPageState();
}

class DefaultHtmlBlockDataPageState extends State<JSandFlutterUsePage> {
  //原生 发送给 Flutter 的消息
  String message = "--";

  //要显示的页面内容
  Widget childWidget;
  String htmlBlockData =
      "<!DOCTYPE html><html> <head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">  <meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1\"> </head> <body><p>加载中</p></body></html>";

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
      body: Container(
        width: MediaQuery.of(context).size.width,

        ///使用异步来加载
        child: Stack(children: [
          buildFutureBuilder(),
          Positioned(
            bottom: 10,
            child: Wrap(
              children: [
                RaisedButton(
                  child: Text("重新加载页面"),
                  onPressed: () {
                    faiWebViewController.refresh();
                  },
                ),
                RaisedButton(
                  child: Text("Flutter调用JS方法"),
                  onPressed: () {
                    ///向JS方法中传的参数
                    Map<String, dynamic> map = new Map();
                    map["test"] = "这是Flutter中传的参数";

                    ///参数一为调用JS的方法名称
                    ///参数二为向JS中传递的参数
                    faiWebViewController.toJsFunction(
                        jsMethodName: "testAlert2", parameterMap: map);
                  },
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  ///异步加载静态资源目录下的Html
  FutureBuilder<String> buildFutureBuilder() {
    return FutureBuilder<String>(
      ///异步加载数据
      future: loadingLocalAsset(),

      ///构建
      builder: (BuildContext context, var snap) {
        ///加载完成的html数据
        String htmlData = snap.data;
        //使用插件 FaiWebViewWidget
        if (htmlData == null) {
          return CircularProgressIndicator();
        }

        ///通过配置 htmlBlockData 来渲染
        return buildFaiWebViewWidget(htmlData);
      },
    );
  }

  ///webView控制器
  FaiWebViewController faiWebViewController = new FaiWebViewController();
  ///构建webview组件
  FaiWebViewWidget buildFaiWebViewWidget(String htmlData) {
    return FaiWebViewWidget(
      controller: faiWebViewController,
      //webview 加载本地html数据
      htmlBlockData: htmlData,
      //webview 加载信息回调
      callback: callBack,
      //输出日志
      isLog: true,
    );
  }


  ///FaiWebViewWidget 的回调处理
  callBack(int code, String msg, content) {

    if (code == 202) {
      /// json.encode(mapData); //Map转化JSON字符串
      /// json.decode(strData); //JSON 字符串转化为Map类型
      Map<String, dynamic> map = json.decode(content);

      String name = map["name"];
      int age = map["age"];
      print('这里是Js调用到Flutter中的数据 name $name  age $age');
    } else {
      //其他回调
    }
    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }

  ///读取静态Html
  Future<String> loadingLocalAsset() async {
    ///加载
    String htmlData = await rootBundle.loadString('assets/html/test.html');
    print("加载数据完成 $htmlData");
    return htmlData;
  }
}
