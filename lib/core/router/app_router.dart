import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/camera/presentation/camera_screen.dart';
import '../../features/plants/presentation/plants_screen.dart';
import '../../features/plants/presentation/plant_detail_screen.dart';
import '../../features/diagnosis/presentation/diagnosis_screen.dart';
import '../../features/reminders/presentation/reminders_screen.dart';
import '../../shared/presentation/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/camera',
        name: 'camera',
        builder: (context, state) {
          final action = state.uri.queryParameters['action'] ?? 'identify';
          return CameraScreen(action: action);
        },
      ),
      GoRoute(
        path: '/plants',
        name: 'plants',
        builder: (context, state) => const PlantsScreen(),
        routes: [
          GoRoute(
            path: ':plantId',
            name: 'plant-detail',
            builder: (context, state) {
              final plantId = state.pathParameters['plantId']!;
              return PlantDetailScreen(plantId: plantId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/diagnosis',
        name: 'diagnosis',
        builder: (context, state) => const DiagnosisScreen(),
      ),
      GoRoute(
        path: '/reminders',
        name: 'reminders',
        builder: (context, state) => const RemindersScreen(),
      ),
    ],
  );
}); 