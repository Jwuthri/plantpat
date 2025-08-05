import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../config/api_config.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  final _logger = Logger();
  String? _authToken;

  // Set authentication token
  void setAuthToken(String? token) {
    _authToken = token;
  }

  // Get headers with auth if available
  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  // Generic GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConfig.backendUrl}$endpoint');
      _logger.i('🌐 GET: $url');
      
      final response = await http.get(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      _logger.e('GET request failed: $e');
      throw Exception('Network request failed: $e');
    }
  }

  // Generic POST request
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${ApiConfig.backendUrl}$endpoint');
      _logger.i('🌐 POST: $url');
      _logger.d('📤 Request data: $data');
      
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      _logger.e('POST request failed: $e');
      throw Exception('Network request failed: $e');
    }
  }

  // Generic PUT request
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${ApiConfig.backendUrl}$endpoint');
      _logger.i('🌐 PUT: $url');
      
      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      _logger.e('PUT request failed: $e');
      throw Exception('Network request failed: $e');
    }
  }

  // Generic DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConfig.backendUrl}$endpoint');
      _logger.i('🌐 DELETE: $url');
      
      final response = await http.delete(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      _logger.e('DELETE request failed: $e');
      throw Exception('Network request failed: $e');
    }
  }

  // Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    _logger.i('📥 Response: ${response.statusCode}');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        _logger.d('✅ Response data: $responseData');
        return responseData;
      } catch (e) {
        _logger.w('Failed to parse response as JSON: ${response.body}');
        return {'message': response.body};
      }
    } else {
      _logger.e('❌ HTTP Error: ${response.statusCode} - ${response.body}');
      
      try {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Request failed');
      } catch (e) {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    }
  }

  // Authentication methods
  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await post(ApiConfig.authLoginEndpoint, {
      'email': email,
      'password': password,
    });
    
    // Store auth token if provided
    if (result['token'] != null) {
      setAuthToken(result['token']);
    }
    
    return result;
  }

  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    return await post(ApiConfig.authRegisterEndpoint, {
      'email': email,
      'password': password,
      'name': name,
    });
  }

  Future<void> logout() async {
    try {
      await post(ApiConfig.authLogoutEndpoint, {});
    } finally {
      setAuthToken(null);
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    return await get(ApiConfig.authProfileEndpoint);
  }

  // AI methods
  Future<Map<String, dynamic>> identifyPlant(String imageBase64) async {
    return await post(ApiConfig.aiIdentifyEndpoint, {
      'image': imageBase64,
    });
  }

  Future<Map<String, dynamic>> diagnosePlant(String imageBase64, {Map<String, dynamic>? plantContext}) async {
    final data = <String, dynamic>{'image': imageBase64};
    if (plantContext != null) {
      data['plantContext'] = plantContext;
    }
    return await post(ApiConfig.aiDiagnoseEndpoint, data);
  }

  // Plant methods
  Future<List<dynamic>> getPlants() async {
    final result = await get(ApiConfig.plantsListEndpoint);
    return result['plants'] ?? [];
  }

  Future<Map<String, dynamic>> savePlant(Map<String, dynamic> plantData) async {
    return await post(ApiConfig.plantsSaveEndpoint, plantData);
  }

  // Diagnosis methods
  Future<List<dynamic>> getDiagnoses() async {
    final result = await get(ApiConfig.diagnosesListEndpoint);
    return result['diagnoses'] ?? [];
  }
  
  Future<Map<String, dynamic>> saveDiagnosis(Map<String, dynamic> diagnosisData) async {
    return await post(ApiConfig.diagnosesSaveEndpoint, diagnosisData);
  }

  // Reminder methods
  Future<List<dynamic>> getReminders() async {
    final result = await get(ApiConfig.remindersListEndpoint);
    return result['reminders'] ?? [];
  }

  Future<Map<String, dynamic>> createReminder(Map<String, dynamic> reminderData) async {
    return await post(ApiConfig.remindersCreateEndpoint, reminderData);
  }

  Future<Map<String, dynamic>> completeReminder(String reminderId) async {
    return await post(ApiConfig.remindersCompleteEndpoint, {
      'reminderId': reminderId,
    });
  }
}