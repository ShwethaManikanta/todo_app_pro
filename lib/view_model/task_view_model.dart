import 'package:flutter/material.dart';
import '../core/services/task_service.dart';
import '../models/task_model.dart';
import 'package:uuid/uuid.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskService _taskService;
  final _uuid = const Uuid();

  TaskViewModel(this._taskService) {
    _taskService.taskStream.listen((_) {
      notifyListeners();
    });
  }

  List<TaskModel> getTasks(String userId) {
    return _taskService.getUserTasks(userId);
  }

  void addTask(String title, String description, String ownerId) {
    final newTask = TaskModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      ownerId: ownerId,
      sharedWith: [],
    );
    _taskService.addTask(newTask);
  }

  void updateTask(TaskModel updatedTask) {
    _taskService.updateTask(updatedTask);
  }

  void deleteTask(String taskId) {
    _taskService.deleteTask(taskId);
  }

  void shareTask(String taskId, String userIdToShareWith) {
    _taskService.shareTask(taskId, userIdToShareWith);
  }

  void resetTasks() {
    _taskService.clearAll();
  }

  Stream<List<TaskModel>> get taskStream => _taskService.taskStream;
}
