import 'package:flutter/material.dart';

import 'exampl_default_hex_refresh.dart';
import 'exampl_default_hex_refresh2.dart';
import 'exampl_default_hex_refresh3.dart';
import 'exampl_html_asset_string.dart';
import 'exampl_html_url_page.dart';
import 'exampl_js_click_flutter.dart';
import 'exampl_loading_html_img_click.dart';
import 'exampl_loading_html_video.dart';

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
          ///HTML URL
          buildHtmlUrlButtonAlign(context),
          Align(
            alignment: Alignment(0, -1),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   new MaterialPageRoute(
                  //       builder: (context) => new ExamplHtmlStringPage()),
                  // );
                },
                child: Text(
                  "HTML String 数据加载 ",
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
                        builder: (context) => new HtmlAssetStringPage()),
                  );
                },
                child: Text(
                  "加载本地 Html , 有两种方式 一种是 assets 目录下的文件  一种是 Html 字条串 ",
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
                        builder: (context) =>
                            new DefaultHtmlBlockImageClickPage()),
                  );
                },
                child: Text(
                  "Html中的图片点击回调 ",
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
                        builder: (context) => new DefaultHtmlVideoPage()),
                  );
                },
                child: Text(
                  "播放视频 ",
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
                  " 低版本混合页面加载  ",
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
                        builder: (context) => new DefaultHexRefreshPage2()),
                  );
                },
                child: Text(
                  " 1.1.4 版本以上混合页面加载  ",
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
                        builder: (context) => new DefaultHexRefreshPage3()),
                  );
                },
                child: Text(
                  " 1.1.4 版本以上 Widget 中间使用 Widget 加载  ",
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
                        builder: (context) => new JSandFlutterUsePage()),
                  );
                },
                child: Text(
                  " JS 与 Flutter的双向互调  ",
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

  Align buildHtmlUrlButtonAlign(BuildContext context) {
    return Align(
      alignment: Alignment(0, -1),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new ExamplHtmlUrlPage()),
            );
          },
          child: Text(
            "常用方式 通过 url 加载一个 html ",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.black,
        ),
      ),
    );
  }
}
