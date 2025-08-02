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
    final primaryColor = isIdentify ? AppTheme.lightGreen : AppTheme.successColor;
    
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main action icon with modern design
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    primaryColor.withOpacity(0.1),
                    primaryColor.withOpacity(0.05),
                    Colors.transparent,
                  ],
                  stops: const [0.4, 0.7, 1.0],
                ),
                borderRadius: BorderRadius.circular(70),
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  isIdentify ? Icons.search : Icons.health_and_safety,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Title
            Text(
              isIdentify ? 'Identify Your Plant' : 'Check Plant Health',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // Instructions with better layout
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Text(
                isIdentify
                    ? 'Take a clear photo of the plant, including leaves and any flowers or fruits. Make sure the lighting is good and the plant fills most of the frame.'
                    : 'Focus on any problematic areas like discolored leaves, spots, or signs of damage. Good lighting will help our AI detect issues more accurately.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.onSurfaceVariant(context),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            
            // Action Buttons with modern design
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.camera_alt,
                    label: 'Take Photo',
                    color: primaryColor,
                    isPrimary: true,
                    onPressed: () => onTakePhoto(action),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.photo_library,
                    label: 'From Gallery',
                    color: primaryColor,
                    isPrimary: false,
                    onPressed: () => onPickFromGallery(action),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Tips section with modern design
            _TipsSection(isIdentify: isIdentify),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isPrimary,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool isPrimary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
          shadowColor: color.withOpacity(0.4),
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: 2),
          backgroundColor: color.withOpacity(0.05),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    }
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
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.warningColor.withOpacity(0.05),
            AppTheme.warningColor.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.warningColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  size: 20,
                  color: AppTheme.warningColor,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Tips for better results',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.warningColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.onSurfaceVariant(context),
                          height: 1.4,
                          fontWeight: FontWeight.w500,
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