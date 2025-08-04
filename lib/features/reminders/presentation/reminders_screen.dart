import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'dart:typed_data';

import '../../../core/theme/app_theme.dart';
import '../providers/reminders_provider.dart';
import '../models/reminder_simple.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersState = ref.watch(remindersNotifierProvider);
    final pendingReminders = ref.watch(pendingRemindersProvider);
    final overdueReminders = ref.watch(overdueRemindersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Reminders'),
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Home',
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(remindersNotifierProvider.notifier).refreshReminders(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Reminders',
          ),
        ],
      ),
      body: remindersState.when(
        data: (reminders) => reminders.isEmpty 
          ? _buildEmptyState(context)
          : _buildRemindersContent(context, ref, reminders, pendingReminders, overdueReminders),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, error, ref),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.schedule_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Reminders Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first plant to create care reminders!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/plants'),
            icon: const Icon(Icons.local_florist),
            label: const Text('View My Plants'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.plantGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to Load Reminders',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.read(remindersNotifierProvider.notifier).refreshReminders(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersContent(
    BuildContext context, 
    WidgetRef ref, 
    List<ReminderSimple> allReminders,
    AsyncValue<List<ReminderSimple>> pendingReminders,
    AsyncValue<List<ReminderSimple>> overdueReminders,
  ) {
    return RefreshIndicator(
      onRefresh: () => ref.read(remindersNotifierProvider.notifier).refreshReminders(),
      child: CustomScrollView(
        slivers: [
          // Stats section
          SliverToBoxAdapter(
            child: _buildStatsSection(context, allReminders, pendingReminders, overdueReminders),
          ),
          
          // Overdue reminders section
          overdueReminders.when(
            data: (overdue) => overdue.isNotEmpty
              ? SliverToBoxAdapter(
                  child: _buildSectionHeader(context, 'Overdue', Colors.red, overdue.length),
                )
              : const SliverToBoxAdapter(child: SizedBox.shrink()),
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
          
          overdueReminders.when(
            data: (overdue) => overdue.isNotEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ReminderCard(
                      reminder: overdue[index],
                      onComplete: (reminder) => _completeReminder(context, ref, reminder),
                    ),
                    childCount: overdue.length,
                  ),
                )
              : const SliverToBoxAdapter(child: SizedBox.shrink()),
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
          
          // All reminders section
          SliverToBoxAdapter(
            child: _buildSectionHeader(context, 'All Reminders', AppTheme.plantGreen, allReminders.length),
          ),
          
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _ReminderCard(
                reminder: allReminders[index],
                onComplete: (reminder) => _completeReminder(context, ref, reminder),
              ),
              childCount: allReminders.length,
            ),
          ),
          
          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    List<ReminderSimple> allReminders,
    AsyncValue<List<ReminderSimple>> pendingReminders,
    AsyncValue<List<ReminderSimple>> overdueReminders,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              allReminders.length.toString(),
              AppTheme.plantGreen,
              Icons.schedule,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: pendingReminders.when(
              data: (pending) => _buildStatCard(
                'Pending',
                pending.length.toString(),
                Colors.orange,
                Icons.pending_actions,
              ),
              loading: () => _buildStatCard('Pending', '...', Colors.orange, Icons.pending_actions),
              error: (_, __) => _buildStatCard('Pending', '0', Colors.orange, Icons.pending_actions),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: overdueReminders.when(
              data: (overdue) => _buildStatCard(
                'Overdue',
                overdue.length.toString(),
                Colors.red,
                Icons.warning,
              ),
              loading: () => _buildStatCard('Overdue', '...', Colors.red, Icons.warning),
              error: (_, __) => _buildStatCard('Overdue', '0', Colors.red, Icons.warning),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, Color color, int count) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 8),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _completeReminder(BuildContext context, WidgetRef ref, ReminderSimple reminder) async {
    try {
      await ref.read(remindersNotifierProvider.notifier).completeReminder(reminder.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Completed: ${reminder.title}'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                // Could navigate to plant detail or reminder history
              },
            ),
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
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.reminder,
    required this.onComplete,
  });

  final ReminderSimple reminder;
  final Function(ReminderSimple) onComplete;

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: reminder.isOverdue ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: reminder.isOverdue 
            ? BorderSide(color: Colors.red.withOpacity(0.5), width: 1)
            : BorderSide.none,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: reminder.completed
              ? LinearGradient(
                  colors: [Colors.grey[100]!, Colors.grey[50]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Type icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getTypeIcon(),
                    color: priorityColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Plant image (if available)
                if (reminder.plantFirstImage.isNotEmpty) ...[
                  _buildPlantImage(),
                  const SizedBox(width: 12),
                ],
                
                // Reminder info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              reminder.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: reminder.completed ? TextDecoration.lineThrough : null,
                                color: reminder.completed ? Colors.grey[600] : null,
                              ),
                            ),
                          ),
                          if (reminder.recurring) ...[
                            Icon(
                              Icons.repeat,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reminder.plantName,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: priorityColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            reminder.formattedDueDate,
                            style: TextStyle(
                              color: priorityColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              reminder.typeDisplayName,
                              style: TextStyle(
                                color: priorityColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (reminder.description != null && reminder.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          reminder.description!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Action button
                if (!reminder.completed) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => onComplete(reminder),
                    icon: const Icon(Icons.check_circle_outline),
                    color: Colors.green,
                    tooltip: 'Mark as Complete',
                  ),
                ] else ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlantImage() {
    try {
      final bytes = base64Decode(reminder.plantFirstImage);
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.memory(
          bytes,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      );
    } catch (e) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey[300],
        ),
        child: const Icon(
          Icons.local_florist,
          color: Colors.grey,
          size: 20,
        ),
      );
    }
  }

  Color _getPriorityColor() {
    if (reminder.completed) return Colors.grey;
    if (reminder.isOverdue) return Colors.red;
    if (reminder.isDueToday) return Colors.orange;
    if (reminder.isDueTomorrow) return Colors.blue;
    return Colors.grey[600]!;
  }

  IconData _getTypeIcon() {
    switch (reminder.type) {
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
} 