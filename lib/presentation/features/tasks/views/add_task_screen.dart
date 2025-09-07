import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not/core/constants/task_constants.dart';
import 'package:not/presentation/common/custom_button.dart';
import 'package:not/presentation/common/custom_snackbar.dart';
import '../models/task.dart';
import '../repository/task_provider.dart';
import '../widgets/task_form.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  final List<String> _taskTitles = TaskConstants.taskTitles;
  String? _selectedTitle;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_selectedTitle == null) {
      CustomSnackbar.show(
        context,
        message: "Lütfen başlık seçiniz",
        type: SnackbarType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    final newTask = Task(
      id: '',
      title: _selectedTitle!,
      description: _descriptionController.text.trim(),
      isCompleted: false,
      date: _selectedDate ?? DateTime.now(),
    );

    try {
      await ref.read(taskRepositoryProvider).addTask(newTask);

      if (mounted) {
        Navigator.pop(context);
        CustomSnackbar.show(
          context,
          message: "Görev başarıyla eklendi",
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: "Görev eklenirken hata oluştu: $e",
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
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yeni Görev Ekle"), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
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

                  /// Ortak Form Widget kullanıldı
                  TaskForm(
                    taskTitles: _taskTitles,
                    selectedTitle: _selectedTitle,
                    onTitleChanged: (val) =>
                        setState(() => _selectedTitle = val),
                    descriptionController: _descriptionController,
                    selectedDate: _selectedDate,
                    onPickDate: _pickDate,
                  ),
                  const SizedBox(height: 20),

                  //  CustomButton kullanıldı
                  CustomButton(
                    isLoading: _isLoading,
                    text: "Görevi Kaydet",
                    onPressed: _saveTask,
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
