import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/form_state_extensions.dart';
import 'package:my_todo/core/functions/show_toast_message.dart';
import 'package:my_todo/core/widgets/buttons/app_button_widget.dart';
import 'package:my_todo/core/widgets/text_field/text_field_widget.dart';
import 'package:my_todo/utils/validations.dart';
import 'package:provider/provider.dart';
import 'package:my_todo/features/home/view_models/task_view_model.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/state/global_state_store.dart';
import 'package:nb_utils/nb_utils.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key, this.task});

  final Map<String, dynamic>? task;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  final _task = locator<TaskViewModel>();

  final _titleController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _descriptionController = TextEditingController();
  final _descriptionFocusNode = FocusNode();
  final _state = locator<GlobalStateStore>();

  bool isEditing = false;

  @override
  void initState() {
    isEditing = widget.task != null;
    if (isEditing) {
      _titleController.text = widget.task!['title'] ?? '';
      _descriptionController.text = widget.task!['description'] ?? '';
    }
    _titleFocusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _task,
      builder: (context, child) {
        context.watch<TaskViewModel>();
        return IgnorePointer(
          ignoring: _task.isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                10.height,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    isEditing ? "Update Task" : "Create Task",
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextFieldWidget(
                  labelText: "Task Title",
                  hintText: "Enter task title",
                  focusNode: _titleFocusNode,
                  controller: _titleController,
                  nextFocusNode: _descriptionFocusNode,
                  validator: (value) => validateRequiredField("Task", value),
                ),
                TextFieldWidget(
                  labelText: "Task Description",
                  hintText: "Enter task description",
                  minLine: 3,
                  focusNode: _descriptionFocusNode,
                  controller: _descriptionController,
                  onFieldSubmitted: (_) => handleSaveAction(),
                  validator: (value) =>
                      validateRequiredField("Description", value),
                ),
                AppButtonWidget(
                  text: "SAVE",
                  isLoading: _task.isLoading,
                  onTap: handleSaveAction,
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleSaveAction() {
    if (_formKey.currentState.isNotValid) return;
    _task.saveTask(
      id: widget.task?['id'],
      title: _titleController.text,
      description: _descriptionController.text,
      userId: _state.currentUser!.id!,
      onSuccess: (message) {
        context.pop();
        showSuccessToastMessage(message: message);
      },
      onError: (message) {
        showErrorToastMessage(message: message);
      },
    );
  }
}
