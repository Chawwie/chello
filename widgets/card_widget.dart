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
            data: DraggableCard(location, task),
          );
        }
    );
  }

  Widget _buildSizedNamedButton(String name, void onPressed()) {
    return new SizedBox(
      width: 230.0,
      child: new RaisedButton(
        color: Colors.grey[100],
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
        /* Accept dragged task if it came from different taskList or they're on the same taskList but aren't adjacent to each other*/
        return draggedTask.fromLocation.boardIndex != location.boardIndex ||
            (draggedTask.fromLocation.listIndex != location.listIndex &&
                draggedTask.fromLocation.listIndex+1 != location.listIndex);
      },
      onAccept: (DraggableCard draggedTask) {
        TaskListModel toColumn = ScopedModel.of<BoardModel>(context).getColumn(location.boardIndex);

        if (location.boardIndex == draggedTask.fromLocation.boardIndex) {
          toColumn.insertTask(location.listIndex, draggedTask.task);
          if (location.listIndex < draggedTask.fromLocation.boardIndex) {
            toColumn.removeTaskAt(draggedTask.fromLocation.listIndex + 1);
          } else {
            toColumn.removeTaskAt(draggedTask.fromLocation.listIndex);
          }
        } else {
          TaskListModel fromColumn = ScopedModel.of<BoardModel>(context).getColumn(draggedTask.fromLocation.boardIndex);
          toColumn.insertTask(location.listIndex, draggedTask.task);
          fromColumn.removeTaskAt(draggedTask.fromLocation.listIndex);
        }

      },
    );
  }
}

class DraggableCard {
  TaskIndex fromLocation;
  TaskModel task;

  DraggableCard(this.fromLocation, this.task);
}

