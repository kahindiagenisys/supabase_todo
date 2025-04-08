import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/build_context_extensions.dart';
import 'package:my_todo/core/extensions/form_state_extensions.dart';
import 'package:my_todo/core/functions/show_toast_message.dart';
import 'package:my_todo/core/widgets/buttons/app_button_widget.dart';
import 'package:my_todo/core/widgets/text_field/text_field_widget.dart';
import 'package:my_todo/features/home/view_models/task_view_model.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/state/global_state_store.dart';
import 'package:my_todo/utils/validations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  File? _selectedFile;
  bool isEditing = false;
  String? _existingFileUrl;

  @override
  void initState() {
    isEditing = widget.task != null;
    if (isEditing) {
      _titleController.text = widget.task!['title'] ?? '';
      _descriptionController.text = widget.task!['description'] ?? '';
      _existingFileUrl = widget.task!['file_url'];
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
            child: SingleChildScrollView(
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: GestureDetector(
                      onTap: _pickFile,
                      child: _buildFilePreview(),
                    ),
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
          ),
        );
      },
    );
  }

  void handleSaveAction() {
    if (_formKey.currentState.isNotValid) return;
    _task.saveTask(
      id: widget.task?['id'],
      file: _selectedFile,
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

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Widget _buildFilePreview() {
    final color = context.colorScheme;

    // 🧾 CASE 1: New File Picked
    if (_selectedFile != null) {
      final ext = _selectedFile!.path.split('.').last.toLowerCase();

      if (['jpg', 'png'].contains(ext)) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 120,
                width: 120,
                margin: EdgeInsets.only(top: 12, right: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedFile!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CloseButton(
                color: color.error,
                onPressed: () {
                  setState(() {
                    _selectedFile = null;
                  });
                },
              ),
            )
          ],
        );
      }

      // Non-image file
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            const Icon(Icons.insert_drive_file, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(child: Text(_selectedFile!.path.split('/').last)),
          ],
        ),
      );
    }

    // 🖼️ CASE 2: Existing file from URL (on Edit mode)
    if (_existingFileUrl != null && _existingFileUrl!.isNotEmpty) {
      final isImage = _existingFileUrl!.endsWith(".jpg") ||
          _existingFileUrl!.endsWith(".png");

      if (isImage) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 120,
                width: 120,
                margin: EdgeInsets.only(top: 12, right: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl:
                        '${_existingFileUrl!}&dummy=${DateTime.now().millisecondsSinceEpoch}',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CloseButton(
                color: color.error,
                onPressed: () {
                  setState(() {
                    _existingFileUrl = null;
                  });
                },
              ),
            )
          ],
        );
      }

      // Non-image file from signed URL
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            const Icon(Icons.insert_drive_file, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final uri = Uri.parse(_existingFileUrl!);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: Text(
                  "Unknown file",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: color.error),
              onPressed: () {
                setState(() {
                  _existingFileUrl = null;
                });
              },
            )
          ],
        ),
      );
    }

    // 📎 CASE 3: Nothing selected
    return Container(
      height: 45,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.primary),
      ),
      child: Row(
        spacing: 5,
        children: [
          5.width,
          Icon(Icons.attach_file, color: color.primary),
          Text(
            "File select",
            style: context.textTheme.bodyMedium?.copyWith(
              color: color.primary,
            ),
          ),
        ],
      ),
    );
  }
}
