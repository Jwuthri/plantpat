class SupabaseConfig {
  static const String url = const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String anonKey = const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  
  // Validation method to ensure keys are provided
  static void validateConfig() {
    if (url.isEmpty) {
      throw Exception('SUPABASE_URL environment variable is required');
    }
    if (anonKey.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY environment variable is required');
    }
  }
} 