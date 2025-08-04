import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'dart:typed_data';

import '../../../core/theme/app_theme.dart';
import '../providers/diagnosis_provider.dart';
import '../models/diagnosis_database.dart';

class DiagnosisDetailScreen extends ConsumerWidget {
  const DiagnosisDetailScreen({super.key, required this.diagnosisId});
  
  final String diagnosisId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosesState = ref.watch(diagnosisNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis Details'),
        backgroundColor: const Color(0xFF121212),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: diagnosesState.when(
        data: (diagnoses) {
          final diagnosis = diagnoses.firstWhere(
            (d) => d.id == diagnosisId,
            orElse: () => throw Exception('Diagnosis not found'),
          );
          return _buildDiagnosisDetail(context, diagnosis);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildDiagnosisDetail(BuildContext context, DiagnosisRecord diagnosis) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(context, diagnosis),
          const SizedBox(height: 20),
          if (diagnosis.images.isNotEmpty) ...[
            _buildImagesSection(diagnosis),
            const SizedBox(height: 20),
          ],
          if (diagnosis.hasLinkedPlant) ...[
            _buildLinkedPlantSection(diagnosis),
            const SizedBox(height: 20),
          ],
          _buildHealthAssessmentSection(context, diagnosis),
          const SizedBox(height: 20),
          if (diagnosis.healthIssues.isNotEmpty) ...[
            _buildIssuesSection(context, diagnosis),
            const SizedBox(height: 20),
          ],
          _buildCareRecommendationsSection(context, diagnosis),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, DiagnosisRecord diagnosis) {
    final overallHealth = diagnosis.overallHealth;
    Color healthColor = _getHealthColor(overallHealth);

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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: healthColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.health_and_safety,
                    color: healthColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Health',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        overallHealth.toUpperCase(),
                        style: TextStyle(
                          color: healthColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Date',
              diagnosis.createdAt != null 
                  ? _formatDate(diagnosis.createdAt!)
                  : 'Unknown',
            ),
            if (diagnosis.healthConfidence > 0) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                'Confidence',
                '${(diagnosis.healthConfidence * 100).toInt()}%',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImagesSection(DiagnosisRecord diagnosis) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF2A2A2A),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diagnosis Images',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: diagnosis.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: _buildDiagnosisImage(diagnosis.images[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedPlantSection(DiagnosisRecord diagnosis) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF2A2A2A),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.link, color: AppTheme.plantGreen, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Linked Plant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Name', diagnosis.plantName),
            if (diagnosis.plantScientificName.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow('Scientific Name', diagnosis.plantScientificName),
            ],
            if (diagnosis.plantSpecies.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow('Species', diagnosis.plantSpecies),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHealthAssessmentSection(BuildContext context, DiagnosisRecord diagnosis) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF2A2A2A),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Assessment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Status', diagnosis.overallHealth),
            if (diagnosis.healthConfidence > 0) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                'Confidence',
                '${(diagnosis.healthConfidence * 100).toInt()}%',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIssuesSection(BuildContext context, DiagnosisRecord diagnosis) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF2A2A2A),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: AppTheme.warningColor, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Detected Issues',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...diagnosis.healthIssues.map((issue) {
              final issueMap = issue as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.warningColor.withOpacity(0.3),
                  ),
                  color: AppTheme.warningColor.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      issueMap['type'] ?? 'Unknown Issue',
                      style: TextStyle(
                        color: AppTheme.warningColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (issueMap['description'] != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        issueMap['description'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (issueMap['severity'] != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Severity: ${issueMap['severity']}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCareRecommendationsSection(BuildContext context, DiagnosisRecord diagnosis) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF2A2A2A),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.healing, color: AppTheme.plantGreen, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Care Recommendations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (diagnosis.immediateActions.isNotEmpty) ...[
              _buildRecommendationSubsection('Immediate Actions', diagnosis.immediateActions, Colors.red[300]!),
              const SizedBox(height: 16),
            ],
            if (diagnosis.ongoingCare.isNotEmpty) ...[
              _buildRecommendationSubsection('Ongoing Care', diagnosis.ongoingCare, Colors.orange[300]!),
              const SizedBox(height: 16),
            ],
            if (diagnosis.preventiveCare.isNotEmpty) ...[
              _buildRecommendationSubsection('Preventive Care', diagnosis.preventiveCare, AppTheme.plantGreen),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationSubsection(String title, List<dynamic> recommendations, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...recommendations.map((rec) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    rec.toString(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDiagnosisImage(String base64Image) {
    try {
      final bytes = base64Decode(base64Image);
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          bytes,
          width: 150,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    } catch (e) {
      return Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[800],
        ),
        child: const Center(
          child: Icon(
            Icons.broken_image,
            color: Colors.grey,
            size: 32,
          ),
        ),
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
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
          const Text(
            'Diagnosis Not Found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}