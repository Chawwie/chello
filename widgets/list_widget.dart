import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:chello/model.dart';
import 'package:chello/widgets/card_widget.dart';
import 'package:chello/widgets/add_card_widget.dart';


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