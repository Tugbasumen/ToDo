import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not/presentation/features/tasks/repository/task_provider.dart';
import 'package:not/presentation/features/tasks/widgets/task_card.dart';
import '../views/add_task_screen.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsyncValue = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Görevler")),
      body: taskAsyncValue.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text("Görev yok"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TaskCard(task: task),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Hata: $e")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
