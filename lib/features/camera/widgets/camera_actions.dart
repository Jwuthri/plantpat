import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/camera_provider.dart';

class CameraActions extends StatelessWidget {
  const CameraActions({
    super.key,
    required this.action,
    required this.onTakePhoto,
    required this.onPickFromGallery,
  });

  final CameraAction action;
  final Function(CameraAction) onTakePhoto;
  final Function(CameraAction) onPickFromGallery;

  @override
  Widget build(BuildContext context) {
    final isIdentify = action == CameraAction.identify;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Camera Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.plantGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: AppTheme.plantGreen.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              isIdentify ? Icons.search : Icons.health_and_safety,
              size: 48,
              color: AppTheme.plantGreen,
            ),
          ),
          const SizedBox(height: 32),
          
          // Instructions
          Text(
            isIdentify ? 'Identify Your Plant' : 'Check Plant Health',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.plantGreen,
            ),
          ),
          const SizedBox(height: 12),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              isIdentify
                  ? 'Take a clear photo of the plant, including leaves and any flowers or fruits. Make sure the lighting is good and the plant fills most of the frame.'
                  : 'Focus on any problematic areas like discolored leaves, spots, or signs of damage. Good lighting will help our AI detect issues more accurately.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 48),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.camera_alt,
                  label: 'Take Photo',
                  color: AppTheme.plantGreen,
                  onPressed: () => onTakePhoto(action),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ActionButton(
                  icon: Icons.photo_library,
                  label: 'From Gallery',
                  color: AppTheme.lightGreen,
                  onPressed: () => onPickFromGallery(action),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Tips
          _TipsSection(isIdentify: isIdentify),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }
}

class _TipsSection extends StatelessWidget {
  const _TipsSection({required this.isIdentify});

  final bool isIdentify;

  @override
  Widget build(BuildContext context) {
    final tips = isIdentify
        ? [
            'Include leaves, stems, and flowers if visible',
            'Ensure good lighting (natural light works best)',
            'Get close enough to see details clearly',
            'Avoid blurry or dark photos',
          ]
        : [
            'Focus on affected areas (spots, discoloration)',
            'Show both healthy and unhealthy parts',
            'Take multiple angles if needed',
            'Capture any visible pests or damage',
          ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: AppTheme.warningColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Tips for better results',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 8, right: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.plantGreen,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
} 