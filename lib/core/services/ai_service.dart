import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../features/plants/models/plant.dart';
import '../../features/diagnosis/models/diagnosis.dart';

class AIService {
  static const String _geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent';
  
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  Future<PlantIdentificationResult> identifyPlant(Uint8List imageBytes) async {
    try {
      final base64Image = base64Encode(imageBytes);
      
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': '''Analyze this plant image and provide detailed identification information. 
                
Return a JSON response with the following structure:
{
  "name": "Common name of the plant",
  "scientificName": "Scientific name",
  "category": "houseplant/outdoor/herb/flower/tree/succulent",
  "confidence": 0.95,
  "description": "Brief description of the plant",
  "careInfo": {
    "lightRequirement": "bright indirect/low/medium/high",
    "wateringFrequency": "weekly/bi-weekly/monthly",
    "soilType": "well-draining/moist/sandy",
    "humidity": "low/medium/high",
    "temperature": "cool/moderate/warm",
    "fertilizingSchedule": ["monthly during growing season"],
    "commonProblems": ["overwatering", "spider mites"],
    "careInstructions": ["water when soil is dry", "provide bright indirect light"]
  },
  "tags": ["indoor", "beginner-friendly", "air-purifying"]
}

Be specific and accurate. If you're not confident about the identification, indicate that in the confidence score.'''
              },
              {
                'inline_data': {
                  'mime_type': 'image/jpeg',
                  'data': base64Image
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.3,
          'maxOutputTokens': 2048 * 2
        }
      };

      final response = await _dio.post(
        '$_baseUrl?key=$_geminiApiKey',
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final content = response.data['candidates'][0]['content']['parts'][0]['text'];
        final jsonContent = _extractJsonFromText(content);
        final result = PlantIdentificationResult.fromJson(jsonContent);
        
        _logger.i('Plant identification successful: ${result.name}');
        return result;
      } else {
        throw Exception('AI service error: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error identifying plant: $e');
      rethrow;
    }
  }

  Future<PlantDiagnosisResult> diagnosePlantHealth(Uint8List imageBytes) async {
    try {
      final base64Image = base64Encode(imageBytes);
      
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': '''Analyze this plant image for health issues and provide a detailed diagnosis.

Return a JSON response with the following structure:
{
  "overallHealthScore": 0.85,
  "detectedIssues": [
    {
      "name": "Yellowing leaves",
      "description": "Older leaves showing yellow discoloration",
      "type": "watering_issue",
      "severity": "moderate",
      "confidence": 0.9,
      "symptoms": ["yellow leaves", "drooping"],
      "cause": "Overwatering or nutrient deficiency",
      "prevention": "Check soil moisture before watering",
      "treatments": [
        {
          "title": "Adjust watering schedule",
          "description": "Reduce watering frequency",
          "urgency": "within_week",
          "steps": ["Check soil moisture", "Water only when top inch is dry"],
          "estimatedTime": "Ongoing",
          "requiredMaterials": ["Moisture meter (optional)"]
        }
      ]
    }
  ],
  "generalRecommendations": [
    "Monitor soil moisture regularly",
    "Ensure proper drainage"
  ]
}

Valid types: disease, pest, nutrient_deficiency, watering_issue, environmental, physical_damage, fungal, bacterial, viral
Valid severities: low, moderate, high, critical
Valid urgencies: immediate, within_24h, within_week, routine

If the plant appears healthy, return an empty detectedIssues array and high health score.'''
              },
              {
                'inline_data': {
                  'mime_type': 'image/jpeg',
                  'data': base64Image
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.3,
          'maxOutputTokens': 2048 * 2
        }
      };

      final response = await _dio.post(
        '$_baseUrl?key=$_geminiApiKey',
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final content = response.data['candidates'][0]['content']['parts'][0]['text'];
        final jsonContent = _extractJsonFromText(content);
        final result = PlantDiagnosisResult.fromJson(jsonContent);
        
        _logger.i('Plant diagnosis successful: ${result.detectedIssues.length} issues found');
        return result;
      } else {
        throw Exception('AI service error: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error diagnosing plant: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _extractJsonFromText(String text) {
    try {
      // Find JSON content between ```json and ``` or just find the JSON object
      final jsonRegex = RegExp(r'```json\s*(.*?)\s*```', dotAll: true);
      final match = jsonRegex.firstMatch(text);
      
      if (match != null) {
        return json.decode(match.group(1)!);
      }
      
      // Try to find JSON object directly
      final objectRegex = RegExp(r'\{.*\}', dotAll: true);
      final objectMatch = objectRegex.firstMatch(text);
      
      if (objectMatch != null) {
        return json.decode(objectMatch.group(0)!);
      }
      
      throw Exception('No valid JSON found in response');
    } catch (e) {
      _logger.e('Error parsing JSON from AI response: $e');
      throw Exception('Failed to parse AI response');
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