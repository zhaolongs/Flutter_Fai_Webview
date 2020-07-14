import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 创建人： Created by zhaolong
 * 创建时间：Created by  on 2020/7/14.
 *
 * 可关注公众号：我的大前端生涯   获取最新技术分享
 * 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
 * 可关注博客：https://blog.csdn.net/zl18603543572
 */

///按钮状态监听
typedef FaiWebViewListener = void Function(
    int type, Map<String, dynamic> event);

///控制器
class FaiWebViewController {
  FaiWebViewListener _flashAnimationListener;

  ///Flutter调用Html中的Js方法
  ///[parameterMap]为参数内容
  ///[jsMethodName]为调用JS方法的名称
  void toJsFunction({
    @required String jsMethodName,
    Map<String, dynamic> parameterMap,
  }) {
    if (_flashAnimationListener != null) {
      if (parameterMap == null) {
        parameterMap = new Map();
      }
      parameterMap["jsMethodName"] = jsMethodName;
      _flashAnimationListener(2, parameterMap);
    }
  }

  ///绑定监听
  void setListener(FaiWebViewListener listener) {
    _flashAnimationListener = listener;
  }

  ///刷新页面的方法
  void refresh({String htmlData, String htmlBlockData, String htmlUrl}) {
    if (_flashAnimationListener != null) {
      Map<String, dynamic> map = Map();
      if (htmlUrl != null) {
        map["htmlUrl"] = htmlUrl;
      }
      if (htmlBlockData != null) {
        map["htmlBlockData"] = htmlBlockData;
      }
      if (htmlData != null) {
        map["htmlData"] = htmlData;
      }

      _flashAnimationListener(1, map);
    }
  }
}
