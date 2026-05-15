import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreferences {
  final String goal;
  final String learningType;
  final bool enableReminders;
  final String reminderFrequency;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserPreferences({
    required this.goal,
    required this.learningType,
    required this.enableReminders,
    required this.reminderFrequency,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'goal': goal,
      'learningType': learningType,
      'enableReminders': enableReminders,
      'reminderFrequency': reminderFrequency,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      goal: map['goal'] ?? '',
      learningType: map['learningType'] ?? 'chapter_wise',
      enableReminders: map['enableReminders'] ?? false,
      reminderFrequency: map['reminderFrequency'] ?? 'daily',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
