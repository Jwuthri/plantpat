import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserProfileService {
  static final UserProfileService _instance = UserProfileService._internal();
  factory UserProfileService() => _instance;
  UserProfileService._internal();

  final Logger _logger = Logger();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Uuid _uuid = const Uuid();
  
  String? _cachedProfileId;

  /// Get the device-based profile ID - consistent across the entire app
  Future<String> getProfileId() async {
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
        _logger.i('👤 [PROFILE] 💾 Using stored profile ID: $storedId');
        return storedId;
      }

      String deviceSeed;
      
      try {
        // Try to get device-specific identifier
        if (Platform.isAndroid) {
          final androidInfo = await _deviceInfo.androidInfo;
          deviceSeed = 'android_${androidInfo.id}';
          _logger.i('👤 [PROFILE] 📱 Android device ID: ${androidInfo.id}');
        } else if (Platform.isIOS) {
          final iosInfo = await _deviceInfo.iosInfo;
          deviceSeed = 'ios_${iosInfo.identifierForVendor ?? 'unknown'}';
          _logger.i('👤 [PROFILE] 📱 iOS device ID: ${iosInfo.identifierForVendor}');
        } else {
          // Fallback for other platforms
          deviceSeed = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
          _logger.w('👤 [PROFILE] ⚠️ Unknown platform, using timestamp-based ID');
        }
        
        // Generate deterministic UUID from device seed
        final profileUuid = _uuid.v5(Uuid.NAMESPACE_X500, deviceSeed);
        
        // Store for future use
        await prefs.setString(prefKey, profileUuid);
        _cachedProfileId = profileUuid;
        _logger.i('👤 [PROFILE] ✅ Generated and stored profile ID: $profileUuid');
        return profileUuid;
        
      } catch (deviceError) {
        _logger.e('👤 [PROFILE] ❌ Device info failed: $deviceError');
        
        // Create a random but persistent UUID as fallback
        final fallbackUuid = _uuid.v4();
        await prefs.setString(prefKey, fallbackUuid);
        _cachedProfileId = fallbackUuid;
        _logger.w('👤 [PROFILE] ⚠️ Using persistent fallback ID: $fallbackUuid');
        return fallbackUuid;
      }
      
    } catch (e) {
      _logger.e('👤 [PROFILE] ❌ Critical error getting profile ID: $e');
      // Last resort fallback (not persistent)
      final emergencyUuid = _uuid.v4();
      _cachedProfileId = emergencyUuid;
      _logger.w('👤 [PROFILE] 🚨 Using emergency ID: $emergencyUuid');
      return emergencyUuid;
    }
  }

  /// Clear cached profile ID (for testing/debugging)
  void clearCache() {
    _cachedProfileId = null;
  }
}