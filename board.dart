import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:chello/scoped_models.dart';

import 'package:chello/list.dart';


class BoardView extends StatefulWidget {
  BoardView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BoardState createState() => new _BoardState();
}

class _BoardState extends State<BoardView> {

  BoardModel boardModel = new BoardModel(
      'the Board',
      <TaskListModel> [
        new TaskListModel('Best List', <TaskModel> [
          new TaskModel('chalk one'),
          new TaskModel('chalk two'),
        ]),
        new TaskListModel('Second Best List', <TaskModel> [
          new TaskModel('prince one'),
          new TaskModel('prince two'),
        ]),
        new TaskListModel('Third Best List', <TaskModel> [
          new TaskModel('bravo one'),
          new TaskModel('bravo two'),
        ]),
        new TaskListModel('Four Best List', <TaskModel> [
          new TaskModel('alpha one'),
          new TaskModel('alpha two'),
        ]),
      ]
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ScopedModel<BoardModel>(
        model: boardModel,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _buildLists(boardModel)..add(_buildAddBoardButton(boardModel)),
        ),
      ),
    );
  }

  List<Widget> _buildLists(BoardModel boardModel) {
    List<Widget> lists = new List<Widget>();
    for (var i = 0; i < boardModel.size; i++) {
      lists.add(new ChelloList(key: new ValueKey<int>(i)));
    }
    return lists;
  }

  Widget _buildAddBoardButton(BoardModel boardModel) {
    return new RaisedButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            boardModel.addColumn(new TaskListModel('new column', new List<TaskModel>()));
          });
        }
    );
  }
}