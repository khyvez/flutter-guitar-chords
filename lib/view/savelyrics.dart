import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guitar/Controllers/apiHelper.dart';
import 'package:guitar/view/animator.dart';
import 'package:kaaawebview_flutter/webview_flutter.dart';
import 'package:guitar/Controllers/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as p;

class SavedScreen extends StatefulWidget {
  @override
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SavedScreen> {
  @override
  WebViewController _controller;

  SongDatabaseProvider songDatabaseProvider = SongDatabaseProvider();

  @override
  void initState() {
    super.initState();

    file('fb.png');
  }

  File _fimage;
  bool _isVisible = true;

  Future<File> file(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = p.join(dir.path, filename);

    _fimage = File(pathName);

    return File(pathName);
  }

  void showHide() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  Widget build(BuildContext context) {
    final Song todo = ModalRoute.of(context).settings.arguments;

    var stylesheet =
        '<style>.gt-chord {color: #FF00A1; display: inline-block; cursor: pointer; line-height: normal; margin-bottom: 3px; vertical-align: bottom;} .chordline span strong { display: inline-block; line-height: 2em; position: relative; width: 0; top: -1.3em; left: 0; font: bold 80%/1 sans-serif; color: #FF00A1;} .chordline>span {position: relative; color: #fff; font-weight: 400; line-height: 2.3em;} body{ background: #263859; color: #fff;}</style>';
    String songTitle = '<h2> ${todo.title} </h2> <br><br>';

    String bodyhtml =
        '<body>' + songTitle + todo.bods + ' ' + stylesheet + '</body>';

    _loadHtmlFromAssets(bodyhtml);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(23, 34, 59, 1),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          ),

          // action button
        ],
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
          color: Color.fromRGBO(38, 56, 89, 1),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Builder(builder: (BuildContext context) {
                  return WebView(
                    initialUrl: '',
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller = webViewController;
                      _controller = webViewController;

                      _loadHtmlFromAssets(bodyhtml);
                    },
                  );
                }),
              ),
              Expanded(
                  flex: _isVisible == true ? 2 : 0,
                  child: Visibility(
                      visible: _isVisible,
                      child: WidgetANimator(Container(
                        color: Colors.white,
                        //       child: listViewWidget(),
                      ))))
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: showHide,
        tooltip: 'Show Chords',
        backgroundColor: Color.fromRGBO(107, 14, 85, 1),
        child: Icon(Icons.music_note),
      ),
    );
  }

  _loadHtmlFromAssets(String bodyHtml) async {
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(bodyHtml));
    await _controller.loadUrl('data:text/html;base64,$contentBase64');
  }
}
