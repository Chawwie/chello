import 'package:flutter/material.dart';
import 'package:chello/model.dart';
import 'package:chello/list.dart';

import 'package:flutter_redux/flutter_redux.dart';

class BoardView extends StatefulWidget {
  BoardView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BoardState createState() => new _BoardState();

  static _BoardState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_BoardInheritedWidget) as _BoardInheritedWidget).data;
  }
}

class _BoardState extends State<BoardView> {

  Board board = new Board(
      'the Board',
      <TaskList> [
        new TaskList('Best List', <Task> [
          new Task('chalk one'),
          new Task('chalk two'),
        ]),
        new TaskList('Second Best List', <Task> [
          new Task('prince one'),
          new Task('prince two'),
        ]),
        new TaskList('Third Best List', <Task> [
          new Task('bravo one'),
          new Task('bravo two'),
        ]),
        new TaskList('Four Best List', <Task> [
          new Task('alpha one'),
          new Task('alpha two'),
        ]),
      ]
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: _BoardInheritedWidget(
          data: this,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _buildLists()..add(_buildAddBoardButton()),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLists() {
    List<Widget> lists = new List<Widget>();
    for (var i = 0; i < board.size(); i++) {
      lists.add(new ChelloList(key: new ValueKey<int>(i), taskList: board.getList(i)));
    }
    return lists;


  }

  Widget _buildAddBoardButton() {
    return new RaisedButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            board.addList(new TaskList('new column', new List<Task>()));
          });
        }
    );
  }

  void addTask(int index, String name) {
    setState(() {
      board.getList(index).addTask(new Task(name));
    });
  }

  void _insertTask(Task task, int boardIndex, int listIndex) {
    board.getList(boardIndex).tasks.insert(listIndex, task);
  }

  void _removeTask(Task task, int boardIndex) {
    board.getList(boardIndex).tasks.remove(task);
  }

  void moveTask(Task task, int fromList, int toList, int listIndex) {
    setState(() {
      _removeTask(task, fromList);
      _insertTask(task, toList, listIndex);
    });
  }
}

class _BoardInheritedWidget extends InheritedWidget {
  final _BoardState data;

  _BoardInheritedWidget({Key key, this.data, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_BoardInheritedWidget old) {
    return true;
  }
}
