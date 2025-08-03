import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../../../core/services/ai_service.dart';
import '../../plants/models/plant.dart';

class CameraController extends StateNotifier<CameraState> {
  CameraController(this.ref) : super(const CameraState());
  
  final Ref ref;
  final _logger = Logger();
  final _imagePicker = ImagePicker();
  final _aiService = AIService();
  final _uuid = const Uuid();

  Future<void> takePhoto({required CameraAction action}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (image == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final imageBytes = await image.readAsBytes();
      
      switch (action) {
        case CameraAction.identify:
          await _identifyPlant(imageBytes);
          break;
        case CameraAction.diagnose:
          await _diagnosePlant(imageBytes);
          break;
      }
    } catch (e) {
      _logger.e('Error taking photo: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to process image: $e',
      );
    }
  }

  Future<void> pickFromGallery({required CameraAction action}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (image == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final imageBytes = await image.readAsBytes();
      
      switch (action) {
        case CameraAction.identify:
          await _identifyPlant(imageBytes);
          break;
        case CameraAction.diagnose:
          await _diagnosePlant(imageBytes);
          break;
      }
    } catch (e) {
      _logger.e('Error picking from gallery: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to process image: $e',
      );
    }
  }

  Future<void> _identifyPlant(Uint8List imageBytes) async {
    try {
      final result = await _aiService.identifyPlant(imageBytes);
      
      // Create a Plant object from the identification result
      final plant = Plant(
        id: _uuid.v4(),
        name: result.name,
        scientificName: result.scientificName,
        commonNames: [result.name],
        species: result.category,
        images: [base64Encode(imageBytes)], // Store raw base64 image
        description: result.description,
        careInstructions: result.careInfo,
        tags: result.tags,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        confidence: result.confidence,
      );

      state = state.copyWith(
        isLoading: false,
        identificationResult: result,
        identifiedPlant: plant,
      );
    } catch (e) {
      _logger.e('Error identifying plant: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to identify plant: $e',
      );
    }
  }

  Future<void> _diagnosePlant(Uint8List imageBytes) async {
    try {
      // Check if we have a selected plant to link the diagnosis to
      if (state.selectedPlant == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Please select a plant first before diagnosing health issues.',
        );
        return;
      }

      final result = await _aiService.diagnosePlantHealth(
        imageBytes, 
        plantId: state.selectedPlant!.id,
      );
      
      // Store the image data for display
      final base64Image = base64Encode(imageBytes);
      
      state = state.copyWith(
        isLoading: false,
        diagnosisResult: result,
        diagnosisImageData: base64Image,
      );
    } catch (e) {
      _logger.e('Error diagnosing plant: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to diagnose plant: $e',
      );
    }
  }

  Future<void> saveIdentifiedPlant() async {
    if (state.identifiedPlant == null) return;

    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      // Save the plant and get the returned ID
      final savedPlantId = await _aiService.savePlant(state.identifiedPlant!);
      
      state = state.copyWith(
        isLoading: false,
        savedPlantId: savedPlantId,
        // Keep the identification result so user can see what was saved
      );
      
      _logger.i('Plant saved successfully with ID: $savedPlantId');
    } catch (e) {
      _logger.e('Error saving plant: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save plant: $e',
      );
    }
  }

  // Helper to check if diagnosis is available (plant must be selected first)
  bool get canDiagnose => state.selectedPlant != null;
  
  // Helper to get plant info for diagnosis
  String? get currentPlantInfo {
    if (state.selectedPlant != null) {
      return '${state.selectedPlant!.name} (${state.selectedPlant!.scientificName ?? ''})';
    }
    return null;
  }

  // Method to select a plant for diagnosis
  void selectPlant(Plant plant) {
    state = state.copyWith(selectedPlant: plant);
  }

  void clearResults() {
    state = const CameraState();
  }
}

// Provider
final cameraControllerProvider = StateNotifierProvider<CameraController, CameraState>((ref) {
  return CameraController(ref);
});

class CameraState {
  const CameraState({
    this.isLoading = false,
    this.errorMessage,
    this.identificationResult,
    this.identifiedPlant,
    this.diagnosisResult,
    this.savedPlantId,
    this.selectedPlant,
    this.diagnosisImageData,
  });

  final bool isLoading;
  final String? errorMessage;
  final PlantIdentificationResult? identificationResult;
  final Plant? identifiedPlant;
  final PlantDiagnosisResult? diagnosisResult;
  final String? savedPlantId;
  final Plant? selectedPlant;
  final String? diagnosisImageData;

  CameraState copyWith({
    bool? isLoading,
    String? errorMessage,
    PlantIdentificationResult? identificationResult,
    Plant? identifiedPlant,
    PlantDiagnosisResult? diagnosisResult,
    String? savedPlantId,
    Plant? selectedPlant,
    String? diagnosisImageData,
  }) {
    return CameraState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      identificationResult: identificationResult ?? this.identificationResult,
      identifiedPlant: identifiedPlant ?? this.identifiedPlant,
      diagnosisResult: diagnosisResult ?? this.diagnosisResult,
      savedPlantId: savedPlantId ?? this.savedPlantId,
      selectedPlant: selectedPlant ?? this.selectedPlant,
      diagnosisImageData: diagnosisImageData ?? this.diagnosisImageData,
    );
  }
}

enum CameraAction {
  identify,
  diagnose,
} 