class TodoModel {
  final int? id;
  final String title;
  final String priority;
  final int? reminderTime;
  final bool status;

  TodoModel(
      {this.id,
      required this.title,
      required this.priority,
      this.reminderTime,
      this.status = false});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "priority": priority,
      "reminder_time": reminderTime,
      "status": status ? 1 : 0,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      priority: map['priority'],
      reminderTime: map['reminder_time'],
      status: map['status'] == 1,
    );
  }
}
