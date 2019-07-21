import 'package:flutter/material.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

/**
 *  加载地址
 *  通过 url 加载了一个 Html页面 是取常用的方法
 */
class DefaultLoadingWebViewUrlPage extends StatefulWidget {
  @override
  MaxUrlState createState() => MaxUrlState();
}

class MaxUrlState extends State<DefaultLoadingWebViewUrlPage> {

  //要显示的页面内容
  Widget childWidget;
  //加载Html的View
  FaiWebViewWidget webViewWidget;
  //原生 发送给 Flutter 的消息
  String message = "--";
  // 页面
  String htmlUrl = "https://blog.csdn.net/zl18603543572";

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
        body: Container(height: mWebViewHeight,child: webViewWidget,),
      );

  }

  double mWebViewHeight=100;
  void callBack(int code, String msg, content) {
    //加载页面完成后 对页面重新测量的回调
    //这里没有使用到
    //当FaiWebViewWidget 被嵌套在可滑动的 widget 中，必须设置 FaiWebViewWidget 的高度
    //设置 FaiWebViewWidget 的高度 可通过在 FaiWebViewWidget 嵌套一层 Container 或者 SizeBox
    if (code == 201) {
      //页面加载完成后 测量的 WebView 高度
      double webViewHeight = content;
      mWebViewHeight = webViewHeight;
      print("webViewHeight " + webViewHeight.toString());
    } else {
      //其他回调
    }
    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }
}
