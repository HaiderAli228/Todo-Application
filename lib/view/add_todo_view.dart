import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/database.dart';

import '../utlis/app_color.dart';
import '../view-model/provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  String _selectedPriority = 'Medium';
  DateTime? _selectedDateTime;

  final dbHelper = DatabaseHelper.instance;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    // 1) pick a date
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    // 2) pick a time
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay.fromDateTime(_selectedDateTime!)
          : TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _saveTodo() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<NotesProvider>();
    bool success = await provider.addProviderNotes(
      title: _titleController.text.trim(),
      priority: _selectedPriority,
      reminder: _selectedDateTime?.millisecondsSinceEpoch,
    );

    if (success) {
      Navigator.of(context).pop(true); // pop and signal success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add todo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Todo'),
        backgroundColor: AppColors.themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 16),

              // Priority dropdown
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                items: ['Low', 'Medium', 'High']
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedPriority = val);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Reminder picker
              InkWell(
                onTap: _pickDateTime,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Reminder Time',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _selectedDateTime == null
                        ? 'Tap to select date & time'
                        : DateFormat('yyyy-MM-dd – HH:mm')
                            .format(_selectedDateTime!),
                  ),
                ),
              ),
              const Spacer(),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveTodo,
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
