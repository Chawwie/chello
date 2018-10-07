import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:chello/model.dart';

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
              _showFormDialog(context).then((result) {
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
          content: new _AddCardForm(),
        );
      },
    );
  }
}

class _AddCardForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddCardFormState();
}

class _AddCardFormState extends State<_AddCardForm> {

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
      ),
    );
  }

  void submit() {
    _formKey.currentState.save();
  }
}