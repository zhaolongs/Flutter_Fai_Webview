import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

///   混合页面加载
///   一般用于商品详情页面的添加
///   如这里的上半部分是 Flutter Widget 内容  下半部分是 WebView
class DefaultHexRefreshPage2 extends StatefulWidget {
  @override
  MaxUrlHexRefreshState createState() => MaxUrlHexRefreshState();
}

class MaxUrlHexRefreshState extends State<DefaultHexRefreshPage2> {

  String htmlUrl = "https://blog.csdn.net/zl18603543572";

  //原生 发送给 Flutter 的消息
  String message = "--";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///标题
      appBar: buildAppBar(context),
      ///页面主体
      body: buildFaiWebViewWidget(),
    );
  }

  ///标题部分
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

  /// WebView 部分
  Container buildFaiWebViewWidget() {
    return Container(
      child: FaiWebViewWidget(
        ///下拉刷新
        onRefresh: _onRefresh,
        //头
        headerWidget: buildHeaderWidget(),
        //webview 加载网页链接
        url: htmlUrl,
        //webview 加载信息回调
        callback: callBack,
        //输出日志
        isLog: false,
      ),
    );
  }

  List<String> imageList = [
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1603893462481&di=d4c8e6e88762f5a65aec40c02dd8a93b&imgtype=0&src=http%3A%2F%2Fattachments.gfan.com%2Fforum%2Fattachments2%2Fday_110320%2F11032021067b907d3ed754dd93.jpg",
    "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1603365312,3218205429&fm=26&gp=0.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1603893511117&di=661e0441ef2e37676944b61714dc66d5&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fd1a20cf431adcbefe30c97d9aeaf2edda3cc9f31.jpg"
  ];

  ///可滑动的 视图
  ///在 WebView 上方
  Widget buildHeaderWidget() {
    return  Container(
      height: 200.0,
      // child: buildSwiper(),
      child: buildImage(0),
    );
  }

  Swiper buildSwiper() {
    return new Swiper(
      // 横向
      scrollDirection: Axis.horizontal,
      // 布局构建
      itemBuilder: (BuildContext context, int index) {
        return buildImage(index);
      },
      //条目个数
      itemCount: imageList.length,
      // 自动翻页
      autoplay: true,
      //点击事件
      onTap: (index) {
        print(" 点击 " + index.toString());
      },
      // 相邻子条目视窗比例
      viewportFraction: 1,
      // 布局方式
      //layout: SwiperLayout.STACK,
      // 用户进行操作时停止自动翻页
      autoplayDisableOnInteraction: true,
      // 无线轮播
      loop: true,
      //当前条目的缩放比例
      scale: 1,
    );
  }

  Image buildImage(int index) {
    return new Image.network(
        imageList[index],
        fit: BoxFit.fill,
      );
  }

  ///如果你需要的话就使用
  Future<Null> _onRefresh() async {
    return await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
    });
  }

  callBack(int code, String msg, content) {
    //加载页面完成后 对页面重新测量的回调
    setState(() {
      message =
          "1.1.4 回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }
}
