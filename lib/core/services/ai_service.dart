import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AIService {
  static const String _backendUrl = 'http://192.168.1.106:3000'; // Use local IP for device testing
  
  final Dio _dio = Dio();
  final Logger _logger = Logger();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Uuid _uuid = const Uuid();
  
  String? _cachedProfileId;

  // Generate device-based profile ID with persistent storage
  Future<String> _getDeviceProfileId() async {
    if (_cachedProfileId != null) {
      return _cachedProfileId!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      const String prefKey = 'plantpal_user_id';
      
      // First check if we already have a stored user ID
      String? storedId = prefs.getString(prefKey);
      if (storedId != null && storedId.isNotEmpty) {
        _cachedProfileId = storedId;
        _logger.i('📱 [FLUTTER-AI] 💾 Using stored user ID: $storedId');
        return storedId;
      }

      String deviceSeed;
      
      try {
        // Try to get device-specific identifier
        if (Platform.isAndroid) {
          final androidInfo = await _deviceInfo.androidInfo;
          deviceSeed = 'android_${androidInfo.id}';
          _logger.i('📱 [FLUTTER-AI] 📱 Android device ID retrieved: ${androidInfo.id}');
        } else if (Platform.isIOS) {
          final iosInfo = await _deviceInfo.iosInfo;
          deviceSeed = 'ios_${iosInfo.identifierForVendor ?? 'unknown'}';
          _logger.i('📱 [FLUTTER-AI] 📱 iOS device ID retrieved: ${iosInfo.identifierForVendor}');
        } else {
          // Fallback for other platforms
          deviceSeed = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
          _logger.w('📱 [FLUTTER-AI] ⚠️ Unknown platform, using timestamp-based ID');
        }
        
        // Generate deterministic UUID from device seed
        final profileUuid = _uuid.v5(Uuid.NAMESPACE_URL, deviceSeed);
        
        // Store for future use
        await prefs.setString(prefKey, profileUuid);
        _cachedProfileId = profileUuid;
        _logger.i('📱 [FLUTTER-AI] ✅ Generated and stored profile UUID: $profileUuid');
        return profileUuid;
        
      } catch (deviceError) {
        _logger.e('📱 [FLUTTER-AI] ❌ Device info failed: $deviceError');
        
        // Create a random but persistent UUID as fallback
        final fallbackUuid = _uuid.v4();
        await prefs.setString(prefKey, fallbackUuid);
        _cachedProfileId = fallbackUuid;
        _logger.w('📱 [FLUTTER-AI] ⚠️ Using persistent fallback UUID: $fallbackUuid');
        return fallbackUuid;
      }
      
    } catch (e) {
      _logger.e('📱 [FLUTTER-AI] ❌ Critical error getting user ID: $e');
      // Last resort fallback (not persistent)
      final emergencyUuid = _uuid.v4();
      _cachedProfileId = emergencyUuid;
      _logger.w('📱 [FLUTTER-AI] 🚨 Using emergency UUID: $emergencyUuid');
      return emergencyUuid;
    }
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
          final plantId = aiResult['plantIdentification'] ?? {};
          final careInst = aiResult['careInstructions'] ?? {};
          
          final result = PlantIdentificationResult(
            name: plantId['species'] ?? 'Unknown Plant',
            scientificName: plantId['scientificName'] ?? '',
            category: _mapCategoryFromBackend(aiResult),
            confidence: (plantId['confidence'] ?? 0.0).toDouble(),
            description: _buildDescriptionFromBackend(aiResult),
            careInfo: _mapCareInfoFromBackend(careInst),
            tags: _generateTagsFromBackend(aiResult),
          );
          
          _logger.i('📱 [FLUTTER-AI] 🔍 Mapped result: name="${result.name}", sci="${result.scientificName}", conf=${result.confidence}, category="${result.category}"');
          _logger.d('📱 [FLUTTER-AI] 🔍 Care info keys: ${result.careInfo.keys.toList()}');
          
          _logger.i('📱 [FLUTTER-AI] ✅ Plant identification successful! (${result.name}, confidence: ${result.confidence})');
          
          // Auto-save plant to database
          await _savePlantToDatabase(result);
          
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

  Future<PlantDiagnosisResult> diagnosePlantHealth(Uint8List imageBytes, {Map<String, dynamic>? plantContext}) async {
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
    final commonNames = aiResult['plantIdentification']?['commonNames'] ?? [];
    
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

  // Save identified plant to database
  Future<void> _savePlantToDatabase(PlantIdentificationResult plant) async {
    try {
      _logger.i('📱 [FLUTTER-AI] 💾 Saving plant to database: ${plant.name}');
      
      // Get device-based profile ID
      final profileId = await _getDeviceProfileId();
      
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
          _logger.i('📱 [FLUTTER-AI] ✅ Plant saved to database successfully!');
        } else {
          _logger.w('📱 [FLUTTER-AI] ⚠️ Plant save returned success=false: ${responseData['error']}');
        }
      } else {
        _logger.w('📱 [FLUTTER-AI] ⚠️ Unexpected response status: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('📱 [FLUTTER-AI] ❌ Failed to save plant to database: $e');
      // Don't throw - saving is not critical for identification
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