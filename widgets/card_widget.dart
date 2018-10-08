import 'dart:math';

import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:chello/model.dart';
import 'package:chello/task_page.dart';

class ChelloCard extends StatelessWidget {

  final TaskIndex location;

  ChelloCard({ Key key, this.location });

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<TaskListModel>(
        builder: (context, child, column) {
          TaskModel task = column.getTask(location.listIndex);
          return new LongPressDraggable(
            child: _buildSizedNamedButton(task.name, () {
              _pushCardDetailView(context, task);
            }),
            feedback: new Transform.rotate(
              angle: 0.0872665,     // 5 degrees to radians
              child: _buildSizedNamedButton(task.name, (){}),
            ),
            childWhenDragging: _buildSizedNamedButton('', null),
            data: DraggableCard(location.boardIndex, task),
          );
        }
    );
  }

  Widget _buildSizedNamedButton(String name, void onPressed()) {
    return new SizedBox(
      width: 250.0,
      child: new RaisedButton(
        child: new Text(name),
        onPressed: onPressed,
      ),
    );
  }

  void _pushCardDetailView(BuildContext context, TaskModel task) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) {
          return new TaskPage(task: task);
        }
    ));
  }
}

class CardListDragTarget extends StatelessWidget {

  final TaskIndex location;

  CardListDragTarget({ Key key, this.location });

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

class DraggableCard {
  int fromBoardIndex;
  TaskModel task;

  DraggableCard(this.fromBoardIndex, this.task);
}

