import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_todo/features/home/views/widgets/task_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyTaskList extends StatefulWidget {
  const MyTaskList({super.key});

  @override
  State<MyTaskList> createState() => _MyTaskListState();
}

class _MyTaskListState extends State<MyTaskList> {
  final _stream = Supabase.instance.client
      .from('todos')
      .stream(primaryKey: ['id']).order('created_at');

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            log("Error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tasks = snapshot.data;

          if (tasks == null || tasks.isEmpty) {
            return const Center(child: Text('No tasks found'));
          }

          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return TaskView(task: task);
              },
            ),
          );
        },
      ),
    );
  }
}
