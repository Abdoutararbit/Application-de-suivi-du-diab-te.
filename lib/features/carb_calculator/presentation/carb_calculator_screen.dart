import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_dimensions.dart';

/// Écran Calculateur de glucides & ratio insuline
class CarbCalculatorScreen extends StatefulWidget {
  const CarbCalculatorScreen({super.key});

  @override
  State<CarbCalculatorScreen> createState() => _CarbCalculatorScreenState();
}

class _CarbCalculatorScreenState extends State<CarbCalculatorScreen> {
  double _carbGrams = 0;
  double _carbRatio = 10; // 1 unité d'insuline pour X grammes de glucides
  final _carbController = TextEditingController();

  double get _insulinDose => _carbRatio > 0 ? _carbGrams / _carbRatio : 0;

  @override
  void dispose() {
    _carbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculateur 🧮')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMascotTip(context),
            const SizedBox(height: AppDimensions.paddingLarge),
            _buildCarbInput(context),
            const SizedBox(height: AppDimensions.paddingLarge),
            _buildRatioSelector(context),
            const SizedBox(height: AppDimensions.paddingLarge),
            _buildResultCard(context),
            const SizedBox(height: AppDimensions.paddingLarge),
            _buildMedicalDisclaimer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMascotTip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Row(
        children: [
          const Text('🐲', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Entre le total de glucides de ton repas\npour estimer ta dose d\'insuline.',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: AppDimensions.animMedium);
  }

  Widget _buildCarbInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Grammes de glucides', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        TextField(
          controller: _carbController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Ex: 45',
            suffixText: 'g',
            prefixIcon: const Icon(Icons.grain_rounded, color: AppColors.primary),
            labelText: 'Glucides totaux du repas',
          ),
          onChanged: (v) {
            setState(() => _carbGrams = double.tryParse(v) ?? 0);
          },
        ),
        const SizedBox(height: 16),
        // Slider rapide
        Text(
          '${_carbGrams.toStringAsFixed(0)}g',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primary),
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.primaryLight,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.15),
            trackHeight: 6,
          ),
          child: Slider(
            value: _carbGrams.clamp(0, 200),
            min: 0,
            max: 200,
            divisions: 40,
            onChanged: (v) {
              setState(() {
                _carbGrams = v;
                _carbController.text = v.toStringAsFixed(0);
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _QuickCarbChip(label: '15g', onTap: () => _setCarbs(15)),
            _QuickCarbChip(label: '30g', onTap: () => _setCarbs(30)),
            _QuickCarbChip(label: '45g', onTap: () => _setCarbs(45)),
            _QuickCarbChip(label: '60g', onTap: () => _setCarbs(60)),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 100.ms, duration: AppDimensions.animMedium);
  }

  void _setCarbs(double val) {
    setState(() {
      _carbGrams = val;
      _carbController.text = val.toStringAsFixed(0);
    });
  }

  Widget _buildRatioSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Ratio insuline/glucides', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Défini par votre médecin — 1 unité d\'insuline pour X grammes de glucides',
              child: const Icon(Icons.info_outline_rounded, color: AppColors.textSecondary, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          ),
          child: Column(
            children: [
              Text(
                '1 unité ↔ ${_carbRatio.toStringAsFixed(0)}g glucides',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.primary),
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.secondary,
                  inactiveTrackColor: AppColors.secondaryLight,
                  thumbColor: AppColors.secondary,
                  overlayColor: AppColors.secondary.withValues(alpha: 0.15),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: _carbRatio,
                  min: 5,
                  max: 30,
                  divisions: 25,
                  onChanged: (v) => setState(() => _carbRatio = v),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('5g (sensible)', style: Theme.of(context).textTheme.bodyMedium),
                  Text('30g (résistant)', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: AppDimensions.animMedium);
  }

  Widget _buildResultCard(BuildContext context) {
    final dose = _insulinDose;
    final hasResult = _carbGrams > 0;

    return AnimatedContainer(
      duration: AppDimensions.animMedium,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: hasResult ? AppColors.heroGradient : const LinearGradient(colors: [Color(0xFFEEEEEE), Color(0xFFEEEEEE)]),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: hasResult
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))]
            : [],
      ),
      child: Column(
        children: [
          Text(
            'Dose estimée',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: hasResult ? Colors.white70 : AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            hasResult ? '${dose.toStringAsFixed(1)} UI' : '— UI',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: hasResult ? Colors.white : AppColors.textDisabled,
                  fontWeight: FontWeight.w900,
                ),
          ),
          if (hasResult) ...[
            const SizedBox(height: 8),
            Text(
              '${_carbGrams.toStringAsFixed(0)}g ÷ ${_carbRatio.toStringAsFixed(0)}g/UI',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicalDisclaimer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ce calcul est une aide uniquement. Vérifie toujours la dose avec ton médecin ou tes parents avant d\'injecter.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: const Color(0xFF92610A)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }
}

class _QuickCarbChip extends StatelessWidget {
  const _QuickCarbChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primaryDark),
        ),
      ),
    );
  }
}
