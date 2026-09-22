import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/meal_scanner/presentation/screens/home_screen.dart';
import '../../features/meal_scanner/presentation/screens/camera_screen.dart';
import '../../features/meal_scanner/presentation/screens/meal_result_screen.dart';
import '../../features/meal_log/presentation/screens/meal_log_screen.dart';
import '../../features/carb_calculator/presentation/carb_calculator_screen.dart';
import '../../features/parent_dashboard/presentation/parent_dashboard_screen.dart';

/// Chemins de navigation déclarés comme constantes
class AppRoutes {
  AppRoutes._();
  static const String home = '/';
  static const String camera = '/camera';
  static const String mealResult = '/meal-result';
  static const String mealLog = '/meal-log';
  static const String carbCalculator = '/carb-calculator';
  static const String parentDashboard = '/parent';
}

/// Provider GoRouter — injectable via Riverpod
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      // ── Écran d'accueil (HomeScreen avec navigation principale)
      ShellRoute(
        builder: (context, state, child) => _AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.mealLog,
            pageBuilder: (context, state) => const NoTransitionPage(child: MealLogScreen()),
          ),
          GoRoute(
            path: AppRoutes.carbCalculator,
            pageBuilder: (context, state) => const NoTransitionPage(child: CarbCalculatorScreen()),
          ),
        ],
      ),
      // ── Écrans sans barre de navigation
      GoRoute(
        path: AppRoutes.camera,
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: AppRoutes.mealResult,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return MealResultScreen(analysisData: extra);
        },
      ),
      GoRoute(
        path: AppRoutes.parentDashboard,
        builder: (context, state) => const ParentDashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => _ErrorPage(error: state.error),
  );
});

/// Shell avec barre de navigation inférieure
class _AppShell extends StatelessWidget {
  const _AppShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: _GlucoBottomNav(currentIndex: currentIndex),
    );
  }

  int _indexFromLocation(String location) {
    if (location == AppRoutes.mealLog) return 1;
    if (location == AppRoutes.carbCalculator) return 2;
    return 0;
  }
}

class _GlucoBottomNav extends StatelessWidget {
  const _GlucoBottomNav({required this.currentIndex});
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0: context.go(AppRoutes.home); break;
          case 1: context.go(AppRoutes.mealLog); break;
          case 2: context.go(AppRoutes.carbCalculator); break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Icon(Icons.book_outlined),
          selectedIcon: Icon(Icons.book_rounded),
          label: 'Journal',
        ),
        NavigationDestination(
          icon: Icon(Icons.calculate_outlined),
          selectedIcon: Icon(Icons.calculate_rounded),
          label: 'Calculateur',
        ),
      ],
    );
  }
}

class _ErrorPage extends StatelessWidget {
  const _ErrorPage({this.error});
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Page introuvable : ${error?.toString()}'),
      ),
    );
  }
}
