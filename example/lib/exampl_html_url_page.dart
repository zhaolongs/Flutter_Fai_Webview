import 'package:flutter/material.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

///  加载地址
///  通过 url 加载了一个 Html页面 是取常用的方法
class ExamplHtmlUrlPage extends StatefulWidget {
  @override
  MaxUrlState createState() => MaxUrlState();
}

class MaxUrlState extends State<ExamplHtmlUrlPage> {
  //加载Html的View
  //原生 发送给 Flutter 的消息
  String message = "--";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("加载一个 HTML 链接"),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: buildFaiWebViewWidget(),
          ),
          Positioned(
            width: 60,
            right: 10,
            bottom: 60,
            child: buildBottomControllerButtons(context),
          )
        ],
      ),

    );
  }

  ///构建底部的操作按钮区域
  Column buildBottomControllerButtons(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: "q2",
          child: Icon(Icons.arrow_left),
          onPressed: () async {
            ///判断是否可退 如果可退
            await leftBackFunction(context);
          },
        ),
        SizedBox(
          height: 22,
        ),
        FloatingActionButton(
          heroTag: "q",
          child: Icon(Icons.arrow_right),
          onPressed: () async {
            ///判断是否可前进
            await rightForwordFunction();
          },
        ),
        SizedBox(
          height: 22,
        ),
        FloatingActionButton(
          heroTag: "se",
          child: Icon(Icons.refresh),
          onPressed: () async {
            ///刷新当前
            _faiWebViewController.refresh();
          },
        ),
        SizedBox(
          height: 22,
        ),
        FloatingActionButton(
          onPressed: () async {
            ///判断是否可退 如果可退
            await leftBackFunction(context);
          },
          child: Icon(Icons.backspace),
        )
      ],
    );
  }

  ///前进功能
  Future rightForwordFunction() async {
    ///判断是否可前进
    bool forword = await _faiWebViewController.canForword();
    print("是否可前进$forword");
    if (forword) {
      /// 如果可退 后退浏览器的历史
      _faiWebViewController.forword();
    } else {
      ///将按钮隐藏或者置灰等操作
    }
  }

  ///判断是否可退 如果可退 调用浏览器的后退功能
  ///如果不可后退 就退出当前 Widget 页面
  Future leftBackFunction(BuildContext context) async {
    ///判断是否可退 如果可退
    bool back = await _faiWebViewController.canBack();
    print("是否可后退 $back");
    if (back) {
      /// 如果可退 后退浏览器的历史
      _faiWebViewController.back();
    } else {
      ///如果不可就退出当前页面
      Navigator.of(context).pop();
    }
  }

  FaiWebViewController _faiWebViewController = new FaiWebViewController();

  ///消息头的widget
  Container buildTitleContainer() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 28,
      alignment: Alignment(0, 0),
      color: Color.fromARGB(90, 0, 0, 0),
      child: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  // 页面
  String htmlUrl = "https://blog.csdn.net/zl18603543572";

  ///通过url加载页面
  FaiWebViewWidget buildFaiWebViewWidget() {
    return FaiWebViewWidget(
      //webview 加载网页链接
      url: htmlUrl,
      //webview 加载信息回调
      callback: callBack,
      //图片回调
      imageCallBack:imageClickBackFunction,
      //控制器
      controller: _faiWebViewController,
      //输出日志
      isLog: true,
      //HTML中的图片添加点击事件
      htmlImageIsClick: true,
    );
  }

  ///加载 Html 的回调
  ///[code]消息类型标识
  ///[msg] 消息内容
  ///[content] 回传的参数
  void callBack(int code, String msg, content) {
    //加载页面完成后 对页面重新测量的回调
    //这里没有使用到
    //当FaiWebViewWidget 被嵌套在可滑动的 widget 中，必须设置 FaiWebViewWidget 的高度
    //设置 FaiWebViewWidget 的高度 可通过在 FaiWebViewWidget 嵌套一层 Container 或者 SizeBox
    if (code == 201) {
      //页面加载完成后 测量的 WebView 高度
      double webViewHeight = content;
      print("webViewHeight " + webViewHeight.toString());
    } else {
      //其他回调
    }
    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }

  ///图片点击事件回调
  void imageClickBackFunction(int index, String url, List<String> images){

    print("图片回调-------------------------");
    print("|image url  $url ");
    print("|index $index images length ${images.length}");
  }
}
