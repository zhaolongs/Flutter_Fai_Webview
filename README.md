# flutter_fai_webview


**题记**
  ——  执剑天涯，从你的点滴积累开始，所及之处，必精益求精，即是折腾每一天。
  
**重要消息**

* [网易云【玩转大前端】配套课程](https://study.163.com/instructor/1021406098.htm)
* [EDU配套  教程](https://edu.csdn.net/lecturer/1555)

* [Flutter开发的点滴积累系列文章](https://blog.csdn.net/zl18603543572/article/details/93532582)

***


> 本篇文章讲述的内容可以用来加载 Html 页面，以实现 Android 中 WebView 或者 是 iOS 中的 UIWebView 中的功能。


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
*  实现Html与Flutter的JS双向互调
* 实现打开相机相册的功能
* 实现回退历史浏览记录的功能
* 实现监听Html中图片的点击事件回调
* 刷新Html页面的加载

***

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



**本插件开发的过程将在这里详细论述**

也就是说在这里将教会你 开发一个 Flutter 插件。
[Flutter 加载 HTML 详细阐述（iOS 端实现）](https://gitbook.cn/gitchat/activity/5d2d6d01175a450263e9457d)
[Flutter 加载 HTML 详细阐述（Android 端实现）](https://gitbook.cn/gitchat/activity/5d2d6a5983bbb72e0eea4c28)


*** 

#### 开始使用

#### 1 基本使用说明
##### 1.1 Flutter 项目中 pubspec.xml 文件中 配置插件

pub方式依赖：[点击这里查看最新版本](https://pub.flutter-io.cn/packages/flutter_fai_webview)

```java
dependencies:
  flutter_fai_webview: ^1.0.0
```

git方式依赖：
```dart
  flutter_fai_webview:
    git:
      url: https://github.com/zhaolongs/Flutter_Fai_Webview.git
      ref: master
```

```java
dependencies:
  flutter_fai_webview: ^0.0.2
```

##### 1.2 在使用到 WebView 页面中 

引入头文件

```dart 
import 'package:flutter_fai_webview/flutter_fai_webview.dart';
```

##### 1.3 通过url加载网页
如这里使用到的地址：

```java
  String htmlUrl = "https://blog.csdn.net/zl18603543572";
```
然后使用FaiWebViewWidget来加载显示这个h5链接，代码如下：


```java 

  ///通过url加载页面
  FaiWebViewWidget buildFaiWebViewWidget() {
    return FaiWebViewWidget(
      //webview 加载网页链接
      url: htmlUrl,
      //webview 加载信息回调
      callback: callBack,
      //输出日志
      isLog: true,
    );
  }
```
其中callBack是一个回调，如webview的加载完成、向上滑动、向下滑动等等，代码如下：

```java
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
```
运行效果如下图所示：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200714211841289.gif)
[完整代码在这里](https://github.com/zhaolongs/Flutter_Fai_Webview/blob/master/example/lib/exampl_default_url_max.dart)
##### 1.4 关于回调中的code取值说明如下
  
   * 201 测量webview 成功
   * 202 JS调用
   * 203 图片点击回调
   * 301 滑动到顶部
   * 302 向下滑动
   * 303	向上滑动
   * 304 滑动到底部
   * 401 webview 开始加载
   * 402 webview 加载完成
   * 403 webview html中日志输出
   * 404 webview 加载出错
   * 501 webview 弹框回调

   * 1000 操作失败

加载Html的过程中会实时回调Flutter，详细说明如下：
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

***
![公众号 我的大前端生涯](https://img-blog.csdnimg.cn/20200620175409480.gif)
***

 ####  2 Flutter 加载页面 
 
##### 2.1  通过 url 加载 Html 页面
在上述1.3 通过url加载网页已进行过描述

##### 2.2 通过 Html Data 加载 String类型的Html 页面
加载String类型的Html页面，一般先是将String类型的Html代码加载到内容中，如通过网络请求接口获取的，或者是在页面中定义好的代码如下:

```java
 String htmlBlockData =
      "<!DOCTYPE html><html> <head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">  <meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1\"> </head> <body><p>加载中</p></body></html>";

```

或者是放在assets目录的静态Html，那么就需要先读取静态资源目录下的Html文件 ，代码如下：

```java
  ///读取静态Html
  Future<String> loadingLocalAsset() async {
    ///加载
    String htmlData = await rootBundle.loadString('assets/html/test.html');
    print("加载数据完成 $htmlData");
    return htmlData;
  }
```
当然你需要配制好目录依赖，如我这里的example中的html文件配置代码如下：

```java
  assets:
    - assets/html/
```
对应的文件目录如下所示：
![](https://img-blog.csdnimg.cn/20200714213210344.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psMTg2MDM1NDM1NzI=,size_16,color_FFFFFF,t_70)
然后就是使用FaiWebViewWidget来渲染Html页面了，如果是直接显示已加载好的String类型的Html，那么直接配置FaiWebViewWidget中的htmlBlockData就可以，如果是使用异步加载assets目录下的静态Html，那么可以结合FutureBuilder组件来实现加载，代码如下：

```java
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
        return FaiWebViewWidget(
          //webview 加载本地html数据
          htmlBlockData: htmlData,
          //webview 加载信息回调
          callback: callBack,
          //输出日志
          isLog: true,
        );
      },
    );
  }
```
[对应的完整代码在这里](https://github.com/zhaolongs/Flutter_Fai_Webview/blob/master/example/lib/exampl_default_html_data_max_refresh2.dart)

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

#### 3 Flutter与Html中JS的双向互调
在这里使用到的Html页面代码如下：

```html
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
</head>
<body><p><br/></p>
<p>测试一下 &nbsp;</p>
<p><img src="https://images.gitee.com/uploads/images/2020/0602/203000_9fa3ddaa_568055.png"
        title="" alt=""/></p>
<p><img src="https://images.gitee.com/uploads/images/2020/0602/203000_9fa3ddaa_568055.png"
        title="" alt=""/></p>
<p id="flutter"><br/></p>

<button type="button" onclick="toFlutter()">调用 Flutter中的内容</button>
<p><br/></p>
<p><br/></p>

<script>

  //Flutter调用的 JS方法
  //这里传回的参数是 JSON 格式
  //获取具体的参数内容 可以将 JSON文本转 对象或者是数组
  function testAlert2(value) {

    console.log(' 这里是JS 的方法 传的参数是  ' + value);
    ///交Json文本转对象
    var obj = JSON.parse(value);
    console.log(' 解析字符串的数据  ' + obj.test);
    ///在HTML中p标签中输入传过来的cdvo
    document.getElementById('flutter').innerHTML = obj.test;
  }


  //JS调用Flutter中的方法
  function toFlutter() {

    ///向Flutter传递的参数
    var obj = Object();
    obj.name = '张三';
    obj.age = 10;
    var json = JSON.stringify(obj);

    ///根据不同的手机加载不同的方法
    var sys = checkSystem();
    if (sys === 'ios') {
      controll.otherJsMethodCall(json);
    } else {
      otherJsMethodCall(json);
    }
  }

  //判断是安卓还是IOS
  function checkSystem() {
    var u = window.navigator.userAgent, app = window.navigator.appVersion;
    var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Linux') > -1; //g
    var isIOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端
    if (isAndroid) {
      return 'android';
    }
    if (isIOS) {
      return 'ios';
    }
  }


</script>

</body>
</html>

```

#### 3.1 Flutter中调用JS中的方法
Flutter中调用JS方法，需要使用到FaiWebViewController，代码如下：

```java
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
```

然后在点击按钮的时候调用HTML中JS的方法，代码如下：

```java
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
```
这里使用到的testAlert2就是JS中声明的方法

#### 3.2 JS中调用Flutter的方法
在上述描述到的Html文件中，声明了一个按钮，然后在点击按钮时调用 toFlutter方法，然后在Flutter中对应的FaiWebViewWidget设置的callback监听中会收到这个回调，处理代码如下：

```java
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
```
然后在这里接收到JS中的调用以及参数后，就可以在Flutter中做任何想要的操作

> 在正个过程中参数数据是通过json格式的数据来传递的，在实际项目开发中需要保持json的一至

*** 
#### 4 Flutter操作Html的其他方法简述
##### 4.1 刷新页面加载
通过 FaiWebViewController的 refresh方法就可实现，代码如下：

```java
 faiWebViewController.refresh();
```

*** 
完结

![公众号 我的大前端生涯](https://img-blog.csdnimg.cn/20200620175409480.gif)






