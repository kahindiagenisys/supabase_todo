
import 'dart:io';

abstract class TaskRepoInterface {
  Future<void> saveTask({
    String? id,
    required String title,
    required String description,
    required String userId,
    File? file,
  });

  Future<void> deleteTask({
    required String id,
  });

  Future<void> toggleTaskStatus({
    required String id,
    required bool isCompleted,
  });

}
