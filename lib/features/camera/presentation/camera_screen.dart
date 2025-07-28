import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/camera_provider.dart';
import '../widgets/camera_actions.dart';
import '../widgets/identification_result.dart';
import '../widgets/diagnosis_result.dart';

class CameraScreen extends ConsumerWidget {
  const CameraScreen({
    super.key,
    required this.action,
  });

  final String action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraControllerProvider);
    final cameraNotifier = ref.watch(cameraControllerProvider.notifier);

    final isIdentify = action == 'identify';
    final title = isIdentify ? 'Identify Plant' : 'Plant Health Check';
    final subtitle = isIdentify 
        ? 'Take a photo to identify plant species'
        : 'Scan leaves to diagnose health issues';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          onPressed: () {
            cameraNotifier.clearResults();
            context.go('/home');
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),

              // Camera Actions or Results
              Expanded(
                child: _buildContent(context, cameraState, cameraNotifier),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    CameraState state,
    CameraController notifier,
  ) {
    if (state.isLoading) {
      return _LoadingWidget(action: action);
    }

    if (state.errorMessage != null) {
      return _ErrorWidget(
        error: state.errorMessage!,
        onRetry: () => notifier.clearResults(),
      );
    }

    // Show identification result
    if (state.identificationResult != null && action == 'identify') {
      return IdentificationResult(
        result: state.identificationResult!,
        plant: state.identifiedPlant!,
        onSave: () async {
          await notifier.saveIdentifiedPlant();
          if (context.mounted) {
            context.go('/home');
          }
        },
        onRetake: () => notifier.clearResults(),
      );
    }

    // Show diagnosis result
    if (state.diagnosisResult != null && action == 'diagnose') {
      return DiagnosisResult(
        result: state.diagnosisResult!,
        onRetake: () => notifier.clearResults(),
      );
    }

    // Show camera actions
    return CameraActions(
      action: action == 'identify' ? CameraAction.identify : CameraAction.diagnose,
      onTakePhoto: (action) => notifier.takePhoto(action: action),
      onPickFromGallery: (action) => notifier.pickFromGallery(action: action),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({required this.action});

  final String action;

  @override
  Widget build(BuildContext context) {
    final isIdentify = action == 'identify';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.plantGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppTheme.plantGreen,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isIdentify ? 'Identifying plant...' : 'Analyzing plant health...',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.plantGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isIdentify 
                ? 'Our AI is recognizing the plant species'
                : 'Checking for diseases and health issues',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Processing steps
          _ProcessingSteps(isIdentify: isIdentify),
        ],
      ),
    );
  }
}

class _ProcessingSteps extends StatefulWidget {
  const _ProcessingSteps({required this.isIdentify});

  final bool isIdentify;

  @override
  State<_ProcessingSteps> createState() => _ProcessingStepsState();
}

class _ProcessingStepsState extends State<_ProcessingSteps>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  int _currentStep = 0;

  final List<String> _identifySteps = [
    'Analyzing image features',
    'Comparing with plant database',
    'Generating care instructions',
  ];

  final List<String> _diagnoseSteps = [
    'Scanning for visual symptoms',
    'Detecting potential issues',
    'Preparing treatment advice',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _startStepAnimation();
  }

  void _startStepAnimation() {
    _controller.repeat();
    _controller.addListener(() {
      final steps = widget.isIdentify ? _identifySteps : _diagnoseSteps;
      final newStep = (_controller.value * steps.length).floor();
      if (newStep != _currentStep && newStep < steps.length) {
        setState(() {
          _currentStep = newStep;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.isIdentify ? _identifySteps : _diagnoseSteps;
    
    return Column(
      children: List.generate(steps.length, (index) {
        final isActive = index <= _currentStep;
        final isCompleted = index < _currentStep;
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? AppTheme.successColor 
                      : isActive 
                          ? AppTheme.plantGreen 
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      )
                    : isActive
                        ? const SizedBox(
                            width: 8,
                            height: 8,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : null,
              ),
              const SizedBox(width: 12),
              Text(
                steps[index],
                style: TextStyle(
                  fontSize: 14,
                  color: isActive ? Colors.black87 : Colors.grey[500],
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    required this.error,
    required this.onRetry,
  });

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.plantGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 