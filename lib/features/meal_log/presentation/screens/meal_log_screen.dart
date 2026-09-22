import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_dimensions.dart';
import '../../../meal_scanner/domain/entities/meal.dart';
import '../../../meal_scanner/presentation/controllers/meal_scan_notifier.dart';

/// Écran Journal de repas — Historique chronologique
class MealLogScreen extends ConsumerWidget {
  const MealLogScreen({super.key});

  // Données de démo si l'historique est vide
  List<Meal> get _demoMeals => [
    Meal(
      id: '1',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      items: const [],
      photoPath: null,
      notes: 'Déjeuner',
    ),
    Meal(
      id: '2',
      timestamp: DateTime.now().subtract(const Duration(hours: 7)),
      items: const [],
      notes: 'Petit-déjeuner',
    ),
    Meal(
      id: '3',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      items: const [],
      notes: 'Dîner',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(mealsHistoryNotifierProvider);
    final meals = mealsAsync.valueOrNull ?? [];
    final allMeals = meals.isNotEmpty ? meals : _demoMeals;

    final today = DateTime.now();
    final todayMeals = allMeals.where((m) =>
        m.timestamp.year == today.year &&
        m.timestamp.month == today.month &&
        m.timestamp.day == today.day).toList();
    final pastMeals = allMeals.where((m) => !todayMeals.contains(m)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Journal 📒'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(mealsHistoryNotifierProvider.notifier).loadMeals(),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          _WeeklyCarbChart(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              children: [
                _buildDaySection(context, 'Aujourd\'hui 🌟', todayMeals.isNotEmpty ? todayMeals : allMeals.take(2).toList()),
                const SizedBox(height: AppDimensions.paddingLarge),
                if (pastMeals.isNotEmpty)
                  _buildDaySection(context, 'Précédemment', pastMeals),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySection(BuildContext context, String title, List<Meal> meals) {
    final dayTotalCarbs = meals.fold<double>(
      0.0,
      (sum, m) => sum + (m.items.isNotEmpty ? m.totalCarbs : 30.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
              ),
              child: Text(
                '${dayTotalCarbs.toStringAsFixed(0)}g glucides',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: AppColors.primaryDark),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...meals.asMap().entries.map((e) {
          final meal = e.value;
          final foodNames = meal.items.isNotEmpty
              ? meal.items.map((i) => i.name).toList()
              : (e.key == 0
                  ? ['Frites', 'Poulet', 'Pomme']
                  : e.key == 1
                      ? ['Céréales', 'Lait', 'Orange']
                      : ['Pâtes bolognaise', 'Salade']);
          final carbs = meal.items.isNotEmpty ? meal.totalCarbs : (e.key == 0 ? 45.0 : 20.0);

          return _MealLogCard(
            meal: meal,
            foodNames: foodNames,
            totalCarbs: carbs,
            index: e.key,
          );
        }),
      ],
    );
  }
}

class _WeeklyCarbChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Données fictives pour la semaine
    final weekData = [42.0, 65.0, 38.0, 72.0, 55.0, 48.0, 65.0];
    final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final maxCarb = weekData.reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingLarge),
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cette semaine 📊',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final height = (weekData[i] / maxCarb) * 60;
                final isToday = i == 6;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 28,
                      height: height,
                      decoration: BoxDecoration(
                        color: isToday ? AppColors.accent : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      days[i],
                      style: TextStyle(
                        color: isToday ? AppColors.accent : Colors.white70,
                        fontSize: 12,
                        fontWeight: isToday ? FontWeight.w800 : FontWeight.w400,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: AppDimensions.animMedium);
  }
}

class _MealLogCard extends StatelessWidget {
  const _MealLogCard({
    required this.meal,
    required this.foodNames,
    required this.totalCarbs,
    required this.index,
  });
  final Meal meal;
  final List<String> foodNames;
  final double totalCarbs;
  final int index;

  @override
  Widget build(BuildContext context) {
    final time = '${meal.timestamp.hour.toString().padLeft(2, '0')}:${meal.timestamp.minute.toString().padLeft(2, '0')}';
    final level = totalCarbs < 20
        ? AppColors.carbLow
        : totalCarbs < 50
            ? AppColors.carbMedium
            : AppColors.carbHigh;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          // Indicateur heure
          Column(
            children: [
              Text(
                time,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.primary),
              ),
              Container(
                width: 3,
                height: 20,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.notes ?? 'Repas',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  foodNames.join(' • '),
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Glucides
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: level.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Text(
              '${totalCarbs}g',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: level, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: 0.05);
  }
}
