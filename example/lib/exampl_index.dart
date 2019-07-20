import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

import 'exampl_default_hex_refresh.dart';
import 'exampl_default_html_data_max.dart';
import 'exampl_default_html_data_max_refresh.dart';
import 'exampl_default_html_data_max_refresh2.dart';
import 'exampl_loading_html_img_click.dart';
import 'exampl_default_url_max.dart';
import 'exampl_default_url_max_refresh.dart';

class IndexPage extends StatefulWidget {
  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment(0, -1),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            new DefaultLoadingWebViewUrlPage()),
                  );
                },
                child: Text(
                  "常用方式 通过 url 加载一个 html ",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -1),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new DefaultMaxUrlRefreshPage()),
                  );
                },
                child: Text(
                  "常用方式 通过 url 加载一个 html 下拉刷新 ",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -1),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new DefaultMaxHtmlDataPage()),
                  );
                },
                child: Text(
                  "全屏加载 html data ",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -1),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new DefaultHtmlBlockDataPage2()),
                  );
                },
                child: Text(
                  "全屏加载 html data 适配 ",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -1),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new DefaultHtmlBlockImageClickPage()),
                  );
                },
                child: Text(
                  "全屏加载 html 标签 并适配设置图片可点击 ",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -1),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new DefaultHtmlBlockDataPage()),
                  );
                },
                child: Text(
                  "全屏加载  标签内的富文本 ",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -1),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new DefaultHexRefreshPage()),
                  );
                },
                child: Text(
                  "混合页面加载  ",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
