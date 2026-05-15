import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../models/user_preferences.dart';

class GoalSettingScreen extends StatefulWidget {
  const GoalSettingScreen({Key? key}) : super(key: key);

  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen>
    with SingleTickerProviderStateMixin {
  String? selectedGoal;
  String selectedLearningType = 'chapter_wise';
  bool enableReminders = false;
  String reminderFrequency = 'daily';
  bool isLoading = false;

  late AnimationController _animationController;

  final Map<String, Map<String, String>> goalDescriptions = {
    'learn': {
      'title': 'Learn',
      'description': 'Build foundational knowledge across topics',
      'icon': '📚',
    },
    'understand': {
      'title': 'Understand',
      'description': 'Deep dive into concepts and principles',
      'icon': '🧠',
    },
    'teach': {
      'title': 'Teach',
      'description': 'Master topics to explain to others',
      'icon': '👨‍🏫',
    },
    'refer_project': {
      'title': 'Refer for Project',
      'description': 'Learn for practical project implementation',
      'icon': '🚀',
    },
  };

  final Map<String, String> learningTypeDescriptions = {
    'chapter_wise': 'Study chapter by chapter',
    'marks_wise': 'Focus on high-weightage topics',
    'custom': 'Create your own learning path',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _savePreferences() async {
    if (selectedGoal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a learning goal'),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final authService = context.read<AuthService>();
      final firestoreService = context.read<FirestoreService>();
      final userId = authService.currentUser?.uid;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final preferences = UserPreferences(
        goal: selectedGoal!,
        learningType: selectedLearningType,
        enableReminders: enableReminders,
        reminderFrequency: reminderFrequency,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await firestoreService.saveUserPreferences(userId, preferences);

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/university_selection');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving preferences: $e'),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: FadeTransition(
                opacity: _animationController,
                child: const Text(
                  'Customize Your Learning',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryPurple.withOpacity(0.1),
                      AppColors.primaryBlue.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Goal Selection Section
                  _buildSectionHeader('What is your primary goal?'),
                  const SizedBox(height: 16),
                  _buildGoalSelector(),
                  const SizedBox(height: 32),

                  // Learning Type Section
                  _buildSectionHeader('How would you like to learn?'),
                  const SizedBox(height: 16),
                  _buildLearningTypeSelector(),
                  const SizedBox(height: 32),

                  // Reminders Section
                  _buildSectionHeader('Study Reminders'),
                  const SizedBox(height: 12),
                  _buildReminderToggle(),
                  if (enableReminders) ...[
                    const SizedBox(height: 16),
                    _buildReminderFrequencyDropdown(),
                  ],
                  const SizedBox(height: 40),

                  // Continue Button
                  _buildContinueButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildGoalSelector() {
    return Column(
      children: goalDescriptions.entries.map((entry) {
        final key = entry.key;
        final data = entry.value;
        final isSelected = selectedGoal == key;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => setState(() => selectedGoal = key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.primaryPurple : AppColors.borderGray,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? AppColors.primaryPurple.withOpacity(0.08)
                    : AppColors.cardBackground,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected
                          ? AppColors.primaryPurple.withOpacity(0.2)
                          : AppColors.surface,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      data['icon']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title']!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['description']!,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryPurple,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLearningTypeSelector() {
    return Column(
      children: learningTypeDescriptions.entries.map((entry) {
        final key = entry.key;
        final description = entry.value;
        final isSelected = selectedLearningType == key;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => setState(() => selectedLearningType = key),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.primaryBlue : AppColors.borderGray,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? AppColors.primaryBlue.withOpacity(0.08)
                    : AppColors.cardBackground,
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Radio<String>(
                    value: key,
                    groupValue: selectedLearningType,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedLearningType = value);
                      }
                    },
                    activeColor: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReminderToggle() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGray),
        color: AppColors.cardBackground,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.notifications_outlined, color: AppColors.textGray),
          const SizedBox(width: 12),
          Expanded(
            child: const Text(
              'Enable study reminders',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          Switch(
            value: enableReminders,
            onChanged: (value) => setState(() => enableReminders = value),
            activeColor: AppColors.primaryPurple,
            inactiveThumbColor: AppColors.textGray,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderFrequencyDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGray),
        color: AppColors.cardBackground,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<String>(
        value: reminderFrequency,
        isExpanded: true,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: 'daily', child: Text('Daily')),
          DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
          DropdownMenuItem(value: 'biweekly', child: Text('Bi-weekly')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() => reminderFrequency = value);
          }
        },
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _savePreferences,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          disabledBackgroundColor: AppColors.textGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
