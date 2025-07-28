import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/services/ai_service.dart';

class DiagnosisResult extends StatelessWidget {
  const DiagnosisResult({
    super.key,
    required this.result,
    required this.onRetake,
  });

  final PlantDiagnosisResult result;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    final healthScore = result.overallHealthScore;
    final healthColor = _getHealthColor(healthScore);
    final healthStatus = _getHealthStatus(healthScore);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Health Score Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [healthColor.withOpacity(0.1), healthColor.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: healthColor.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Text(
                  'Plant Health Score',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: healthScore,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(healthColor),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${(healthScore * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: healthColor,
                          ),
                        ),
                        Text(
                          healthStatus,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Issues Found
          if (result.detectedIssues.isNotEmpty) ...[
            Text(
              'Issues Detected (${result.detectedIssues.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...result.detectedIssues.map((issue) => _IssueCard(issue: issue)),
          ] else ...[
            _HealthyPlantCard(),
          ],
          
          const SizedBox(height: 24),
          
          // General Recommendations
          if (result.generalRecommendations.isNotEmpty) ...[
            _InfoCard(
              title: 'General Recommendations',
              icon: Icons.lightbulb_outline,
              children: [
                ...result.generalRecommendations.map((recommendation) => 
                  _BulletPoint(text: recommendation)
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRetake,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Scan Again'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppTheme.plantGreen),
                    foregroundColor: AppTheme.plantGreen,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Save diagnosis or navigate to detailed view
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Results'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.plantGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Color _getHealthColor(double score) {
    if (score >= 0.8) return AppTheme.successColor;
    if (score >= 0.6) return AppTheme.warningColor;
    return const Color(0xFFE57373); // Red for poor health
  }
  
  String _getHealthStatus(double score) {
    if (score >= 0.9) return 'Excellent';
    if (score >= 0.8) return 'Good';
    if (score >= 0.6) return 'Fair';
    if (score >= 0.4) return 'Poor';
    return 'Critical';
  }
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.issue});

  final Map<String, dynamic> issue;

  @override
  Widget build(BuildContext context) {
    final severity = issue['severity'] ?? 'moderate';
    final severityColor = _getSeverityColor(severity);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Issue Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  severity.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: severityColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (issue['confidence'] != null)
                Text(
                  '${(issue['confidence'] * 100).toInt()}% confident',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Issue Name
          Text(
            issue['name'] ?? 'Unknown Issue',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Description
          if (issue['description'] != null) ...[
            Text(
              issue['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
          ],
          
          // Treatments
          if (issue['treatments'] != null && (issue['treatments'] as List).isNotEmpty) ...[
            const Text(
              'Recommended Treatment:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...(issue['treatments'] as List).map((treatment) => 
              _TreatmentCard(treatment: treatment)
            ),
          ],
        ],
      ),
    );
  }
  
  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return const Color(0xFFE57373);
      case 'high':
        return const Color(0xFFFF8A65);
      case 'moderate':
        return AppTheme.warningColor;
      case 'low':
        return AppTheme.successColor;
      default:
        return AppTheme.warningColor;
    }
  }
}

class _TreatmentCard extends StatelessWidget {
  const _TreatmentCard({required this.treatment});

  final Map<String, dynamic> treatment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.lightGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            treatment['title'] ?? 'Treatment',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (treatment['description'] != null) ...[
            const SizedBox(height: 4),
            Text(
              treatment['description'],
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
          if (treatment['steps'] != null && (treatment['steps'] as List).isNotEmpty) ...[
            const SizedBox(height: 8),
            ...(treatment['steps'] as List).map((step) => 
              _BulletPoint(text: step, fontSize: 12)
            ),
          ],
        ],
      ),
    );
  }
}

class _HealthyPlantCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.successColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            size: 64,
            color: AppTheme.successColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'Plant Looks Healthy!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No significant issues detected. Keep up the good care!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.plantGreen),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({
    required this.text,
    this.fontSize = 14,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: EdgeInsets.only(top: fontSize / 2, right: 8),
            decoration: BoxDecoration(
              color: AppTheme.plantGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 