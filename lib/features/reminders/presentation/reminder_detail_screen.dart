import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../models/reminder_simple.dart';
import '../providers/reminders_provider.dart';
import '../../plants/models/plant.dart';
import '../../plants/providers/plants_provider.dart';

class ReminderDetailScreen extends ConsumerStatefulWidget {
  final String reminderId;

  const ReminderDetailScreen({
    super.key,
    required this.reminderId,
  });

  @override
  ConsumerState<ReminderDetailScreen> createState() => _ReminderDetailScreenState();
}

class _ReminderDetailScreenState extends ConsumerState<ReminderDetailScreen> {
  bool _isCompleting = false;

  @override
  Widget build(BuildContext context) {
    final remindersAsync = ref.watch(remindersNotifierProvider);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: remindersAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load reminder',
                style: Theme.of(context).textTheme.titleLarge,
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
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
        data: (reminders) {
          final reminder = reminders.firstWhere(
            (r) => r.id == widget.reminderId,
            orElse: () => throw Exception('Reminder not found'),
          );
          
          return _buildReminderDetail(context, reminder);
        },
      ),
    );
  }

  Widget _buildReminderDetail(BuildContext context, ReminderSimple reminder) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, reminder),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(reminder),
                const SizedBox(height: 16),
                _buildPlantCard(reminder),
                const SizedBox(height: 16),
                _buildReminderInfo(reminder),
                const SizedBox(height: 24),
                _buildActionButtons(reminder),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, ReminderSimple reminder) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: _getTypeColor(reminder.type),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          reminder.typeDisplayName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getTypeColor(reminder.type),
                _getTypeColor(reminder.type).withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // Account for status bar
                Icon(
                  _getTypeIcon(reminder.type),
                  size: 48,
                  color: Colors.white.withOpacity(0.9),
                ),
                const SizedBox(height: 8),
                Text(
                  reminder.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(ReminderSimple reminder) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: reminder.completed ? Colors.green[100] : 
                       reminder.isOverdue ? Colors.red[100] : 
                       reminder.isDueToday ? Colors.orange[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                reminder.completed ? Icons.check_circle : 
                reminder.isOverdue ? Icons.warning : 
                reminder.isDueToday ? Icons.today : Icons.schedule,
                color: reminder.completed ? Colors.green[700] : 
                       reminder.isOverdue ? Colors.red[700] : 
                       reminder.isDueToday ? Colors.orange[700] : Colors.blue[700],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.completed ? 'Completed' : 
                    reminder.isOverdue ? 'Overdue' : 
                    reminder.isDueToday ? 'Due Today' : 'Upcoming',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: reminder.completed ? Colors.green[700] : 
                             reminder.isOverdue ? Colors.red[700] : 
                             reminder.isDueToday ? Colors.orange[700] : Colors.blue[700],
                    ),
                  ),
                  Text(
                    reminder.formattedDueDate,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantCard(ReminderSimple reminder) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: reminder.plantFirstImage.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: reminder.plantFirstImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.local_florist,
                          color: Colors.grey[400],
                          size: 30,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.local_florist,
                      color: Colors.grey[400],
                      size: 30,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.plantName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (reminder.plantSpecies.isNotEmpty)
                    Text(
                      reminder.plantSpecies,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderInfo(ReminderSimple reminder) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reminder Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Type', reminder.typeDisplayName),
            _buildInfoRow('Due Date', DateFormat('MMM d, y at h:mm a').format(reminder.dueDate)),
            if (reminder.description?.isNotEmpty == true)
              _buildInfoRow('Description', reminder.description!),
            if (reminder.recurring)
              _buildInfoRow('Recurring', reminder.recurringInterval ?? 'Yes'),
            _buildInfoRow('Created', DateFormat('MMM d, y').format(reminder.createdAt)),
            if (reminder.completedAt != null)
              _buildInfoRow('Completed', DateFormat('MMM d, y at h:mm a').format(reminder.completedAt!)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ReminderSimple reminder) {
    if (reminder.completed) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _markAsIncomplete(reminder),
          icon: const Icon(Icons.undo),
          label: const Text('Mark as Incomplete'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isCompleting ? null : () => _markAsComplete(reminder),
            icon: _isCompleting 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle),
            label: Text(_isCompleting ? 'Completing...' : 'Mark as Complete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => _snoozeReminder(reminder),
            icon: const Icon(Icons.snooze),
            label: const Text('Snooze for 1 hour'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _markAsComplete(ReminderSimple reminder) async {
    setState(() {
      _isCompleting = true;
    });

    try {
      await ref.read(remindersNotifierProvider.notifier).completeReminder(reminder.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${reminder.typeDisplayName} completed!'),
            backgroundColor: Colors.green[600],
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete reminder: $e'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }

  Future<void> _markAsIncomplete(ReminderSimple reminder) async {
    try {
      // TODO: Implement mark as incomplete in provider
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mark as incomplete - to be implemented'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update reminder: $e'),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  Future<void> _snoozeReminder(ReminderSimple reminder) async {
    try {
      // TODO: Implement snooze functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Snooze functionality - to be implemented'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to snooze reminder: $e'),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'watering':
        return Colors.blue[600]!;
      case 'fertilizing':
        return Colors.green[600]!;
      case 'health_check':
        return Colors.orange[600]!;
      case 'repotting':
        return Colors.brown[600]!;
      case 'custom':
        return Colors.purple[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'watering':
        return Icons.water_drop;
      case 'fertilizing':
        return Icons.eco;
      case 'health_check':
        return Icons.health_and_safety;
      case 'repotting':
        return Icons.local_florist;
      case 'custom':
        return Icons.task_alt;
      default:
        return Icons.notifications;
    }
  }
}