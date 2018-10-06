
class TaskIndex {
  final int boardIndex;
  final int listIndex;

  TaskIndex(this.boardIndex, this.listIndex);
}

class Board {
  String name;
  List<TaskList> taskLists;

  Board(this.name, this.taskLists);

  TaskList getList(int index) => taskLists[index];

  Task getTask(TaskIndex index) {
    return getList(index.boardIndex).getTask(index.listIndex);
  }

  int size() {
    return taskLists.length;
  }

  void addList(TaskList taskList) {
    taskLists.add(taskList);
  }
}

class TaskList {
  String name;
  List<Task> tasks;

  TaskList(this.name, this.tasks);

  Task getTask(int index) {
    return tasks[index];
  }

  void addTask(Task task) {
    tasks.add(task);
  }

  bool contains(Task task) {
    return tasks.contains(task);
  }

  int length() {
    return tasks.length;
  }
}

class Task {
  String name;

  Task(this.name);
}