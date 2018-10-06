import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:chello/actions.dart';
import 'package:chello/reducers.dart';

import 'package:chello/model.dart';
import 'package:chello/board.dart';


class ChelloList extends StatelessWidget {

  final TaskList taskList;

  ChelloList({Key key, this.taskList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(10.0),
      width: 250.0,
      color: Colors.grey,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ChelloListTitle(boardIndex: _index),
          new Expanded(child: new CardListView(_index, taskList)),
          new AddCardButton(boardIndex: _index),
        ],
      ),
    );
  }

  int get _index => (key as ValueKey<int>).value;
}

class CardListView extends StatelessWidget {

  final int boardIndex;
  final TaskList taskList;

  CardListView(this.boardIndex, this.taskList);

  @override
  Widget build(BuildContext context) {

    /* Interleave Chellocards with dragtargets */
    List<Widget> children = new List<Widget>();

    int i = 0;
    for (;i < taskList.tasks.length; i++) {
      TaskIndex location = new TaskIndex(boardIndex, i);
      children.add(CardListDragTarget(location));
      children.add(ChelloCard(location));
    }
    children.add(CardListDragTarget(new TaskIndex(boardIndex, i++)));

    return new Container(
      margin: EdgeInsets.all(10.0),
      child: new ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: children
      ),
    );
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
        TaskList taskList = BoardView.of(context).board.getList(location.boardIndex);
        return !taskList.contains(draggedTask.task);
      },
      onAccept: (DraggableCard draggedTask) {
        int fromListIndex = draggedTask.fromListIndex;
        BoardView.of(context).moveTask(draggedTask.task, fromListIndex, location.boardIndex, location.listIndex);
      },
    );
  }
}

class ChelloCard extends StatelessWidget {

  final TaskIndex location;

  ChelloCard(this.location);

  @override
  Widget build(BuildContext context) {
    Task task = BoardView.of(context).board.getTask(location);
    return LongPressDraggable<DraggableCard>(
      childWhenDragging: new RaisedButton(),
      feedback: new Text(task.name),
      data: DraggableCard(location.boardIndex, task),
      child: new RaisedButton(
          child: new Text(task.name),
          onPressed: _pushCardDetailView
      ),
    );
  }

  void _pushCardDetailView() {
    print('tapped card');
  }
}

class DraggableCard {
  int fromListIndex;
  Task task;

  DraggableCard(this.fromListIndex, this.task);
}


class ChelloListTitle extends StatelessWidget {

  final int boardIndex;

  ChelloListTitle({ Key key, this.boardIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Board, TaskList>(
      converter: (store) => store.state.getList(boardIndex),
      builder: (BuildContext context, TaskList taskList) {
        return new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new TextField(
            controller: new TextEditingController(text: taskList.name),
            onSubmitted: (text) {
              
              StoreProvider.of<Board>(context).dispatch(action)
              
              BoardView
                  .of(context)
                  .board
                  .getList(boardIndex)
                  .name = text;
            },
          ),
        );
      },
    );
  }
}

class AddCardButton extends StatelessWidget {

  final int boardIndex;

  AddCardButton( { Key key, this.boardIndex }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 50.0,
      width: 250.0,
      margin: EdgeInsets.all(5.0),
      child: new RaisedButton(
        child: const Text('Add Task'),
        onPressed: () {
          Future<String> future = _showFormDialog(context);
          future.then((result) {
            BoardView.of(context).addTask(boardIndex, result);
          });
        },
      ),
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