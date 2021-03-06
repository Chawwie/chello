import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_parallax/flutter_parallax.dart';

import 'package:chello/model.dart';
import 'package:chello/widgets/list_widget.dart';


class BoardWidget extends StatefulWidget {
  BoardWidget({ Key key, this.title }) : super(key: key);

  final String title;

  @override
  _BoardWidgetState createState() => new _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {

  BoardModel _board = new BoardModel.example();
  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<BoardModel>(
      model: _board,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new ScopedModelDescendant<BoardModel>(
          builder: (context, child, board) {
            return new Stack(
              children: <Widget>[
                new Parallax.outside(
                  child: Image.asset(
                    "images/green_splash.jpg",
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topLeft,
                  ),
                  controller: _controller,
                  flipDirection: false,
                  direction: AxisDirection.right,
                ),
                new ListView(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  children: _buildLists(board)..add(_buildAddBoardButton(board)),
                )
              ],
            );

            return new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new ExactAssetImage('images/green_splash.jpg'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: new ListView(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                controller: _controller,
                scrollDirection: Axis.horizontal,
                children: _buildLists(board)..add(_buildAddBoardButton(board)),
              )
            );
          }
        ),
      ),
    );
  }

  List<Widget> _buildLists(BoardModel boardModel) {
    List<Widget> lists = new List<Widget>();
    for (var i = 0; i < boardModel.size; i++) {
      lists.add(new ChelloList(key: new ValueKey<int>(i)));
    }
    return lists;
  }

  Widget _buildAddBoardButton(BoardModel boardModel) {
    return new RaisedButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            boardModel.addColumn(new TaskListModel('new column', new List<TaskModel>()));
          });
        }
    );
  }
}