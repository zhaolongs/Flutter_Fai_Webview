import 'package:flutter/material.dart';

import 'exampl_default_url_max.dart';
import 'exampl_index.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("FaiWebViewWidget 加载 html"),
        ),
        body: IndexPage(),
      ),
    );
  }
}
