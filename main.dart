
import 'package:flutter/material.dart';
import 'package:chello/widgets/board_widget.dart';


void main() {
  runApp(new ChelloApp(title: 'Chello'));
}

class ChelloApp extends StatelessWidget {

  final String title;

  ChelloApp({ Key key, this.title }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: title,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      ),
      home: new BoardWidget(title: title),
    );
  }
}
