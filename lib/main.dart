import 'package:flutter/material.dart';

import 'package:guitar/view/search.dart';
import 'package:guitar/view/showLyrics.dart';

import 'package:guitar/view/synco.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final String title = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guitar Chords',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsListPage(),
      routes: <String, WidgetBuilder>{},
    );
  }
}
