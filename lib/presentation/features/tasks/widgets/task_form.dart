import 'package:flutter/material.dart';

class TaskForm extends StatelessWidget {
  final List<String> taskTitles;
  final String? selectedTitle;
  final ValueChanged<String?> onTitleChanged;

  final TextEditingController descriptionController;

  final DateTime? selectedDate;
  final VoidCallback onPickDate;

  const TaskForm({
    super.key,
    required this.taskTitles,
    required this.selectedTitle,
    required this.onTitleChanged,
    required this.descriptionController,
    required this.selectedDate,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedTitle,
          decoration: InputDecoration(
            labelText: "Başlık Seçiniz",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: taskTitles
              .map(
                (title) => DropdownMenuItem(value: title, child: Text(title)),
              )
              .toList(),
          onChanged: onTitleChanged,
          validator: (value) => value == null ? "Başlık seçmek zorunlu" : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: "Açıklama",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: onPickDate,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: "Tarih",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              selectedDate != null
                  ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                  : "Tarih seçin",
            ),
          ),
        ),
      ],
    );
  }
}
