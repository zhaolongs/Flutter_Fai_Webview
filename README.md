# flutter_fai_webview

 Flutter plugin.
 
 在 Flutter 中加载 Html 的插件，实现 Flutter 中内嵌 Android ios 原生 webView 功能
 
 可监听 webview 的滑动状态 以及实现 与 Html 的JS 交互 功能
 
 视频效果可查看 https://github.com/zhaolongs/Flutter_Fai_Webview/blob/master/video/6624F96E776F82976BA800BD7D0C5632.mp4


## Getting Started

##### 1 pubspec.yaml 中引用

```
  flutter_fai_webview:
    git:
      url: https://github.com/zhaolongs/Flutter_Fai_Webview.git
      ref: master
```

##### 2 引入 

```

import 'package:flutter_fai_webview/flutter_fai_webview.dart';

```

##### 3 创建 webview 插件

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

##### 4 callBack 回调设置说明


```java
	/**
	 * 向 Flutter 中发送消息
	 * code
	 * 201 测量webview 成功
	 * 202 JS调用
	 * 301 滑动到顶部
	 * 302 向下滑动
	 * 303	向上滑动
	 * 304 滑动到底部
	 * 401 webview 开始加载
	 * 402 webview 加载完成
	 * 403 webview html中日志输出
	 * 404 webview 加载出错
	 *
	 * @param map
	 */
```

```dart

  callBack(int code, String msg, content) {
    //加载页面完成后 对页面重新测量的回调
    if (code == 201) {
      webViewHeight = content;
    }else{
      //其他回调
    }
    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }
```
