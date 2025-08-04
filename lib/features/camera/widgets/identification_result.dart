import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/services/ai_service.dart';
import '../../plants/models/plant.dart';

class IdentificationResult extends StatelessWidget {
  const IdentificationResult({
    super.key,
    required this.result,
    required this.plant,
    required this.onSave,
    required this.onRetake,
  });

  final PlantIdentificationResult result;
  final Plant plant;
  final VoidCallback onSave;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1A1A),
            const Color(0xFF2D2D2D),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                      // Success Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4CAF50),
                  const Color(0xFF66BB6A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Plant Identified Successfully!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
            const SizedBox(height: 24),
            
            // Plant Information
            _InfoCard(
              title: 'Plant Information',
              children: [
                _InfoRow(
                  label: 'Common Name',
                  value: result.name.isNotEmpty ? result.name : 'Unknown',
                  icon: Icons.local_florist,
                ),
                _InfoRow(
                  label: 'Scientific Name',
                  value: result.scientificName.isNotEmpty ? result.scientificName : 'Not available',
                  icon: Icons.science,
                ),
                _InfoRow(
                  label: 'Category',
                  value: result.category.isNotEmpty ? result.category : 'Unknown',
                  icon: Icons.category,
                ),
                _InfoRow(
                  label: 'Confidence',
                  value: result.confidence > 0 ? '${(result.confidence * 100).toStringAsFixed(1)}%' : 'Unknown',
                  icon: Icons.trending_up,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Description
            if (result.description.isNotEmpty) ...[
              _InfoCard(
                title: 'Description',
                children: [
                                  Text(
                  result.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.white,
                  ),
                ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // Care Information
            if (result.careInfo.isNotEmpty) ...[
              _InfoCard(
                title: 'Care Information',
                children: [
                  if (result.careInfo['lightRequirement'] != null)
                    _InfoRow(
                      label: 'Light',
                      value: result.careInfo['lightRequirement'].toString(),
                      icon: Icons.wb_sunny,
                    ),
                  if (result.careInfo['wateringFrequency'] != null)
                    _InfoRow(
                      label: 'Watering',
                      value: result.careInfo['wateringFrequency'].toString(),
                      icon: Icons.water_drop,
                    ),
                  if (result.careInfo['humidity'] != null)
                    _InfoRow(
                      label: 'Humidity',
                      value: result.careInfo['humidity'].toString(),
                      icon: Icons.air,
                    ),
                  if (result.careInfo['temperature'] != null)
                    _InfoRow(
                      label: 'Temperature',
                      value: result.careInfo['temperature'].toString(),
                      icon: Icons.thermostat,
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // Tags
            if (result.tags.isNotEmpty) ...[
              _InfoCard(
                title: 'Tags',
                children: [
                  Container(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 12,
                      runSpacing: 12,
                      children: result.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF66BB6A).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF66BB6A),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
            
            // Auto-Created Reminders Notification
            if (result.suggestedReminders.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  border: Border.all(
                    color: const Color(0xFF2196F3).withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      color: Color(0xFF2196F3),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Care Reminders Created',
                            style: TextStyle(
                              color: Color(0xFF2196F3),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${result.suggestedReminders.length} automatic reminders added: ${result.suggestedReminders.map((r) => r.type).join(', ')}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            // Action Buttons
            Row(
              children: [
                              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRetake,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Retake Photo'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFF66BB6A), width: 2),
                    foregroundColor: const Color(0xFF66BB6A),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save),
                  label: const Text('Save to Collection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66BB6A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 8,
                    shadowColor: const Color(0xFF66BB6A).withOpacity(0.3),
                  ),
                ),
              ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3E3E3E),
            const Color(0xFF4A4A4A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF5E5E5E),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF66BB6A),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF66BB6A),
          ),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}