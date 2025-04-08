import 'dart:developer';

import 'package:my_todo/repositories/task/task_repo_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskRepo implements TaskRepoInterface {
  final _supabaseClient = Supabase.instance.client;

  @override
  Future<void> saveTask({
    String? id,
    required String title,
    required String description,
    required String userId,
  }) async {
    try {
      final data = {
        'title': title,
        'description': description,
        'user_id': userId,
      };

      if (id == null) {
        await _supabaseClient.from('todos').insert({
          ...data,
          'created_at': DateTime.now().toIso8601String(),
        });
      } else {
        await _supabaseClient.from('todos').update(data).eq('id', id);
      }
    } catch (e) {
      log('❌ Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTask({required String id}) async {
    try {
      await _supabaseClient.from('todos').delete().eq('id', id);
    } catch (e) {
      log('❌ Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> toggleTaskStatus(
      {required String id, required bool isCompleted}) async {
    try {

      log("isCompleted $isCompleted");

      await _supabaseClient
          .from('todos')
          .update({'is_completed': isCompleted}).eq('id', id);
    } catch (e) {
      log('❌ Error: $e');
      rethrow;
    }
  }
}
