import 'package:scoped_model/scoped_model.dart';

class BoardModel extends Model {
  String _name;
  List<TaskListModel> _columns;

  BoardModel(this._name, this._columns);

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

  TaskModel(this._name);

  String get name => _name;

  set name(String value) {
    _name =  value;
    notifyListeners();
  }
}