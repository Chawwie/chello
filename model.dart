import 'package:scoped_model/scoped_model.dart';

class BoardModel extends Model {
  String _name;
  List<TaskListModel> _columns;

  BoardModel(this._name, this._columns);

  BoardModel.example() {
    this._name = 'the Board';
    this._columns = <TaskListModel> [
      new TaskListModel('Best List', <TaskModel> [
        new TaskModel('chalk one'),
        new TaskModel('chalk two'),
      ]),
      new TaskListModel('Second Best List', <TaskModel> [
        new TaskModel('prince one'),
        new TaskModel('prince two'),
      ]),
      new TaskListModel('Third Best List', <TaskModel> [
        new TaskModel('bravo one'),
        new TaskModel('bravo two'),
      ]),
      new TaskListModel('Four Best List', <TaskModel> [
        new TaskModel('alpha one'),
        new TaskModel('alpha two'),
      ]),
    ];
  }

  String get name => _name;
  int get size => _columns.length;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  TaskListModel getColumn(int index) {
    return _columns[index];
  }

  void addColumn(TaskListModel column) {
    _columns.add(column);
    notifyListeners();
  }
}

class TaskListModel extends Model {
  String _name;
  List<TaskModel> _tasks;

  TaskListModel(this._name, this._tasks);

  get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  get length => _tasks.length;

  TaskModel getTask(int index) {
    return _tasks[index];
  }

  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void insertTask(int index, TaskModel task) {
    _tasks.insert(index, task);
    notifyListeners();
  }

  void removeTaskAt(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void removeTask(TaskModel task) {
    _tasks.remove(task);
    notifyListeners();
  }

  bool contains(TaskModel task) {
    return _tasks.contains(task);
  }
}

class TaskModel extends Model {
  String _name;
  String _description = '';

  TaskModel(this._name);

  String get name => _name;
  String get description => _description;

  set name(String value) {
    _name =  value;
    notifyListeners();
  }

  set description(String value) {
    _description = value;
    notifyListeners();
  }
}

class TaskIndex {
  final int boardIndex;
  final int listIndex;

  TaskIndex(this.boardIndex, this.listIndex);
}
