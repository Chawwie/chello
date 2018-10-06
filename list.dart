import 'dart:async';

import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:chello/scoped_models.dart';

import 'package:chello/model.dart';
import 'package:chello/board.dart';


class ChelloList extends StatelessWidget {

  ChelloList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(10.0),
      width: 250.0,
      color: Colors.grey,
      child: new ScopedModel<TaskListModel>(
        model: ScopedModel.of<BoardModel>(context).getColumn(_index),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ChelloListTitle(boardIndex: _index),
            new Expanded(child: new CardListView(_index)),
            new AddCardButton(boardIndex: _index),
          ],
        ),
      ),
    );
  }

  int get _index => (key as ValueKey<int>).value;
}

class CardListView extends StatelessWidget {

  final int boardIndex;

  CardListView(this.boardIndex);

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<TaskListModel>(
      builder: (context, child, column) {
        return new Container(
          margin: EdgeInsets.all(10.0),
          child: new ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: _buildChildren(column),
          ),
        );
      }
    );
  }

  List<Widget> _buildChildren(TaskListModel column) {
    List<Widget> children = new List<Widget>();

    /* Interleave Chellocards with drag targets */
    int i = 0;
    for (;i < column.length; i++) {
      TaskIndex location = new TaskIndex(boardIndex, i);
      children.add(CardListDragTarget(location));
      children.add(ChelloCard(location));
    }
    children.add(CardListDragTarget(new TaskIndex(boardIndex, i++)));

    return children;
  }
}

class CardListDragTarget extends StatelessWidget {

  final TaskIndex location;

  CardListDragTarget(this.location);

  @override
  Widget build(BuildContext context) {
    return new DragTarget<DraggableCard>(
      builder: (BuildContext context, List<DraggableCard> candidateData, List rejectedData) {
        if (candidateData.isEmpty) {
          return new Container(
              padding: EdgeInsets.all(3.0)
          );
        } else {
          return new Container(
            padding: EdgeInsets.all(15.0),
            color: Colors.deepOrange,
          );
        }
      },
      onWillAccept: (DraggableCard draggedTask) {
        /* Accept task if it came from different cardList */
        TaskListModel taskList = ScopedModel.of<TaskListModel>(context);
        return !taskList.contains(draggedTask.task);
      },
      onAccept: (DraggableCard draggedTask) {
        TaskListModel toColumn = ScopedModel.of<BoardModel>(context).getColumn(location.boardIndex);
        TaskListModel fromColumn = ScopedModel.of<BoardModel>(context).getColumn(draggedTask.fromBoardIndex);
        toColumn.insertTask(location.listIndex, draggedTask.task);
        fromColumn.removeTask(draggedTask.task);
      },
    );
  }
}

class ChelloCard extends StatelessWidget {

  final TaskIndex location;

  ChelloCard(this.location);

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<TaskListModel>(
        builder: (context, child, column) {
          TaskModel task = column.getTask(location.listIndex);
          return new LongPressDraggable(
              child: new RaisedButton(
                child: new Text(task.name),
                onPressed: _pushCardDetailView,
              ),
            feedback: new Text(task.name),
            childWhenDragging: new RaisedButton(onPressed: () {}),
            data: DraggableCard(location.boardIndex, task),
          );
        }
    );
  }

  void _pushCardDetailView() {
    print('tapped card');
  }
}

class DraggableCard {
  int fromBoardIndex;
  TaskModel task;

  DraggableCard(this.fromBoardIndex, this.task);
}


class ChelloListTitle extends StatelessWidget {

  final int boardIndex;

  ChelloListTitle({ Key key, this.boardIndex }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<TaskListModel>(
      builder: (context, child, column) {
        return new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new TextField(
            controller: new TextEditingController(text: column.name),
            onSubmitted: (text) {
              column.name = text;
            },
          ),
        );
      }
    );
  }
}

class AddCardButton extends StatelessWidget {

  final int boardIndex;

  AddCardButton({ Key key, this.boardIndex }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<TaskListModel>(
      builder: (context, child, column) {
        return new Container(
          height: 50.0,
          width: 250.0,
          margin: EdgeInsets.all(5.0),
          child: new RaisedButton(
            child: const Text('Add Task'),
            onPressed: () {
              Future<String> future = _showFormDialog(context);
              future.then((result) {
                column.addTask(new TaskModel(result));
              });
            },
          ),
        );
      },
    );
  }

  Future<String> _showFormDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Add new task'),
          content: new AddCardForm(),
        );
      },
    );
  }
}

class AddCardForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddCardFormState();

}

class _AddCardFormState extends State<AddCardForm> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _data = '';

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: new Column(
        children: <Widget>[
          new TextFormField(
            onSaved: (String value) {
              _data = value;
            }
          ),
          new Container(
            child: new RaisedButton(
              child: new Text('Add task'),
              onPressed: () {
                this.submit();
                Navigator.of(context).pop(_data);
              },
            ),
          )
        ]
      )
    );
  }

  void submit() {
    _formKey.currentState.save();
  }
}