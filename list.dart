import 'dart:async';

import 'package:flutter/material.dart';

import 'package:chello/model.dart';
import 'package:chello/board.dart';
import 'package:chello/dialog.dart';


class ChelloList extends StatelessWidget {

  final int boardIndex;
  final TaskList taskList;

  ChelloList(this.boardIndex, this.taskList);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(10.0),
      width: 250.0,
      color: Colors.grey,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ChelloListTitle(taskList.name),
          new ChelloCardList(boardIndex, taskList),
          new AddCardButton(),
        ],
      ),
    );
  }
}

class ChelloCardList extends StatelessWidget {

  final int boardIndex;
  final TaskList taskList;

  ChelloCardList(this.boardIndex, this.taskList);

  @override
  Widget build(BuildContext context) {

    /* Interleave Chellocards with dragtargets */
    List<Widget> children = new List<Widget>();
    int i = 0;
    for (Task task in taskList.tasks) {
      children.add(CardListDragTarget(boardIndex, i++));
      children.add(ChelloCard(boardIndex, task));
    }
    children.add(CardListDragTarget(boardIndex, i++));

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

  final int boardIndex;
  final int listIndex;

  CardListDragTarget(this.boardIndex, this.listIndex);

  @override
  Widget build(BuildContext context) {
    return new DragTarget<DraggableCard>(
      builder: (BuildContext context, List<DraggableCard> candidateData, List rejectedData) {

        TaskList taskList = BoardView.of(context).board.getList(boardIndex);
        if (candidateData.isEmpty) {
          // dragged FROM this list

          return new Container(
              padding: EdgeInsets.all(3.0)
          );
        } else if (!taskList.contains(candidateData.first.task)) {

          // if task is from different cardlist
          print('target $listIndex');
          return new Container(
            padding: EdgeInsets.all(15.0),
            color: Colors.deepOrange,
          );
        }
      },
      onWillAccept: (DraggableCard draggedTask) {
        /* Only accept if task came from different cardList */
        TaskList taskList = BoardView.of(context).board.getList(boardIndex);
        return !taskList.contains(draggedTask.task);
      },
      onAccept: (DraggableCard draggedTask) {
        int fromListIndex = draggedTask.fromListIndex;
        print('accept from $fromListIndex to $boardIndex');
        print(draggedTask.task.name);
        BoardView.of(context).moveTask(draggedTask.task, fromListIndex, boardIndex, listIndex);
      },
    );
  }
}

class ChelloCard extends StatelessWidget {

  final int boardIndex;
  final Task task;

  ChelloCard(this.boardIndex, this.task);

  @override
  Widget build(BuildContext context) {

    return LongPressDraggable<DraggableCard>(
      childWhenDragging: new RaisedButton(),
      feedback: new Text(task.name),
      data: DraggableCard(boardIndex, task),
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

  final String title;

  ChelloListTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(title),
        onTap: () {
          print('title tap');
        }
    );
  }
}
class AddCardButton extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      child: const Text('add card'),
      onPressed: () {
        print('add card');
//          Future<String> future = _neverSatisfied(context);
//          future.then((result) {
//            print(result);
//          });
      },
    );
  }

  Future<String> _neverSatisfied(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Add new task'),
          content: new Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      Navigator.of(context).pop(_formKey);
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}