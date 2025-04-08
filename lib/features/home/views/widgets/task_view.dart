import 'package:flutter/material.dart';
import 'package:my_todo/core/functions/show_toast_message.dart';
import 'package:my_todo/features/home/view_models/task_view_model.dart';
import 'package:my_todo/features/home/views/widgets/task_form.dart';
import 'package:my_todo/locator.dart';
import 'package:nb_utils/nb_utils.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key, required this.task});

  final Map<String, dynamic> task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final _task = locator<TaskViewModel>();

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.task['is_completed'] == true;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color:
              isCompleted ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCompleted ? Colors.green.shade300 : Colors.orange.shade300,
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: Checkbox(
            activeColor: isCompleted ? Colors.green : Colors.orange,
            value: isCompleted,
            onChanged: (value) async {
              await _task.toggleTaskStatus(
                widget.task['id'],
                value ?? false,
              );
            },
          ),
          title: Text(
            widget.task['title'] ?? 'Untitled Task',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isCompleted ? Colors.green[800] : Colors.orange[800],
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.task['description'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon:
                    const Icon(Icons.edit, size: 20, color: Colors.blueAccent),
                onPressed: isCompleted
                    ? null
                    : () {
                        _showTaskForm(widget.task);
                      },
              ),
              IconButton(
                icon:
                    const Icon(Icons.delete, size: 20, color: Colors.redAccent),
                onPressed: () async {
                  bool isDelete = await showConfirmDialog(
                    context,
                    "Are you sure you want to delete this task?",
                    onAccept: () => true,
                  );

                  if (isDelete && context.mounted) {
                    await _task.deleteTask(
                      id: widget.task['id'],
                      onSuccess: (message) {
                        showSuccessToastMessage(message: message);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTaskForm(task) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TaskForm(task: task),
      ),
    );
  }
}
