import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/plants_provider.dart';
import '../models/plant.dart';
import '../../diagnosis/providers/diagnosis_provider.dart';
import '../../diagnosis/models/diagnosis_database.dart';
import '../../reminders/widgets/create_reminder_dialog.dart';
import '../../reminders/providers/reminders_provider.dart';
import '../../reminders/models/reminder_simple.dart';

class PlantDetailScreen extends ConsumerWidget {
  const PlantDetailScreen({
    super.key,
    required this.plantId,
  });

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantState = ref.watch(plantProvider(plantId));
    final diagnosesState = ref.watch(plantDiagnosesProvider(plantId));
    final plantRemindersState = ref.watch(plantRemindersProvider(plantId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: plantState.when(
        data: (plant) {
          if (plant == null) {
            return _buildPlantNotFound(context);
          }
          return _buildPlantDetails(context, ref, plant, diagnosesState, plantRemindersState);
        },
        loading: () => _buildLoading(),
        error: (error, stack) => _buildError(context, error),
      ),
    );
  }

  Widget _buildPlantNotFound(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plant Not Found')),
      body: const Center(child: Text('Plant not found')),
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading...')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Error: $error')),
    );
  }

  Widget _buildPlantDetails(
    BuildContext context, 
    WidgetRef ref, 
    Plant plant, 
    AsyncValue<List<DiagnosisRecord>> diagnosesState,
    AsyncValue<List<ReminderSimple>> plantRemindersState,
  ) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(plant.name),
            background: plant.images.isNotEmpty
                ? _buildPlantImage(plant.images.first)
                : Container(color: AppTheme.plantGreen),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlantInfoSection(plant),
                const SizedBox(height: 24),
                if (plant.careInstructions != null) ...[
                  _buildCareInstructionsSection(plant),
                  const SizedBox(height: 24),
                ],
                _buildDiagnosesSection(context, plant, diagnosesState),
            const SizedBox(height: 20),
            _buildRemindersSection(context, ref, plant, plantRemindersState),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlantImage(String imageData) {
    try {
      String base64String = imageData;
      if (imageData.contains(',')) {
        base64String = imageData.split(',').last;
      }
      final Uint8List bytes = base64Decode(base64String);
      return Image.memory(bytes, fit: BoxFit.cover);
    } catch (e) {
      return Container(color: AppTheme.plantGreen);
    }
  }

  Widget _buildPlantInfoSection(Plant plant) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2A2A2A),
              const Color(0xFF3A3A3A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.plantGreen, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Plant Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (plant.scientificName?.isNotEmpty == true) ...[
              _buildInfoRow('Scientific Name', plant.scientificName!, Icons.science),
              const SizedBox(height: 12),
            ],
            
            if (plant.species?.isNotEmpty == true) ...[
              _buildInfoRow('Species', plant.species!, Icons.category),
              const SizedBox(height: 12),
            ],
            
            if (plant.confidence != null) ...[
              _buildInfoRow(
                'Identification Confidence', 
                '${(plant.confidence! * 100).toStringAsFixed(1)}%', 
                Icons.verified
              ),
              const SizedBox(height: 12),
            ],

            if (plant.description?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.description,
                    color: AppTheme.plantGreen.withOpacity(0.8),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.plantGreen.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plant.description!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            if (plant.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.local_offer,
                    color: AppTheme.plantGreen.withOpacity(0.8),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tags',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.plantGreen.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: plant.tags.map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.plantGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.plantGreen.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: AppTheme.plantGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppTheme.plantGreen.withOpacity(0.8),
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.plantGreen.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCareInstructionsSection(Plant plant) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Care Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...plant.careInstructions!.entries.map((entry) {
              if (entry.value is Map<String, dynamic>) {
                final careData = entry.value as Map<String, dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${entry.key}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ...careData.entries.map((e) => Text('  ${e.key}: ${e.value}')),
                    const SizedBox(height: 8),
                  ],
                );
              }
              return Text('${entry.key}: ${entry.value}');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosesSection(BuildContext context, Plant plant, AsyncValue<List<DiagnosisRecord>> diagnosesState) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2A2A2A),
              const Color(0xFF3A3A3A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety, color: AppTheme.warningColor, size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Health History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Flexible(
                  child: TextButton.icon(
                    onPressed: () => context.go('/camera?action=diagnose'),
                    icon: const Icon(Icons.add_circle_outline, size: 16),
                    label: const Text(
                      'New',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.warningColor,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      minimumSize: const Size(0, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            diagnosesState.when(
              data: (diagnoses) {
                if (diagnoses.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.health_and_safety_outlined,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No Health Checks Yet',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start monitoring ${plant.name}\'s health',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return Column(
                  children: diagnoses.take(3).map((diagnosis) => _buildDiagnosisCard(context, diagnosis)).toList(),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Failed to load health history',
                  style: TextStyle(color: Colors.red[400]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisCard(BuildContext context, DiagnosisRecord diagnosis) {
    final overallHealth = diagnosis.overallHealth;
    
    Color healthColor;
    switch (overallHealth.toLowerCase()) {
      case 'healthy':
      case 'good':
        healthColor = Colors.green;
        break;
      case 'moderate':
      case 'fair':
        healthColor = Colors.orange;
        break;
      case 'poor':
      case 'bad':
      case 'critical':
        healthColor = Colors.red;
        break;
      default:
        healthColor = Colors.grey;
    }

    return GestureDetector(
      onTap: () => context.go('/diagnosis/${diagnosis.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: healthColor.withOpacity(0.3),
            width: 1,
          ),
          color: const Color(0xFF1E1E1E),
        ),
        child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: healthColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.favorite,
              color: healthColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overallHealth.toUpperCase(),
                  style: TextStyle(
                    color: healthColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  diagnosis.createdAt != null 
                      ? _formatDate(diagnosis.createdAt!)
                      : 'Unknown date',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                if (diagnosis.healthIssues.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${diagnosis.healthIssues.length} issue(s) detected',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (diagnosis.images.isNotEmpty) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: healthColor.withOpacity(0.3),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: _buildPlantImage(diagnosis.images.first),
              ),
            ),
          ],
        ],
        ),
      ),
    );
  }

  Widget _buildRemindersSection(
    BuildContext context, 
    WidgetRef ref, 
    Plant plant, 
    AsyncValue<List<ReminderSimple>> plantRemindersState,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2A2A2A),
              const Color(0xFF3A3A3A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.schedule, color: AppTheme.warningColor, size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Care Reminders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Flexible(
                  child: TextButton.icon(
                    onPressed: () => _showCreateReminderDialog(context, ref, plant),
                    icon: const Icon(Icons.add_circle_outline, size: 16),
                    label: const Text(
                      'Add',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.warningColor,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      minimumSize: const Size(0, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            plantRemindersState.when(
              data: (reminders) {
                if (reminders.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No Reminders Set',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create reminders to keep ${plant.name} healthy',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                
                // Show pending reminders first, then completed
                final pendingReminders = reminders.where((r) => !r.completed).toList();
                final completedReminders = reminders.where((r) => r.completed).toList();
                
                return Column(
                  children: [
                    if (pendingReminders.isNotEmpty) ...[
                      ...pendingReminders.take(3).map((reminder) => _buildReminderCard(context, ref, reminder)),
                      if (pendingReminders.length > 3) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => context.go('/reminders'),
                          child: Text(
                            'View all ${pendingReminders.length} reminders',
                            style: TextStyle(color: AppTheme.warningColor),
                          ),
                        ),
                      ],
                    ],
                    if (completedReminders.isNotEmpty && pendingReminders.isEmpty) ...[
                      ...completedReminders.take(2).map((reminder) => _buildReminderCard(context, ref, reminder)),
                    ],
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to Load Reminders',
                      style: TextStyle(
                        color: Colors.red[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.refresh(plantRemindersProvider(plant.id)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context, WidgetRef ref, ReminderSimple reminder) {
    final priorityColor = _getReminderPriorityColor(reminder);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: priorityColor.withOpacity(0.3),
        ),
        color: const Color(0xFF1E1E1E),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getReminderTypeIcon(reminder.type),
              color: priorityColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    decoration: reminder.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 12,
                      color: priorityColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      reminder.formattedDueDate,
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (reminder.recurring) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.repeat,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (!reminder.completed) ...[
            IconButton(
              onPressed: () => _completeReminder(context, ref, reminder),
              icon: const Icon(Icons.check_circle_outline),
              color: Colors.green,
              iconSize: 20,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ] else ...[
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }

  Color _getReminderPriorityColor(ReminderSimple reminder) {
    if (reminder.completed) return Colors.grey;
    if (reminder.isOverdue) return Colors.red;
    if (reminder.isDueToday) return Colors.orange;
    if (reminder.isDueTomorrow) return Colors.blue;
    return Colors.grey[400]!;
  }

  IconData _getReminderTypeIcon(String type) {
    switch (type) {
      case 'watering':
        return Icons.water_drop;
      case 'fertilizing':
        return Icons.eco;
      case 'health_check':
        return Icons.health_and_safety;
      case 'repotting':
        return Icons.agriculture;
      case 'custom':
        return Icons.star;
      default:
        return Icons.schedule;
    }
  }

  Future<void> _showCreateReminderDialog(BuildContext context, WidgetRef ref, Plant plant) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => CreateReminderDialog(plant: plant),
    );
    
    if (result == true) {
      // Refresh reminders after successful creation
      ref.refresh(plantRemindersProvider(plant.id));
    }
  }

  Future<void> _completeReminder(BuildContext context, WidgetRef ref, ReminderSimple reminder) async {
    try {
      await ref.read(remindersNotifierProvider.notifier).completeReminder(reminder.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Completed: ${reminder.title}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete reminder: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
