import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not/core/constants/task_constants.dart';
import 'package:not/presentation/common/custom_button.dart';
import 'package:not/presentation/common/custom_snackbar.dart';
import '../models/task.dart';
import '../repository/task_provider.dart';
import '../widgets/task_form.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  ConsumerState<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late String _selectedTitle;
  DateTime? _selectedDate;
  bool _isLoading = false;

  final List<String> _taskTitles = TaskConstants.taskTitles;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
    _selectedTitle = widget.task.title;
    _selectedDate = widget.task.date;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updatedTask = Task(
      id: widget.task.id,
      title: _selectedTitle,
      description: _descriptionController.text.trim(),
      isCompleted: widget.task.isCompleted,
      date: _selectedDate ?? DateTime.now(),
    );

    try {
      await ref.read(taskRepositoryProvider).updateTask(updatedTask);

      if (mounted) {
        Navigator.pop(context);
        CustomSnackbar.show(
          context,
          message: "Görev başarıyla güncellendi",
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: "Görev güncellenirken hata oluştu: $e",
        type: SnackbarType.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: today.subtract(const Duration(days: 365)),
      lastDate: today.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Görevi Düzenle")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Görev Bilgileri",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TaskForm(
                    taskTitles: _taskTitles,
                    selectedTitle: _selectedTitle,
                    onTitleChanged: (val) =>
                        setState(() => _selectedTitle = val!),
                    descriptionController: _descriptionController,
                    selectedDate: _selectedDate,
                    onPickDate: _pickDate,
                  ),
                  const SizedBox(height: 20),

                  //  CustomButton kullanıldı
                  CustomButton(
                    isLoading: _isLoading,
                    text: "Görevi Güncelle",
                    onPressed: _updateTask,
                    type: ButtonType.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
