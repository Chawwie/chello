
import 'package:flutter/material.dart';

import 'package:chello/board.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Chello',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      ),
      home: new BoardView(title: 'Chello'),
    );
  }
}
