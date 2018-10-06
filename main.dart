
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:chello/board.dart';
import 'package:chello/model.dart';

Board boardReducer(Board state, dynamic action) {
  return state;
}

void main() {
  final store = new Store<Board>(boardReducer, initialState: new Board(
      'the Board',
      <TaskList> [
        new TaskList('Best List', <Task> [
          new Task('chalk one'),
          new Task('chalk two'),
          new Task('chalk three'),
        ]),
        new TaskList('Second Best List', <Task> [
          new Task('prince one'),
          new Task('prince two'),
        ]),
        new TaskList('Third Best List', <Task> [
          new Task('bravo one'),
        ]),
        new TaskList('Four Best List', <Task> [
          new Task('alpha one'),
          new Task('alpha two'),
        ]),
      ]
  ));

  runApp(new ChelloApp(store: store, title: 'Chello'));
}

class ChelloApp extends StatelessWidget {

  final Store<Board> store;
  final String title;

  ChelloApp({ Key key, this.store, this.title }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<Board>(
      store: store,
      child: new MaterialApp(
        title: title,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],
        ),
        home: new BoardView(title: title),
      ),
    );
  }
}
