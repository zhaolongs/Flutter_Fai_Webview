import 'dart:async';

class NativeEventMessage {
  static NativeEventMessage _instance;
  //定义一个Controller
  StreamController _streamController;
  factory NativeEventMessage.getDefault() {
    return _instance ??= NativeEventMessage._init();
  }

  //初始化
  NativeEventMessage._init() {
    _streamController = StreamController.broadcast();
  }

  //注册
  StreamSubscription<T> register<T>(void onData(T event)) {
    ///没有指定类型，全类型注册
    ///监听事件
    if (T == dynamic) {
      return _streamController.stream.listen(onData);
    } else {
      ///筛选出 类型为 T 的数据,获得只包含T的Stream
      Stream<T> stream =
          _streamController.stream.where((type) => type is T).cast<T>();
      return stream.listen(onData);
    }
  }

  //发送消息
  void post(event) {
    _streamController.add(event);
  }

  //取消注册
  void unregister() {
    print("取消注册");
    _streamController.close();
  }
}
