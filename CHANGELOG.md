
## 1.1.6 

* 新增 WebView 添加 脚视图的功能
* 新增自定义webView高度的功能

```
Container buildFaiWebViewWidget() {
  return Container(
    child: FaiWebViewWidget(
      ///下拉刷新
      onRefresh: _onRefresh,
      //头
      headerWidget: buildHeaderWidget(),
      //脚
      footerWidget: buildHeaderWidget(),
      //WebView的高度
      //webViewHeight: 400,
      //webview 加载网页链接
      url: htmlUrl,
      //webview 加载信息回调
      callback: callBack,
      //输出日志
      isLog: false,
    ),
  );
}

```
## 1.1.5

 * 添加 加载中显示文案
 * 兼容部分机型有底部虚拟菜单栏无法监听回调问题
 * 优化 ScrollView 与 WebView 的兼容显示

## 1.1.4

 * 添加 Scrollview 与webview 的混合加载使用

## 1.1.2

 * 添加在加载 Html 字符串时 默认 编码为  utf-8 

## 1.1.1

* 修复在 iphone 8 下  JS 回调 Flutter 无效问题

## 1.1.0 

* 新增的对浏览网页历史的前进与后退  Android iOS 都支持

## 1.0.0 

* 完善了Flutter与HTML中的JS的双向互调

## 0.0.2

* 添加加载资源目录assets下静态html文件

## 0.0.1

* TODO: Describe initial release.


