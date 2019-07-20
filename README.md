# flutter_fai_webview




[更多文章请查看 flutter从入门 到精通](https://blog.csdn.net/zl18603543572/article/details/93532582)


可以用来加载 Html 页面，以实现 Android 中 WebView 或者 是 iOS 中的 UIWebView 中的功能。

**Flutter中可用于来加载 Html 页面的插件 ,**

* flutter_WebView_plugin 
* webView_flutter
* flutter_inappbrowser 
* html 
* flutter_html 
* flutter_html_view 

这些多多少满足不了我项目中的需求，所以花了几天时间开发了 Flutter_Fai_Webview 插件，可实现   Android 中 WebView 或者 是 iOS 中的 UIWebView 中的功能，因为 Flutter_Fai_Webview 插件本质上是通过 PlatformView 功能将原生的 View 嵌套在 Flutter 中。

[插件源码在这里](https://github.com/zhaolongs/Flutter_Fai_Webview)

**开发插件要具备的知识：**

* Flutter 与 原生 Android iOS 双向通信 
 [Flutter通过MethodChannel实现Flutter 与Android iOS 的双向通信](https://blog.csdn.net/zl18603543572/article/details/96049359)
 [Flutter通过BasicMessageChannel实现Flutter 与Android iOS 的双向通信](https://blog.csdn.net/zl18603543572/article/details/96043692)
* Flutter 中内嵌 Android iOS 原生View的编程基础
	 [flutter调用android 原生TextView ](https://blog.csdn.net/zl18603543572/article/details/95983215)
	  [flutter调用ios 原生View ](https://blog.csdn.net/zl18603543572/article/details/96125516)
* 最重要的一点是 具备 Android  iOS 原生语言的开发能力


**Flutter_Fai_Webview 插件可实现的功能：**

* 同时适配于 Android  Ios 两个平台
* 通过  url 来加载渲染一个Html 页面
* 加载 Html 文本数据 如 ```<html> .... </html>```等
* 加载 Html 标签数据 如  ```<p> ... </p>   ```
* 实现 WebView 加载完成后，自动测量 WebView 的高度，并回调 Flutter
* 实现 WebView 加载完成监听
* 实现 WebView 上下滑动、滑动到顶部兼听、滑动到底部兼听并回调 Flutter
* 实现 兼听 WebView 输出日志并将日志回调 Flutter 
* 实现 为 Html 页面中所有的图片添加点击事件 并回调 Flutter 
* 实现 Html 中Js 调用 Flutter 页面功能
* 实现 Flutter 页面中 触发 Html 页面中 Js 方法


**本插件开发的过程将在这里详细论述**

也就是说在这里将教会你 开发一个 Flutter 插件。
[Flutter 加载 HTML 详细阐述（iOS 端实现）](https://gitbook.cn/gitchat/activity/5d2d6d01175a450263e9457d)
[Flutter 加载 HTML 详细阐述（Android 端实现）](https://gitbook.cn/gitchat/activity/5d2d6a5983bbb72e0eea4c28)


*** 

#### 开始使用

#### 1 基本使用说明
##### 1.1 Flutter 项目中 pubspec.xml 文件中 配置插件

```dart
  flutter_fai_webview:
    git:
      url: https://github.com/zhaolongs/Flutter_Fai_Webview.git
      ref: master
```

##### 1.2 在使用到 WebView 页面中 

引入头文件

```dart 
import 'package:flutter_fai_webview/flutter_fai_webview.dart';
```

##### 1.3 创建 WebView  组件

```dart 

    //使用插件 FaiWebViewWidget
    webViewWidget = FaiWebViewWidget(
      //webview 加载网页链接
      url: htmlUrl,
      //webview 加载信息回调
      callback: callBack,
      //输出日志
      isLog: true,
    );
    
```

##### 1.4 FaiWebViewWidget 构造参数说明

```dart
  FaiWebViewWidget({
    //webview 加载网页链接
    this.url,
    //webview 加载 完整的 html 文件数据  如 <html> .... </html>
    // 不完整的 html 文件数据 如 <p></p> 配置到此项，用此属性来加载，只会渲染 <p> ... </p> 中已有的样式 不会适配移动端显示
    this.htmlData,
    //webview 加载完整的 html 文件数据 或者是 不完整的 html 文件数据 如 <p></p>
    //不完整的 html 文件数据 如 <p></p> 配置到此项，会自动将不完整的 html 文件数据 添加 <html><head> .. </head> <body> 原来的内容 </body></html>,并适配移动端
    this.htmlBlockData,
    //输出 Log 日志功能
    this.isLog,
    // 为 Html 页面中所有的图片添加 点击事件 并通过回调 通知 Flutter 页面
    // 只有使用 htmlBlockData 属性加载的页面才会有此效果
    this.htmlImageIsClick = false,
    // Html 页面中图片点击回调
    this.imageCallBack,
    // Html 页面中所有的消息回调
    this.callback,
  });

```
##### 1.5  原生回调 Flutter 的 callback 以及 Html 页面中 图片 点击回调说明

```
  /**
   * code 原生 Android iOS 回调 Flutter 的消息类型标识
   * message 消息类型日志
   * content 回调的基本数据
   */
  Function(int code, String message, dynamic content) callback;
```

详细说明

```dart

  //当前点击的图片 URL
  String imageUrl = null;
  //是否显示浮动按钮
  bool isShowFloat = false;
  /**
   * code 当前点击图片的 位置
   * url 当前点击图片对应的 链接
   * images 当前 Html 页面中所有的图片集合
   */
  void imageCallBack(int code, String url, List<String> images) {
    imageUrl = url;
    setState(() {});
  }

  void callBack(int code, String msg, content) {
    String call = "回调 code:" +
        code.toString() +
        " msg:" +
        msg.toString() +
        " content:" +
        content.toString();
    if (code == 201) {
      //加载页面完成后 对页面重新测量的回调
      //这里没有使用到
      //当FaiWebViewWidget 被嵌套在可滑动的 widget 中，必须设置 FaiWebViewWidget 的高度
      //设置 FaiWebViewWidget 的高度 可通过在 FaiWebViewWidget 嵌套一层 Container 或者 SizeBox
      webViewHeight = content;
    } else if (code == 202) {
      // Html 页面中 Js 的回调
      // Html 页面中的开发需要使用 Js 调用  【 Android 中 使用 controll.otherJsMethodCall( json )】 【iOS中 直接调用 otherJsMethodCall( json ) 】
      // 在 Flutter 中解析 json 然后加载不同的功能
      String jsJson = content;
    } else if (code == 203) {
      // 为 Html 页面中的图片添加 点击事件后，点击图片会回调此方法
      // content 为当前点击图片的 地址
      // 实现更多功能 比如 一个 Html 页面中 有5张图片，点击放大查看并可右右滑动
      // 这个功能可以在 imageCallBack 回调中处理

    } else if (code == 301) {
      //当 WebView 滑动到顶部的回调
    } else if (code == 302) {
      //当 WebView 开始向下滑动时的回调
      //隐藏按钮
      isShowFloat = true;
    } else if (code == 303) {
      //当 WebView 开始向上滑动时的回调
      //显示按钮
      isShowFloat = false;
    } else if (code == 304) {
      //当 WebView 滑动到底部的回调
    } else if (code == 401) {
      //当 WebView 开始加载的回调
    } else if (code == 402) {
      //当 WebView 加载完成的回调
    } else if (code == 403) {
      // WebView 中 Html中日志输出回调
    } else if (code == 401) {
      // WebView 加载 Html 页面出错的回调
    } else if (code == 501) {
      // 当 Html 页面中有 Alert 弹框弹出时 回调消息

    } else if (code == 1000) {
      // 操作失败 例如 空指针异常 等等
    } else {
      //其他回调
    }
    setState(() {
      message = call;
    });
  }
```

##### 1.6 Flutter 刷新页面

```dart
//调用此方法 便可刷新（重新加载页面）
webViewWidget.refresh();
```

##### 1.7 Flutter 调用 JS 方法

```
//testAlert() 就是我们要调用的 Html 页面中 JS的方法
// testAlert() 可以自定义与 Html 中的 JS 开发约定
webViewWidget.loadJsMethod("testAlert()");
```

***


 ####  2 Flutter 加载页面 
 
##### 2.1  通过 url 加载 Html 页面
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019072015175190.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psMTg2MDM1NDM1NzI=,size_16,color_FFFFFF,t_70)

```dart
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
        body: webViewWidget,
      );

  }

  void callBack(int code, String msg, content) {
    //加载页面完成后 对页面重新测量的回调
    //这里没有使用到
    //当FaiWebViewWidget 被嵌套在可滑动的 widget 中，必须设置 FaiWebViewWidget 的高度
    //设置 FaiWebViewWidget 的高度 可通过在 FaiWebViewWidget 嵌套一层 Container 或者 SizeBox
    if (code == 201) {
      //页面加载完成后 测量的 WebView 高度
      int webViewHeight = content;
      print("webViewHeight " + webViewHeight.toString());
    } else {
      //其他回调
    }
    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }
}

```

2.2 通过 Html Data 加载 Html 页面
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019072015272538.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psMTg2MDM1NDM1NzI=,size_16,color_FFFFFF,t_70)
```
import 'package:flutter/material.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

/**
 *  通过 htmlBlockData 加载 Html 数据 并添加移动适配
 */
class DefaultHtmlBlockDataPage2 extends StatefulWidget {
  @override
  DefaultHtmlBlockDataPageState createState() =>
      DefaultHtmlBlockDataPageState();
}

class DefaultHtmlBlockDataPageState extends State<DefaultHtmlBlockDataPage2> {


  FaiWebViewWidget webViewWidget;
  //原生 发送给 Flutter 的消息
  String message = "--";
  double webViewHeight = 100;

  //要显示的页面内容
  Widget childWidget;
  String htmlBlockData = "<!DOCTYPE html><html> <head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">  <meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1\"> </head> <body><p><br/></p><p>生物真题&nbsp;</p><p><img src=\"http://pic.studyyoun.com/1543767087584\" title=\"\" alt=\"\"/></p><p><img src=\"http://pic.studyyoun.com/1543767100547\" title=\"\" alt=\"\"/></p><p><br/></p><p><br/></p><p><br/></p></body></html>";

  @override
  void initState() {
    super.initState();

    //使用插件 FaiWebViewWidget
    webViewWidget = FaiWebViewWidget(
      //webview 加载网页链接
      htmlBlockData: htmlBlockData,
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
      body: Container(child: webViewWidget,),
    );
  }

  callBack(int code, String msg, content) {
    //加载页面完成后 对页面重新测量的回调
    //这里没有使用到
    //当FaiWebViewWidget 被嵌套在可滑动的 widget 中，必须设置 FaiWebViewWidget 的高度
    //设置 FaiWebViewWidget 的高度 可通过在 FaiWebViewWidget 嵌套一层 Container 或者 SizeBox
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

```

##### 2.3 加载混合页面
也就是说 一个页面中，一部分是 Flutter Widget 一部分是 webview 加载。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190720154728780.gif)

```
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

```



