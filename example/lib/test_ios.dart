import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 创建人： Created by zhaolong
 * 创建时间：Created by  on 2020/9/1.
 *
 * 可关注公众号：我的大前端生涯   获取最新技术分享
 * 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
 * 可关注博客：https://blog.csdn.net/zl18603543572
 */

import 'package:flutter_fai_webview/flutter_fai_webview.dart';
void main() => runApp(MaterialApp(
      home: DefaultUrlPage(),
    ));

class DefaultUrlPage extends StatefulWidget {
  @override
  MaxUrlRefreshState createState() => MaxUrlRefreshState();
}

class MaxUrlRefreshState extends State<DefaultUrlPage> {

  String message = 'message';

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

  FaiWebViewController _faiWebViewController = new FaiWebViewController();
  Widget buildRefreshHexWidget() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child:   FaiWebViewWidget(
        url: 'https://www.8jieke.com/',
        callback: callBack,
        controller: _faiWebViewController,
        isLog: false,
      ),
    );
  }

  Future<Null> _onRefresh() async {
    return await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      _faiWebViewController.refresh();
    });
  }

  callBack(int code, String msg, content) {
    //加载页面完成后 对页面重新测量的回调
    if (code == 201) {
      print("webViewHeight " + content.toString());
    } else {
      //其他回调
    }
    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }
}
