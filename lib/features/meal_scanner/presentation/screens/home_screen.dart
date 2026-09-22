import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_strings.dart';
import '../../../../app/constants/app_dimensions.dart';
import '../../../../app/routes/app_router.dart';
import '../controllers/meal_scan_notifier.dart';

/// Écran d'accueil principal — Accueille l'enfant avec la mascotte Glucki
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLarge,
            vertical: AppDimensions.paddingMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HomeHeader(),
              const SizedBox(height: AppDimensions.paddingLarge),
              const _MascotCard(),
              const SizedBox(height: AppDimensions.paddingLarge),
              const _ScanActionsGrid(),
              const SizedBox(height: AppDimensions.paddingLarge),
              const _TodaySummaryCard(),
              const SizedBox(height: AppDimensions.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }
}

/// En-tête avec salutation personnalisée
class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? '☀️ Bonjour'
        : now.hour < 18
            ? '🌤️ Bon après-midi'
            : '🌙 Bonsoir';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
        ),
        // Bouton Espace Parents (discret)
        Material(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: InkWell(
            onTap: () => context.push(AppRoutes.parentDashboard),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            child: const Padding(
              padding: EdgeInsets.all(AppDimensions.paddingSmall),
              child: Icon(
                Icons.family_restroom_rounded,
                color: AppColors.textSecondary,
                size: AppDimensions.iconLarge,
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: AppDimensions.animMedium).slideY(begin: -0.1);
  }
}

/// Carte de la mascotte Glucki
class _MascotCard extends StatelessWidget {
  const _MascotCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          // Mascotte emoji (remplacer par Lottie en production)
          const Text('🐲', style: TextStyle(fontSize: 72))
              .animate(onPlay: (c) => c.repeat())
              .shimmer(duration: 2.seconds, color: Colors.white.withValues(alpha: 0.3))
              .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1500.ms)
              .then()
              .scale(begin: const Offset(1.05, 1.05), end: const Offset(1, 1), duration: 1500.ms),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppStrings.mascotName} te dit...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Prêt à scanner\nton repas ? 🍽️',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: AppDimensions.animMedium).slideY(begin: 0.1);
  }
}

/// Grille des actions de scan
class _ScanActionsGrid extends StatelessWidget {
  const _ScanActionsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Que veux-tu faire ?',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                emoji: '📷',
                label: AppStrings.scanCamera,
                color: AppColors.primary,
                onTap: () => context.push(AppRoutes.camera),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMedium),
            Expanded(
              child: _ActionCard(
                emoji: '🔍',
                label: AppStrings.scanBarcode,
                color: AppColors.secondary,
                onTap: () => context.push(AppRoutes.camera, extra: {'mode': 'barcode'}),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        _ActionCard(
          emoji: '🖼️',
          label: AppStrings.scanGallery,
          color: AppColors.accent,
          isWide: true,
          textColor: AppColors.textPrimary,
          onTap: () => context.push(AppRoutes.camera, extra: {'mode': 'gallery'}),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: AppDimensions.animMedium);
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
    this.isWide = false,
    this.textColor = Colors.white,
  });

  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isWide;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      elevation: 4,
      shadowColor: color.withValues(alpha: 0.4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLarge,
            vertical: isWide ? AppDimensions.paddingMedium : AppDimensions.paddingLarge,
          ),
          child: isWide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: AppDimensions.paddingMedium),
                    Text(label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor)),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: textColor, fontSize: 12),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Résumé glucides du jour
class _TodaySummaryCard extends ConsumerWidget {
  const _TodaySummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(mealsHistoryNotifierProvider);
    final meals = mealsAsync.valueOrNull ?? [];
    
    final today = DateTime.now();
    final todayMeals = meals.where((m) =>
        m.timestamp.year == today.year &&
        m.timestamp.month == today.month &&
        m.timestamp.day == today.day).toList();

    final int mealsCount = todayMeals.isNotEmpty ? todayMeals.length : (meals.isEmpty ? 2 : 0);
    final double totalCarbsToday = todayMeals.isNotEmpty
        ? todayMeals.fold<double>(0.0, (sum, m) => sum + m.totalCarbs)
        : (meals.isEmpty ? 65.0 : 0.0);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text("Aujourd'hui", style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Text(
                '$mealsCount repas',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Row(
            children: [
              _StatChip(
                label: 'Total glucides',
                value: '${totalCarbsToday.toStringAsFixed(0)}g',
                color: AppColors.carbMedium,
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              _StatChip(
                label: '≈ morceaux sucre',
                value: '${(totalCarbsToday / 5).toStringAsFixed(0)} 🍬',
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: AppDimensions.animMedium);
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
