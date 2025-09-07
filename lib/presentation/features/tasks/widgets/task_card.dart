import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not/presentation/features/tasks/models/task.dart';
import 'package:not/presentation/features/tasks/repository/task_provider.dart';
import 'package:not/presentation/features/tasks/views/edit_task_screen.dart';

class TaskCard extends ConsumerWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  // Başlığa göre renk
  Color getTaskColor(String title) {
    switch (title) {
      case "Alışveriş":
        return Colors.green.shade200;
      case "Temizlik":
        return const Color.fromARGB(255, 159, 208, 248);
      case "Okul":
        return Colors.orange.shade200;
      case "Spor":
        return Colors.red.shade200;
      case "Toplantı":
        return Colors.purple.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  String getFormattedDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: getTaskColor(task.title),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) async {
            final updatedTask = Task(
              id: task.id,
              title: task.title,
              description: task.description,
              isCompleted: value ?? false,
              date: task.date, // Tarihi koruyoruz
            );
            try {
              await ref.read(taskRepositoryProvider).updateTask(updatedTask);
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Güncelleme hatası: $e")));
            }
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 22,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              "Tarih: ${getFormattedDate(task.date)}",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                ref.read(taskRepositoryProvider).deleteTask(task.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
