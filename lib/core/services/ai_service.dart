import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class AIService {
  static const String _backendUrl = 'http://localhost:3000'; // TODO: Make this configurable
  
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  Future<PlantIdentificationResult> identifyPlant(Uint8List imageBytes) async {
    _logger.i('📱 [FLUTTER-AI] 🌱 Starting plant identification...', {
      'imageSize': '${(imageBytes.length / 1024).toStringAsFixed(2)}KB',
      'timestamp': DateTime.now().toIso8601String(),
    });
    
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
      _logger.i('📱 [FLUTTER-AI] ✅ Backend response received', {
        'statusCode': response.statusCode,
        'responseTime': '${responseTime}ms'
      });

      if (response.statusCode == 200) {
        final responseData = response.data;
        _logger.d('📱 [FLUTTER-AI] 📋 Processing backend response...', {
          'success': responseData['success'],
          'hasData': responseData['data'] != null,
          'processingTime': responseData['processingTime']
        });
        
        if (responseData['success'] == true) {
          final aiResult = responseData['data'];
          
          // Convert backend response to Flutter model
          final result = PlantIdentificationResult(
            name: aiResult['plantIdentification']['species'] ?? '',
            scientificName: aiResult['plantIdentification']['scientificName'] ?? '',
            category: _mapCategoryFromBackend(aiResult),
            confidence: (aiResult['plantIdentification']['confidence'] ?? 0.0).toDouble(),
            description: _buildDescriptionFromBackend(aiResult),
            careInfo: _mapCareInfoFromBackend(aiResult['careInstructions'] ?? {}),
            tags: _generateTagsFromBackend(aiResult),
          );
          
          _logger.i('📱 [FLUTTER-AI] ✅ Plant identification successful!', {
            'species': result.name,
            'confidence': result.confidence,
            'category': result.category,
            'backendProcessingTime': responseData['processingTime']
          });
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
    _logger.i('📱 [FLUTTER-AI] 🩺 Starting plant health diagnosis...', {
      'imageSize': '${(imageBytes.length / 1024).toStringAsFixed(2)}KB',
      'hasPlantContext': plantContext != null,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
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
      _logger.i('📱 [FLUTTER-AI] ✅ Backend response received', {
        'statusCode': response.statusCode,
        'responseTime': '${responseTime}ms'
      });

      if (response.statusCode == 200) {
        final responseData = response.data;
        _logger.d('📱 [FLUTTER-AI] 📋 Processing diagnosis response...', {
          'success': responseData['success'],
          'hasData': responseData['data'] != null,
          'processingTime': responseData['processingTime']
        });
        
        if (responseData['success'] == true) {
          final aiResult = responseData['data'];
          
          // Convert backend response to Flutter model
          final result = PlantDiagnosisResult(
            overallHealthScore: _mapHealthScoreFromBackend(aiResult['healthAssessment']),
            detectedIssues: _mapIssuesFromBackend(aiResult['healthAssessment']['issues'] ?? []),
            generalRecommendations: List<String>.from(aiResult['careRecommendations']['preventive'] ?? []),
          );
          
          _logger.i('📱 [FLUTTER-AI] ✅ Plant diagnosis successful!', {
            'healthScore': result.overallHealthScore,
            'issuesFound': result.detectedIssues.length,
            'recommendations': result.generalRecommendations.length,
            'backendProcessingTime': responseData['processingTime']
          });
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
    return {
      'lightRequirement': careInstructions['lighting']?['type'] ?? 'medium',
      'wateringFrequency': careInstructions['watering']?['frequency'] ?? 'weekly',
      'soilType': 'well-draining',
      'humidity': careInstructions['humidity']?['level'] ?? 'medium',
      'temperature': 'moderate',
      'fertilizingSchedule': [careInstructions['fertilizing']?['frequency'] ?? 'monthly'],
      'commonProblems': ['overwatering', 'inadequate light'],
      'careInstructions': [
        careInstructions['watering']?['notes'] ?? 'Water when soil is dry',
        careInstructions['lighting']?['notes'] ?? 'Provide adequate light',
      ],
    };
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