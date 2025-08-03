import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'user_profile_service.dart';
import '../../features/plants/models/plant.dart';

class AIService {
  static const String _backendUrl = 'http://192.168.1.106:3000'; // Use local IP for device testing
  
  final Dio _dio = Dio();
  final Logger _logger = Logger();
  final UserProfileService _profileService = UserProfileService();

  // Get device-based profile ID using shared service
  Future<String> _getDeviceProfileId() async {
    return await _profileService.getProfileId();
  }

  Future<PlantIdentificationResult> identifyPlant(Uint8List imageBytes) async {
    _logger.i('📱 [FLUTTER-AI] 🌱 Starting plant identification... (${(imageBytes.length / 1024).toStringAsFixed(2)}KB)');
    
    try {
      final base64Image = base64Encode(imageBytes);
      _logger.d('📱 [FLUTTER-AI] 📷 Image encoded to base64, length: ${base64Image.length}');
      
      final requestBody = {
        'imageData': base64Image,
        'imageType': 'image/jpeg',
      };

      _logger.i('📱 [FLUTTER-AI] 🚀 Calling backend API: $_backendUrl/api/ai/identify');
      final startTime = DateTime.now();
      
      final response = await _dio.post(
        '$_backendUrl/api/ai/identify',
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final responseTime = DateTime.now().difference(startTime).inMilliseconds;
      _logger.i('📱 [FLUTTER-AI] ✅ Backend response received (${response.statusCode}, ${responseTime}ms)');

      if (response.statusCode == 200) {
        final responseData = response.data;
        _logger.d('📱 [FLUTTER-AI] 📋 Processing backend response... (success: ${responseData['success']}, processing: ${responseData['processingTime']})');
        
        if (responseData['success'] == true) {
          final aiResult = responseData['data'];
          
          // Debug: Print the actual response structure
          _logger.d('📱 [FLUTTER-AI] 🔍 Backend response structure: ${aiResult.toString()}');
          
          // Convert backend response to Flutter model
          final plantIdData = aiResult['plantIdentification'] ?? {};
          final careInst = aiResult['careInstructions'] ?? {};
          
          final result = PlantIdentificationResult(
            name: plantIdData['species'] ?? 'Unknown Plant',
            scientificName: plantIdData['scientificName'] ?? '',
            category: _mapCategoryFromBackend(aiResult),
            confidence: (plantIdData['confidence'] ?? 0.0).toDouble(),
            description: _buildDescriptionFromBackend(aiResult),
            careInfo: _mapCareInfoFromBackend(careInst),
            tags: _generateTagsFromBackend(aiResult),
          );
          
          _logger.i('📱 [FLUTTER-AI] 🔍 Mapped result: name="${result.name}", sci="${result.scientificName}", conf=${result.confidence}, category="${result.category}"');
          _logger.d('📱 [FLUTTER-AI] 🔍 Care info keys: ${result.careInfo.keys.toList()}');
          
          _logger.i('📱 [FLUTTER-AI] ✅ Plant identification successful! (${result.name}, confidence: ${result.confidence})');
          
          // Auto-save plant to database with image
          final base64Image = base64Encode(imageBytes);
          _logger.i('📱 [FLUTTER-AI] 📷 Created base64 image length: ${base64Image.length}');
          final plantId = await _savePlantToDatabase(result, imageData: base64Image);
          _logger.d('📱 [FLUTTER-AI] 💾 Auto-saved plant with ID: $plantId');
          
          return result;
        } else {
          _logger.e('📱 [FLUTTER-AI] ❌ Backend returned error: ${responseData['error']}');
          throw Exception('Backend error: ${responseData['error']}');
        }
      } else {
        _logger.e('📱 [FLUTTER-AI] ❌ HTTP error: ${response.statusCode}');
        throw Exception('AI service error: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('📱 [FLUTTER-AI] ❌ Plant identification failed: $e');
      rethrow;
    }
  }

  Future<PlantDiagnosisResult> diagnosePlantHealth(Uint8List imageBytes, {Map<String, dynamic>? plantContext, String? plantId}) async {
    _logger.i('📱 [FLUTTER-AI] 🩺 Starting plant health diagnosis... (${(imageBytes.length / 1024).toStringAsFixed(2)}KB)');
    
    try {
      final base64Image = base64Encode(imageBytes);
      _logger.d('📱 [FLUTTER-AI] 📷 Image encoded to base64, length: ${base64Image.length}');
      
      final requestBody = {
        'imageData': base64Image,
        'imageType': 'image/jpeg',
        'plantContext': plantContext,
      };

      _logger.i('📱 [FLUTTER-AI] 🚀 Calling backend API: $_backendUrl/api/ai/diagnose');
      final startTime = DateTime.now();
      
      final response = await _dio.post(
        '$_backendUrl/api/ai/diagnose',
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final responseTime = DateTime.now().difference(startTime).inMilliseconds;
      _logger.i('📱 [FLUTTER-AI] ✅ Backend response received (${response.statusCode}, ${responseTime}ms)');

      if (response.statusCode == 200) {
        final responseData = response.data;
        _logger.d('📱 [FLUTTER-AI] 📋 Processing diagnosis response... (success: ${responseData['success']}, processing: ${responseData['processingTime']})');
        
        if (responseData['success'] == true) {
          final aiResult = responseData['data'];
          
          // Convert backend response to Flutter model
          final result = PlantDiagnosisResult(
            overallHealthScore: _mapHealthScoreFromBackend(aiResult['healthAssessment']),
            detectedIssues: _mapIssuesFromBackend(aiResult['healthAssessment']['issues'] ?? []),
            generalRecommendations: List<String>.from(aiResult['careRecommendations']['preventive'] ?? []),
          );
          
          _logger.i('📱 [FLUTTER-AI] ✅ Plant diagnosis successful! (health: ${result.overallHealthScore}, issues: ${result.detectedIssues.length})');
          
          // Save diagnosis to database
          final base64Image = base64Encode(imageBytes);
          await _saveDiagnosisToDatabase(aiResult, result, plantId: plantId, imageData: base64Image);
          
          return result;
        } else {
          _logger.e('📱 [FLUTTER-AI] ❌ Backend returned error: ${responseData['error']}');
          throw Exception('Backend error: ${responseData['error']}');
        }
      } else {
        _logger.e('📱 [FLUTTER-AI] ❌ HTTP error: ${response.statusCode}');
        throw Exception('AI service error: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('📱 [FLUTTER-AI] ❌ Plant diagnosis failed: $e');
      rethrow;
    }
  }

  // Helper methods to map backend response to Flutter models
  String _mapCategoryFromBackend(Map<String, dynamic> aiResult) {
    final species = aiResult['plantIdentification']?['species']?.toString().toLowerCase() ?? '';
    // final commonNames = aiResult['plantIdentification']?['commonNames'] ?? [];
    
    // Simple category mapping based on plant name
    if (species.contains('succulent') || species.contains('cactus')) return 'succulent';
    if (species.contains('herb') || species.contains('basil') || species.contains('mint')) return 'herb';
    if (species.contains('tree') || species.contains('oak') || species.contains('maple')) return 'tree';
    if (species.contains('flower') || species.contains('rose') || species.contains('tulip')) return 'flower';
    
    return 'houseplant'; // Default
  }

  String _buildDescriptionFromBackend(Map<String, dynamic> aiResult) {
    final species = aiResult['plantIdentification']?['species'] ?? 'Unknown plant';
    final scientificName = aiResult['plantIdentification']?['scientificName'] ?? '';
    
    return scientificName.isNotEmpty 
      ? '$species ($scientificName) is a beautiful plant with specific care requirements.'
      : '$species is a beautiful plant with specific care requirements.';
  }

  Map<String, dynamic> _mapCareInfoFromBackend(Map<String, dynamic> careInstructions) {
    _logger.d('📱 [FLUTTER-AI] 🔍 Raw care instructions: $careInstructions');
    
    final watering = careInstructions['watering'] as Map<String, dynamic>? ?? {};
    final lighting = careInstructions['lighting'] as Map<String, dynamic>? ?? {};
    final humidity = careInstructions['humidity'] as Map<String, dynamic>? ?? {};
    final temperature = careInstructions['temperature'] as Map<String, dynamic>? ?? {};
    final fertilizing = careInstructions['fertilizing'] as Map<String, dynamic>? ?? {};
    
    final mapped = {
      'lightRequirement': lighting['type'] ?? 'medium',
      'wateringFrequency': watering['frequency'] ?? 'weekly',
      'soilType': 'well-draining',
      'humidity': humidity['level'] ?? 'medium', 
      'temperature': temperature['notes'] ?? 'moderate',
      'fertilizingSchedule': [fertilizing['frequency'] ?? 'monthly'],
      'commonProblems': ['overwatering', 'inadequate light'],
      'careInstructions': [
        watering['notes'] ?? 'Water when soil is dry',
        lighting['notes'] ?? 'Provide adequate light',
      ],
    };
    
    _logger.d('📱 [FLUTTER-AI] 🔍 Mapped care info: $mapped');
    return mapped;
  }

  List<String> _generateTagsFromBackend(Map<String, dynamic> aiResult) {
    final tags = <String>['indoor'];
    final confidence = aiResult['plantIdentification']?['confidence'] ?? 0.0;
    
    if (confidence > 0.8) tags.add('easy-to-identify');
    if (confidence > 0.9) tags.add('beginner-friendly');
    
    return tags;
  }

  double _mapHealthScoreFromBackend(Map<String, dynamic> healthAssessment) {
    final overallHealth = healthAssessment['overallHealth']?.toString().toLowerCase() ?? 'unknown';
    
    switch (overallHealth) {
      case 'healthy': return 0.9;
      case 'minor_issues': return 0.7;
      case 'major_issues': return 0.4;
      case 'critical': return 0.2;
      default: return 0.5;
    }
  }

  List<Map<String, dynamic>> _mapIssuesFromBackend(List<dynamic> issues) {
    return issues.map((issue) => {
      'name': issue['type'] ?? 'Unknown issue',
      'description': issue['description'] ?? '',
      'type': issue['type'] ?? 'unknown',
      'severity': issue['severity'] ?? 'moderate',
      'confidence': issue['confidence'] ?? 0.5,
      'symptoms': [],
      'cause': issue['description'] ?? '',
      'prevention': 'Monitor plant regularly',
      'treatments': (issue['recommendations'] as List?)?.map((rec) => {
        'title': rec.toString(),
        'description': rec.toString(),
        'urgency': 'routine',
        'steps': [rec.toString()],
        'estimatedTime': 'As needed',
        'requiredMaterials': [],
      }).toList() ?? [],
    }).toList();
  }

  // Save identified plant to database - returns the saved plant ID
  Future<String?> _savePlantToDatabase(PlantIdentificationResult plant, {String? imageData}) async {
    try {
      _logger.i('📱 [FLUTTER-AI] 💾 Saving plant to database: ${plant.name}');
      
      // Get device-based profile ID - NEVER allow null/anonymous
      final profileId = await _getDeviceProfileId();
      if (profileId.isEmpty) {
        _logger.e('📱 [FLUTTER-AI] ❌ No valid profile ID - cannot save plant');
        throw Exception('Failed to get device profile ID');
      }
      
      _logger.i('📱 [FLUTTER-AI] 👤 Using profile ID for saving: $profileId');
      _logger.i('📱 [FLUTTER-AI] 📷 Image data length: ${imageData?.length ?? 0}');
      
      final requestBody = {
        'plantData': {
          'name': plant.name,
          'scientificName': plant.scientificName,
          'confidence': plant.confidence,
          'description': plant.description,
          'careInfo': plant.careInfo,
          'tags': plant.tags,
        },
        'profileId': profileId,
        'imageData': imageData, // Include base64 image data
      };

      final response = await _dio.post(
        '$_backendUrl/api/plants/save',
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          final plantId = responseData['plant']?['id'];
          _logger.i('📱 [FLUTTER-AI] ✅ Plant saved to database successfully! ID: $plantId');
          return plantId;
        } else {
          _logger.w('📱 [FLUTTER-AI] ⚠️ Plant save returned success=false: ${responseData['error']}');
          return null;
        }
      } else {
        _logger.w('📱 [FLUTTER-AI] ⚠️ Unexpected response status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _logger.e('📱 [FLUTTER-AI] ❌ Failed to save plant to database: $e');
      // Don't throw - saving is not critical for identification
      return null;
    }
  }

  // Public method to save a Plant object and return the plant ID
  Future<String> savePlant(Plant plant) async {
    try {
      _logger.i('📱 [FLUTTER-AI] 💾 Saving Plant object: ${plant.name}');
      
      // Convert Plant object to PlantIdentificationResult for saving
      final plantResult = PlantIdentificationResult(
        name: plant.name,
        scientificName: plant.scientificName ?? '',
        category: plant.species ?? 'unknown',
        confidence: plant.confidence ?? 0.0,
        description: plant.description ?? '',
        careInfo: plant.careInstructions ?? {},
        tags: plant.tags ?? [],
      );
      
      // Use the first image if available
      final imageData = plant.images.isNotEmpty ? plant.images.first : null;
      
      final plantId = await _savePlantToDatabase(plantResult, imageData: imageData);
      
      if (plantId == null) {
        throw Exception('Failed to save plant - no ID returned');
      }
      
      _logger.i('📱 [FLUTTER-AI] ✅ Plant saved successfully with ID: $plantId');
      return plantId;
    } catch (e) {
      _logger.e('📱 [FLUTTER-AI] ❌ Failed to save Plant object: $e');
      rethrow;
    }
  }

  // Save diagnosis results to database
  Future<void> _saveDiagnosisToDatabase(Map<String, dynamic> aiResult, PlantDiagnosisResult diagnosisResult, {String? plantId, String? imageData}) async {
    try {
      _logger.i('📱 [FLUTTER-AI] 💾 Saving diagnosis to database...');
      
      // Get device-based profile ID - NEVER allow null/anonymous
      final profileId = await _getDeviceProfileId();
      if (profileId.isEmpty) {
        _logger.e('📱 [FLUTTER-AI] ❌ No valid profile ID - cannot save diagnosis');
        throw Exception('Failed to get device profile ID');
      }
      
      _logger.i('📱 [FLUTTER-AI] 👤 Using profile ID for saving diagnosis: $profileId');
      
      final requestBody = {
        'diagnosisData': {
          'plantIdentification': aiResult['plantIdentification'] ?? {},
          'healthAssessment': aiResult['healthAssessment'] ?? {},
          'careRecommendations': aiResult['careRecommendations'] ?? {},
          'rawResponse': aiResult,
          'processingTime': aiResult['processingTime'],
          'images': imageData != null ? [imageData] : [], // Include the diagnosis image
        },
        'profileId': profileId,
        'plantId': plantId, // Link diagnosis to specific plant
      };

      final response = await _dio.post(
        '$_backendUrl/api/diagnoses/save',
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          _logger.i('📱 [FLUTTER-AI] ✅ Diagnosis saved to database successfully!');
        } else {
          _logger.w('📱 [FLUTTER-AI] ⚠️ Diagnosis save returned success=false: ${responseData['error']}');
        }
      } else {
        _logger.w('📱 [FLUTTER-AI] ⚠️ Unexpected response status: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('📱 [FLUTTER-AI] ❌ Failed to save diagnosis to database: $e');
      // Don't throw - saving is not critical for diagnosis
    }
  }
}

class PlantIdentificationResult {
  final String name;
  final String scientificName;
  final String category;
  final double confidence;
  final String description;
  final Map<String, dynamic> careInfo;
  final List<String> tags;

  PlantIdentificationResult({
    required this.name,
    required this.scientificName,
    required this.category,
    required this.confidence,
    required this.description,
    required this.careInfo,
    required this.tags,
  });

  factory PlantIdentificationResult.fromJson(Map<String, dynamic> json) {
    return PlantIdentificationResult(
      name: json['name'] ?? '',
      scientificName: json['scientificName'] ?? '',
      category: json['category'] ?? 'unknown',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      careInfo: json['careInfo'] ?? {},
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}

class PlantDiagnosisResult {
  final double overallHealthScore;
  final List<Map<String, dynamic>> detectedIssues;
  final List<String> generalRecommendations;

  PlantDiagnosisResult({
    required this.overallHealthScore,
    required this.detectedIssues,
    required this.generalRecommendations,
  });

  factory PlantDiagnosisResult.fromJson(Map<String, dynamic> json) {
    return PlantDiagnosisResult(
      overallHealthScore: (json['overallHealthScore'] ?? 0.0).toDouble(),
      detectedIssues: List<Map<String, dynamic>>.from(json['detectedIssues'] ?? []),
      generalRecommendations: List<String>.from(json['generalRecommendations'] ?? []),
    );
  }
} 