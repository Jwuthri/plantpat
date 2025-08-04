/// API Configuration for the PlantPal app
/// 
/// This file contains all API-related configuration constants.
/// Update the [backendUrl] to match your backend server.
class ApiConfig {
  /// Backend server URL
  /// 
  /// For local development:
  /// - iOS Simulator: 'http://localhost:3000'
  /// - Physical device: 'http://192.168.1.106:3000' (your network IP)
  /// - Android emulator: 'http://10.0.2.2:3000'
  static const String backendUrl = 'http://192.168.1.106:3000';
  
  /// API endpoints
  static const String authLoginEndpoint = '/api/auth/login';
  static const String authLogoutEndpoint = '/api/auth/logout';
  static const String authProfileEndpoint = '/api/auth/profile';
  static const String authRegisterEndpoint = '/api/auth/register';
  
  static const String aiIdentifyEndpoint = '/api/ai/identify';
  static const String aiDiagnoseEndpoint = '/api/ai/diagnose';
  
  static const String plantsSaveEndpoint = '/api/plants/save';
  static const String diagnosesSaveEndpoint = '/api/diagnoses/save';
  
  static const String remindersListEndpoint = '/api/reminders/list';
  static const String remindersCreateEndpoint = '/api/reminders/create';
  static const String remindersCompleteEndpoint = '/api/reminders/complete';
  
  /// Helper methods to get full URLs
  static String get authLogin => '$backendUrl$authLoginEndpoint';
  static String get authLogout => '$backendUrl$authLogoutEndpoint';
  static String get authProfile => '$backendUrl$authProfileEndpoint';
  static String get authRegister => '$backendUrl$authRegisterEndpoint';
  
  static String get aiIdentify => '$backendUrl$aiIdentifyEndpoint';
  static String get aiDiagnose => '$backendUrl$aiDiagnoseEndpoint';
  
  static String get plantsSave => '$backendUrl$plantsSaveEndpoint';
  static String get diagnosesSave => '$backendUrl$diagnosesSaveEndpoint';
  
  static String get remindersList => '$backendUrl$remindersListEndpoint';
  static String get remindersCreate => '$backendUrl$remindersCreateEndpoint';
  static String get remindersComplete => '$backendUrl$remindersCompleteEndpoint';
}