import 'dart:developer';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
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
    File? file,
  }) async {
    try {
      final data = {
        'title': title,
        'description': description,
        'user_id': userId,
      };

      if (file != null) {
        final bucket = _supabaseClient.storage.from('task-files');
        final fileName = "${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}";
        final filePath = "user_uploads/$userId/$fileName";

        final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

        // 👇 Upload file with upsert
        await bucket.upload(
          filePath,
          file,
          fileOptions: FileOptions(
            contentType: mimeType,
            upsert: true,
          ),
        );

        // 👇 Generate a signed URL (valid for 1 hour)
        final signedUrl = await bucket.createSignedUrl(filePath, 60 * 60);

        data['file_path'] = filePath; // optional: for later signed URL regen
        data['file_url'] = signedUrl;
      }

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
      await _supabaseClient
          .from('todos')
          .update({'is_completed': isCompleted}).eq('id', id);
    } catch (e) {
      log('❌ Error: $e');
      rethrow;
    }
  }
}
