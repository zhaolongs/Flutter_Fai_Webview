import 'package:flutter/material.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

///  加载地址
///  通过 url 加载了一个 Html页面 是取常用的方法
class DefaultLoadingWebViewUrlPage extends StatefulWidget {
  @override
  MaxUrlState createState() => MaxUrlState();
}

class MaxUrlState extends State<DefaultLoadingWebViewUrlPage> {
  //加载Html的View
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
        title: buildTitleContainer(),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: buildFaiWebViewWidget(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Row(
              children: [
                FloatingActionButton(
                  heroTag: "q2",
                  child: Icon(Icons.arrow_left),
                  onPressed: () async {
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
                  },
                ),
                SizedBox(
                  width: 44,
                ),
                FloatingActionButton(
                  heroTag: "q",
                  child: Icon(Icons.arrow_right),
                  onPressed: () async {
                    ///判断是否可退 如果可退
                    bool forword = await _faiWebViewController.canForword();
                    print("是否可前进$forword");
                    if (forword) {
                      /// 如果可退 后退浏览器的历史
                      _faiWebViewController.forword();
                    } else {}
                  },
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
        },
        child: Icon(Icons.backspace),
      ),
    );
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
      //输出日志
      isLog: true,
      controller: _faiWebViewController,
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
}
