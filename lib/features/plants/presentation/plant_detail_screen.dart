import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class PlantDetailScreen extends ConsumerWidget {
  const PlantDetailScreen({
    super.key,
    required this.plantId,
  });

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Details'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_florist,
              size: 64,
              color: AppTheme.plantGreen,
            ),
            const SizedBox(height: 16),
            const Text(
              'Plant Detail Screen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Plant ID: $plantId',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
} 