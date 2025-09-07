import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not/presentation/features/tasks/models/task.dart';
import 'package:not/presentation/features/tasks/repository/task_provider.dart';
import 'package:not/presentation/features/tasks/widgets/task_card.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final taskRepo = ref.watch(taskRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Takvim")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: taskRepo.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Hata: ${snapshot.error}"));
                }

                final allTasks = snapshot.data ?? [];

                // seçilen günün görevleri
                final filteredTasks = allTasks.where((task) {
                  return _selectedDay != null &&
                      isSameDay(task.date, _selectedDay);
                }).toList();

                if (filteredTasks.isEmpty) {
                  return const Center(child: Text("Bu günde görev yok"));
                }

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TaskCard(task: filteredTasks[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
