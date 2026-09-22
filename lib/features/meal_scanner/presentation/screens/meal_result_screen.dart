import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_dimensions.dart';
import '../../../../app/constants/app_strings.dart';
import '../../../../app/routes/app_router.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/meal.dart';
import '../controllers/meal_scan_notifier.dart';

/// Écran des résultats d'analyse — présentation ludique pour l'enfant
class MealResultScreen extends ConsumerStatefulWidget {
  const MealResultScreen({super.key, this.analysisData});
  final Map<String, dynamic>? analysisData;

  @override
  ConsumerState<MealResultScreen> createState() => _MealResultScreenState();
}

class _MealResultScreenState extends ConsumerState<MealResultScreen> {
  // Données de démonstration (à remplacer par les vraies données IA)
  late List<FoodItem> _foodItems;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _foodItems = _getDemoFoodItems();
  }

  List<FoodItem> _getDemoFoodItems() => [
    const FoodItem(
      id: '1', name: 'Frites maison', portionGrams: 120, carbsPer100g: 28.0, confidence: 0.92,
    ),
    const FoodItem(
      id: '2', name: 'Filet de poulet grillé', portionGrams: 150, carbsPer100g: 0.0, confidence: 0.98,
    ),
    const FoodItem(
      id: '3', name: 'Pomme', portionGrams: 130, carbsPer100g: 11.5, confidence: 0.95,
    ),
    const FoodItem(
      id: '4', name: 'Yaourt nature', portionGrams: 125, carbsPer100g: 5.0, confidence: 0.88,
    ),
  ];

  double get _totalCarbs => _foodItems.fold(0, (sum, f) => sum + f.totalCarbs);
  double get _totalSugarCubes => _totalCarbs / 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildCarbSummaryCard(),
                const SizedBox(height: AppDimensions.paddingLarge),
                _buildSugarCubesVisual(),
                const SizedBox(height: AppDimensions.paddingLarge),
                _buildFoodItemsList(),
                const SizedBox(height: AppDimensions.paddingLarge),
                _buildPortionAdjustmentSection(),
                const SizedBox(height: AppDimensions.paddingXLarge),
                _buildSaveButton(),
                const SizedBox(height: AppDimensions.paddingLarge),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          AppStrings.resultTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
        ),
        background: Container(
          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          child: const Center(
            child: Text('🍽️', style: TextStyle(fontSize: 80)),
          ),
        ),
      ),
    );
  }

  Widget _buildCarbSummaryCard() {
    final level = _totalCarbs < 20
        ? CarbLevel.low
        : _totalCarbs < 50
            ? CarbLevel.medium
            : CarbLevel.high;
    final levelColor = level == CarbLevel.low
        ? AppColors.carbLow
        : level == CarbLevel.medium
            ? AppColors.carbMedium
            : AppColors.carbHigh;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [levelColor.withValues(alpha: 0.15), levelColor.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: levelColor.withValues(alpha: 0.4), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _totalCarbs.toStringAsFixed(1),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: levelColor,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('g de', style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    'glucides',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: levelColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: levelColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
            ),
            child: Text(
              level.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: levelColor),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: AppDimensions.animMedium).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildSugarCubesVisual() {
    final cubesCount = _totalSugarCubes.round().clamp(1, 20);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('🍬', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                'Équivalent en morceaux de sucre',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(cubesCount, (i) {
              return Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: const Center(child: Text('🍬', style: TextStyle(fontSize: 18))),
              ).animate(delay: (i * 50).ms).fadeIn().scale(begin: const Offset(0, 0));
            }),
          ),
          const SizedBox(height: 8),
          Text(
            '≈ $cubesCount morceau${cubesCount > 1 ? 'x' : ''} de sucre',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: AppDimensions.animMedium);
  }

  Widget _buildFoodItemsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aliments détectés 🔍', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppDimensions.paddingMedium),
        ..._foodItems.asMap().entries.map((e) => _FoodItemCard(
              item: e.value,
              index: e.key,
              onPortionChanged: (newPortion) {
                setState(() {
                  _foodItems[e.key] = e.value.copyWith(portionGrams: newPortion);
                });
              },
            )),
      ],
    );
  }

  Widget _buildPortionAdjustmentSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tu peux ajuster les portions en glissant le curseur sur chaque aliment.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _isSaved ? null : _saveMeal,
          icon: Icon(_isSaved ? Icons.check_circle_rounded : Icons.save_rounded),
          label: Text(_isSaved ? 'Repas enregistré ! 🎉' : AppStrings.resultSave),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isSaved ? AppColors.success : AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.go(AppRoutes.home),
          icon: const Icon(Icons.home_rounded),
          label: const Text('Retour à l\'accueil'),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }

  Future<void> _saveMeal() async {
    final meal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: _foodItems,
      timestamp: DateTime.now(),
      photoPath: widget.analysisData?['imagePath'] as String?,
      notes: 'Repas scanné',
    );

    final result = await ref.read(saveMealUseCaseProvider)(meal);
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${failure.message}'),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      },
      (_) {
        ref.invalidate(mealsHistoryNotifierProvider);
        if (mounted) {
          setState(() => _isSaved = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('🎉 Repas enregistré dans ton journal !'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
    );
  }
}

/// Carte d'un aliment avec slider de portion
class _FoodItemCard extends StatefulWidget {
  const _FoodItemCard({required this.item, required this.index, required this.onPortionChanged});
  final FoodItem item;
  final int index;
  final ValueChanged<double> onPortionChanged;

  @override
  State<_FoodItemCard> createState() => _FoodItemCardState();
}

class _FoodItemCardState extends State<_FoodItemCard> {
  late double _portion;

  @override
  void initState() {
    super.initState();
    _portion = widget.item.portionGrams;
  }

  @override
  Widget build(BuildContext context) {
    final carbs = (_portion * widget.item.carbsPer100g) / 100;
    final confidence = (widget.item.confidence * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Indicateur de glucides
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: carbs < 10
                      ? AppColors.carbLow.withValues(alpha: 0.15)
                      : carbs < 25
                          ? AppColors.carbMedium.withValues(alpha: 0.15)
                          : AppColors.carbHigh.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Center(
                  child: Text(
                    '${carbs.toStringAsFixed(0)}g',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: carbs < 10
                              ? AppColors.carbLow
                              : carbs < 25
                                  ? AppColors.carbMedium
                                  : AppColors.carbHigh,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.item.name, style: Theme.of(context).textTheme.titleMedium),
                    Row(
                      children: [
                        Text(
                          '${_portion.toInt()}g',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          ),
                          child: Text(
                            '🎯 $confidence%',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 11,
                                  color: AppColors.primaryDark,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Slider de portion
          if (widget.item.carbsPer100g > 0) ...[
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.primaryLight,
                thumbColor: AppColors.primary,
                overlayColor: AppColors.primary.withValues(alpha: 0.15),
                trackHeight: 4,
              ),
              child: Slider(
                value: _portion,
                min: 10,
                max: 500,
                divisions: 49,
                onChanged: (val) {
                  setState(() => _portion = val);
                  widget.onPortionChanged(val);
                },
              ),
            ),
          ],
        ],
      ),
    ).animate(delay: (widget.index * 100).ms).fadeIn().slideX(begin: 0.1);
  }
}
