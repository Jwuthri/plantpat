import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  
  // Initialize notifications
  await NotificationService.initialize();
  await NotificationService.requestPermissions();
  
  runApp(
    const ProviderScope(
      child: PlantPalApp(),
    ),
  );
}

class PlantPalApp extends ConsumerWidget {
  const PlantPalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    // Set up navigation callback for notifications
    NotificationService.setNavigationCallback((reminderId) {
      router.go('/reminders/$reminderId');
    });
    
    return MaterialApp.router(
      title: 'PlantPal',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
} 