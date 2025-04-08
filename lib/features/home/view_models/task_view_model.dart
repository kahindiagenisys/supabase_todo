import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/repositories/task/task_repo.dart';

class TaskViewModel with ChangeNotifier {
  final _taskRepo = locator<TaskRepo>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> toggleTaskStatus(String id, bool isCompleted) async {
   await _taskRepo.toggleTaskStatus(id: id, isCompleted: isCompleted);
  }

  Future<void> saveTask({
    String? id,
    required String title,
    required String description,
    required String userId,
    Function(String message)? onSuccess,
    Function(String message)? onError,
  }) async {
    try {
      if (_isLoading) return;
      isLoading = true;

      await _taskRepo.saveTask(
        id: id,
        title: title,
        description: description,
        userId: userId,
      );

      onSuccess?.call("Task saved successfully");
    } catch (error) {
      log("❌ Error: $error");
      onError?.call(error.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteTask({
    required String id,
    Function(String message)? onSuccess,
    Function(String message)? onError,
  }) async {
    try {
      await _taskRepo.deleteTask(id: id);
      onSuccess?.call("Task deleted successfully");
    } catch (error) {
      log("❌ Error: $error");
      onError?.call(error.toString());
    }
  }

}
