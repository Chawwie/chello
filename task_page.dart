import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:chello/model.dart';

class TaskPage extends StatefulWidget {

  final TaskModel task;

  TaskPage({ Key key, this.task }) : super(key: key);

  @override
  _TaskPageState createState() => new _TaskPageState(task);
}

class _TaskPageState extends State<TaskPage> {

  TaskModel _task;

  _TaskPageState(this._task);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TaskModel>(
      model: this._task,
      child: new Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ScopedModelDescendant<TaskModel>(
      builder: (context, child, task) {
        return new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              pinned: true,
              expandedHeight: 150.0,
              flexibleSpace: new FlexibleSpaceBar(
                title: new TextField(
                  controller: new TextEditingController(text: task.name),
                  onSubmitted: (text) {
                    task.name = text;
                  },
                ),
              ),
            ),
            new SliverFixedExtentList(
              itemExtent: 100.0,
              delegate: new SliverChildListDelegate(
                <Widget> [
                  new TextField(
                    controller: new TextEditingController(text: task.description),
                    decoration: new InputDecoration(hintText: 'Edit card description...'),
                    onSubmitted: (text) {
                      task.description = text;
                    },
                  ),
                ]
              )
            ),
          ],
        );
      }
    );
  }
}