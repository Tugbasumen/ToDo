import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../providers/task_repository.dart';

// Repository provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

// Task listesi stream provider
final taskListProvider = StreamProvider<List<Task>>((ref) {
  final repo = ref.read(taskRepositoryProvider);
  return repo.getTasks();
});
