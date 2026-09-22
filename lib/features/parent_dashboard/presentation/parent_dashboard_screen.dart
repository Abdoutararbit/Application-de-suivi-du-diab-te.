import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_dimensions.dart';

/// Écran Espace Parents — supervision, statistiques, export
class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  bool _isUnlocked = false;
  final _pinController = TextEditingController();
  String _enteredPin = '';

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Parents 👨‍👩‍👧'),
        backgroundColor: const Color(0xFF2D3748),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: const Color(0xFF1A202C),
      body: _isUnlocked ? _buildDashboard() : _buildPinScreen(),
    );
  }

  // ─── Écran de verrouillage PIN ───────────────────────────────────────────
  Widget _buildPinScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔒', style: TextStyle(fontSize: 72))
                .animate().fadeIn().scale(),
            const SizedBox(height: 24),
            Text(
              'Espace réservé aux parents',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Entrez votre code PIN pour continuer',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white54),
            ),
            const SizedBox(height: 32),
            // Affichage des points PIN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < _enteredPin.length
                        ? AppColors.primary
                        : Colors.white24,
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            // Pavé numérique
            _buildNumPad(),
          ],
        ),
      ),
    );
  }

  Widget _buildNumPad() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          ...List.generate(9, (i) => _NumPadKey(
                label: '${i + 1}',
                onTap: () => _appendPin('${i + 1}'),
              )),
          const SizedBox(),
          _NumPadKey(label: '0', onTap: () => _appendPin('0')),
          _NumPadKey(
            label: '⌫',
            onTap: _deletePin,
            isAction: true,
          ),
        ],
      ),
    );
  }

  void _appendPin(String digit) {
    if (_enteredPin.length < 4) {
      setState(() => _enteredPin += digit);
      if (_enteredPin.length == 4) _checkPin();
    }
  }

  void _deletePin() {
    if (_enteredPin.isNotEmpty) {
      setState(() => _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1));
    }
  }

  void _checkPin() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // PIN par défaut : 1234 (à sauvegarder dans flutter_secure_storage en prod)
    if (_enteredPin == '1234') {
      setState(() => _isUnlocked = true);
    } else {
      setState(() => _enteredPin = '');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Code incorrect. Réessayez.'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  // ─── Tableau de bord parent ──────────────────────────────────────────────
  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeeklySummary(),
          const SizedBox(height: AppDimensions.paddingLarge),
          _buildChildSettings(),
          const SizedBox(height: AppDimensions.paddingLarge),
          _buildExportSection(),
          const SizedBox(height: AppDimensions.paddingLarge),
          _buildAlertSettings(),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Résumé de la semaine 📊',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatBlock(label: 'Repas scannés', value: '14', icon: '📷', color: AppColors.primary),
              const SizedBox(width: 12),
              _StatBlock(label: 'Moy. glucides/jour', value: '52g', icon: '🍬', color: AppColors.warning),
              const SizedBox(width: 12),
              _StatBlock(label: 'Alertes', value: '2', icon: '🔔', color: AppColors.danger),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: AppDimensions.animMedium);
  }

  Widget _buildChildSettings() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paramètres de l\'enfant ⚙️',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          _SettingsRow(label: 'Prénom', value: 'Lucas', icon: Icons.person_rounded),
          const Divider(color: Colors.white12),
          _SettingsRow(label: 'Ratio insuline', value: '1 UI / 10g', icon: Icons.medical_services_rounded),
          const Divider(color: Colors.white12),
          _SettingsRow(label: 'Objectif glucides/jour', value: '150–200g', icon: Icons.track_changes_rounded),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: AppDimensions.animMedium);
  }

  Widget _buildExportSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exporter pour le médecin 📄',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📄 Génération du rapport PDF en cours...')),
              );
            },
            icon: const Icon(Icons.picture_as_pdf_rounded),
            label: const Text('Générer rapport PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            label: const Text('Partager avec le diabétologue', style: TextStyle(color: Colors.white)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white30),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: AppDimensions.animMedium);
  }

  Widget _buildAlertSettings() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alertes & Notifications 🔔',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          _SwitchRow(label: 'Alerte repas élevé (> 60g glucides)', initialValue: true),
          _SwitchRow(label: 'Notification repas enregistré', initialValue: true),
          _SwitchRow(label: 'Rappel repas non scanné', initialValue: false),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: AppDimensions.animMedium);
  }
}

class _NumPadKey extends StatelessWidget {
  const _NumPadKey({required this.label, required this.onTap, this.isAction = false});
  final String label;
  final VoidCallback onTap;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isAction ? Colors.transparent : const Color(0xFF4A5568),
      borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: isAction ? 24 : 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.label, required this.value, required this.icon, required this.color});
  final String label;
  final String value;
  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: Colors.white30),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatefulWidget {
  const _SwitchRow({required this.label, required this.initialValue});
  final String label;
  final bool initialValue;

  @override
  State<_SwitchRow> createState() => _SwitchRowState();
}

class _SwitchRowState extends State<_SwitchRow> {
  late bool _value;
  @override
  void initState() { super.initState(); _value = widget.initialValue; }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(widget.label, style: const TextStyle(color: Colors.white70, fontSize: 13))),
          Switch(
            value: _value,
            onChanged: (v) => setState(() => _value = v),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
