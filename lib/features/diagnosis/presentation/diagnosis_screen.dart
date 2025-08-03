import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'dart:typed_data';

import '../../../core/theme/app_theme.dart';
import '../providers/diagnosis_provider.dart';
import '../models/diagnosis_database.dart';

class DiagnosisScreen extends ConsumerWidget {
  const DiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosesState = ref.watch(diagnosisNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Diagnoses'),
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Home',
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(diagnosisNotifierProvider.notifier).refreshDiagnoses(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Diagnoses',
          ),
        ],
      ),
      body: diagnosesState.when(
        data: (diagnoses) => diagnoses.isEmpty 
          ? _buildEmptyState(context)
          : _buildDiagnosesList(diagnoses, ref),
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
            Icons.health_and_safety_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Diagnoses Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by taking a photo to diagnose your plant\'s health!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/camera'),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Diagnose Plant Health'),
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
            'Failed to Load Diagnoses',
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
            onPressed: () => ref.read(diagnosisNotifierProvider.notifier).refreshDiagnoses(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosesList(List<DiagnosisRecord> diagnoses, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(diagnosisNotifierProvider.notifier).refreshDiagnoses(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: diagnoses.length,
        itemBuilder: (context, index) => _DiagnosisCard(diagnosis: diagnoses[index]),
      ),
    );
  }
}

class _DiagnosisCard extends StatelessWidget {
  const _DiagnosisCard({required this.diagnosis});

  final DiagnosisRecord diagnosis;

  @override
  Widget build(BuildContext context) {
    final healthAssessment = diagnosis.aiAnalysis['health_assessment'] as Map<String, dynamic>? ?? {};
    final overallHealth = healthAssessment['overall_health']?.toString() ?? 'unknown';
    final plantId = diagnosis.aiAnalysis['plant_identification'] as Map<String, dynamic>? ?? {};
    
    // Use linked plant name if available, otherwise fall back to AI identification
    final plantName = diagnosis.hasLinkedPlant 
        ? diagnosis.plantName 
        : (plantId['species']?.toString() ?? 'Unknown plant');
    final scientificName = diagnosis.hasLinkedPlant 
        ? diagnosis.plantScientificName 
        : (plantId['scientific_name']?.toString() ?? '');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF3E3E3E),
              const Color(0xFF4A4A4A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getHealthColor(overallHealth).withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getHealthColor(overallHealth),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      overallHealth.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(diagnosis.createdAt ?? DateTime.now()),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                plantName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (scientificName.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  scientificName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
              ],
              if (diagnosis.hasLinkedPlant) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.link,
                      size: 16,
                      color: AppTheme.plantGreen.withOpacity(0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Linked to saved plant',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.plantGreen.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              
              // Show diagnosis images if available
              if (diagnosis.images.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: diagnosis.images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.plantGreen.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildDiagnosisImage(diagnosis.images[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
              
              if (diagnosis.aiAnalysis['health_assessment']?['summary'] != null)
                Text(
                  diagnosis.aiAnalysis['health_assessment']['summary'].toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getHealthColor(String health) {
    switch (health.toLowerCase()) {
      case 'healthy':
      case 'good':
        return Colors.green;
      case 'moderate':
      case 'fair':
        return Colors.orange;
      case 'poor':
      case 'bad':
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
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

  Widget _buildDiagnosisImage(String imageData) {
    try {
      // Handle base64 images
      String base64String = imageData;
      if (imageData.contains(',')) {
        base64String = imageData.split(',').last;
      }
      
      final Uint8List bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[800],
            child: Icon(
              Icons.broken_image,
              color: Colors.grey[600],
              size: 24,
            ),
          );
        },
      );
    } catch (e) {
      return Container(
        color: Colors.grey[800],
        child: Icon(
          Icons.broken_image,
          color: Colors.grey[600],
          size: 24,
        ),
      );
    }
  }
} 