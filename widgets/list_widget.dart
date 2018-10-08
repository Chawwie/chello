import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:chello/model.dart';
import 'package:chello/widgets/card_widget.dart';
import 'package:chello/widgets/add_card_widget.dart';


class ChelloList extends StatelessWidget {

  ChelloList({ Key key }) : super(key: key);

  int get _index => (key as ValueKey<int>).value;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: Colors.black12,
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      child: new Container(
        width: 250.0,
        child: new ScopedModel<TaskListModel>(
          model: ScopedModel.of<BoardModel>(context).getColumn(_index),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ChelloListTitle(boardIndex: _index),
              new Expanded(child: new CardListView(boardIndex: _index)),
              new AddCardButton(boardIndex: _index),
            ],
          ),
        ),
      ),
    );
  }
}

class ChelloListTitle extends StatelessWidget {

  final int boardIndex;

  ChelloListTitle({ Key key, this.boardIndex }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<TaskListModel>(
        builder: (context, child, column) {
          return new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            decoration: new BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                const BoxShadow(offset: Offset(0.0, 2.5), spreadRadius: -1.5, blurRadius: 2.5),
              ],
            ),
            child: new TextField(
              decoration: new InputDecoration(
                enabledBorder: InputBorder.none,
              ),
              controller: new TextEditingController(text: column.name),
              onSubmitted: (text) {
                column.name = text;
              },
              onEditingComplete: () {},
            ),
          );
        }
    );
  }
}

class CardListView extends StatelessWidget {

  final int boardIndex;

  CardListView({ Key key, this.boardIndex });

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
      children.add(CardListDragTarget(location: location));
      children.add(ChelloCard(location: location));
    }
    children.add(CardListDragTarget(
        location: new TaskIndex(boardIndex, i++)
    ));

    return children;
  }
}