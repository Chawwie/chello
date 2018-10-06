import 'package:scoped_model/scoped_model.dart';

class BoardModel extends Model {
  String _name;
  List<TaskListModel> _columns = new List<TaskListModel>();

  BoardModel(this._name);

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  void addColumn(TaskListModel column) {
    _columns.add(column);
    notifyListeners();
  }
}

class TaskListModel extends Model {
  String _name;
  List<TaskModel> _tasks = new List<TaskModel>();

  TaskListModel(this._name);

  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void insertTask(int index, TaskModel task) {
    _tasks.insert(index, task);
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
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