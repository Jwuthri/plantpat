import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/camera_provider.dart';
import '../widgets/camera_actions.dart';
import '../widgets/identification_result.dart';
import '../widgets/diagnosis_result.dart';
import '../widgets/plant_selection.dart';

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
        : cameraState.selectedPlant == null 
            ? 'Select a plant to check for health issues'
            : 'Scan ${cameraState.selectedPlant!.name} leaves for diagnosis';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            cameraNotifier.clearResults();
            context.go('/home');
          },
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          tooltip: 'Close',
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.background,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isIdentify 
                              ? AppTheme.lightGreen.withOpacity(0.1)
                              : AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isIdentify ? Icons.search : Icons.health_and_safety,
                          color: isIdentify ? AppTheme.lightGreen : AppTheme.successColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.onSurfaceVariant(context),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildContent(context, cameraState, cameraNotifier),
              ),
            ),
          ],
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
      );
    }

    // Show diagnosis result
    if (state.diagnosisResult != null && action == 'diagnose') {
      return DiagnosisResult(
        result: state.diagnosisResult!,
        linkedPlant: state.selectedPlant, // Pass the selected plant
        diagnosisImage: state.diagnosisImageData, // Pass the diagnosis image
      );
    }

    // For diagnosis action, show plant selection first if no plant is selected
    if (action == 'diagnose' && state.selectedPlant == null) {
      return PlantSelectionWidget(
        onPlantSelected: (plant) {
          notifier.selectPlant(plant);
        },
      );
    }

    // Show camera actions
    return CameraActions(
      action: action == 'identify' ? CameraAction.identify : CameraAction.diagnose,
      onTakePhoto: (action) => notifier.takePhoto(action: action),
      onPickFromGallery: (action) => notifier.pickFromGallery(action: action),
      selectedPlant: state.selectedPlant,
      onChangeSelectedPlant: action == 'diagnose' && state.selectedPlant != null
          ? () => notifier.clearResults() // Clear all state to go back to plant selection
          : null,
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({required this.action});

  final String action;

  @override
  Widget build(BuildContext context) {
    final isIdentify = action == 'identify';
    final primaryColor = isIdentify ? AppTheme.lightGreen : AppTheme.successColor;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Modern loading container
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
                stops: const [0.5, 0.8, 1.0],
              ),
              borderRadius: BorderRadius.circular(70),
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                    strokeWidth: 3,
                    backgroundColor: primaryColor.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Loading text
          Text(
            isIdentify ? 'Identifying plant...' : 'Analyzing plant health...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              isIdentify 
                  ? 'Our AI is recognizing the plant species and gathering care information'
                  : 'Checking for diseases, pests, and health issues',
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.onSurfaceVariant(context),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          
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
    final primaryColor = widget.isIdentify ? AppTheme.lightGreen : AppTheme.successColor;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Processing steps',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(steps.length, (index) {
            final isActive = index <= _currentStep;
            final isCompleted = index < _currentStep;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isCompleted 
                          ? AppTheme.successColor 
                          : isActive 
                              ? primaryColor 
                              : Theme.of(context).colorScheme.outline,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          )
                        : isActive
                            ? Container(
                                margin: const EdgeInsets.all(4),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                            : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 15,
                        color: isActive 
                            ? Theme.of(context).colorScheme.onSurface
                            : AppTheme.onSurfaceVariant(context),
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
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
            // Error icon with modern design
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: AppTheme.errorColor.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                error,
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.onSurfaceVariant(context),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            
            // Retry button with modern design
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.plantGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                elevation: 2,
                shadowColor: AppTheme.plantGreen.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 