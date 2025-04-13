import 'dart:async';
import '../../models/task_model.dart';

class TaskService {
  final List<TaskModel> _allTasks = [];
  final StreamController<List<TaskModel>> _taskStreamController =
  StreamController.broadcast();

  Stream<List<TaskModel>> get taskStream => _taskStreamController.stream;

  void _notifyChanges() {
    _taskStreamController.add(List.from(_allTasks));
  }

  void addTask(TaskModel task) {
    _allTasks.add(task);
    _notifyChanges();
  }

  void updateTask(TaskModel updatedTask) {
    final index = _allTasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _allTasks[index] = updatedTask;
      _notifyChanges();
    }
  }

  void deleteTask(String taskId) {
    _allTasks.removeWhere((t) => t.id == taskId);
    _notifyChanges();
  }

  List<TaskModel> getUserTasks(String userId) {
    return _allTasks.where((task) =>
    task.ownerId == userId || task.sharedWith.contains(userId)).toList();
  }

  void shareTask(String taskId, String newUserId) {
    final index = _allTasks.indexWhere((t) => t.id == taskId);
    if (index != -1 && !_allTasks[index].sharedWith.contains(newUserId)) {
      _allTasks[index].sharedWith.add(newUserId);
      _notifyChanges();
    }
  }

  void clearAll() {
    _allTasks.clear();
    _notifyChanges();
  }
}
