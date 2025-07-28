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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.successColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppTheme.successColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Plant Identified Successfully!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
                value: result.name,
                icon: Icons.local_florist,
              ),
              _InfoRow(
                label: 'Scientific Name',
                value: result.scientificName,
                icon: Icons.science,
              ),
              _InfoRow(
                label: 'Category',
                value: result.category,
                icon: Icons.category,
              ),
              _InfoRow(
                label: 'Confidence',
                value: '${(result.confidence * 100).toStringAsFixed(1)}%',
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
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: result.tags.map((tag) => Chip(
                    label: Text(
                      tag,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: AppTheme.lightGreen.withOpacity(0.2),
                    side: BorderSide(
                      color: AppTheme.lightGreen.withOpacity(0.5),
                    ),
                  )).toList(),
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
                  label: const Text('Retake Photo'),
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
                  onPressed: onSave,
                  icon: const Icon(Icons.save),
                  label: const Text('Save to Collection'),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
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
            color: AppTheme.plantGreen,
          ),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 