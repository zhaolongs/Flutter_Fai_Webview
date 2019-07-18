# flutter_fai_webview

A new Flutter plugin.

## Getting Started

##### 1 pubspec.yaml 中引用



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