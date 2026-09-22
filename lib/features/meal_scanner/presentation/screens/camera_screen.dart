import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_dimensions.dart';
import '../../../../app/constants/app_strings.dart';
import '../../../../app/routes/app_router.dart';

/// Écran caméra — Photo du repas ou scan code-barres
class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  bool _isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Fond sombre avec cadre de scan ─────────────────────────────
            _buildCameraViewPlaceholder(),

            // ── Barre supérieure ────────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopBar(context),
            ),

            // ── Instruction Glucki ──────────────────────────────────────────
            if (!_isAnalyzing)
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: _buildMascotInstruction(),
              ),

            // ── Overlay d'analyse ───────────────────────────────────────────
            if (_isAnalyzing) _buildAnalyzingOverlay(),

            // ── Boutons du bas ──────────────────────────────────────────────
            if (!_isAnalyzing)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomActions(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraViewPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF1A1A2E),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📷', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            Text(
              'Caméra en cours d\'initialisation...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white54,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              AppStrings.scanTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildMascotInstruction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: Row(
          children: [
            const Text('🐲', style: TextStyle(fontSize: 32)),
            const SizedBox(width: AppDimensions.paddingSmall),
            Expanded(
              child: Text(
                'Centre bien ton assiette dans le cadre\net appuie sur le bouton ! 📸',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: AppDimensions.animMedium).slideY(begin: -0.2),
    );
  }

  Widget _buildAnalyzingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🐲', style: TextStyle(fontSize: 80))
                .animate(onPlay: (c) => c.repeat())
                .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 800.ms)
                .then()
                .scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1), duration: 800.ms),
            const SizedBox(height: 24),
            Text(
              AppStrings.scanAnalyzing,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withValues(alpha: 0.85), Colors.transparent],
        ),
      ),
      child: Column(
        children: [
          // Bouton principal de prise de photo
          _BigCaptureButton(onTap: _takePicture),
          const SizedBox(height: AppDimensions.paddingMedium),
          // Boutons secondaires
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SecondaryButton(
                icon: Icons.photo_library_rounded,
                label: 'Galerie',
                onTap: _pickFromGallery,
              ),
              _SecondaryButton(
                icon: Icons.qr_code_scanner_rounded,
                label: 'Code-barres',
                onTap: _scanBarcode,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: AppDimensions.animMedium).slideY(begin: 0.2);
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (image != null && mounted) {
      _simulateAnalysis(image.path);
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null && mounted) {
      _simulateAnalysis(image.path);
    }
  }

  Future<void> _scanBarcode() async {
    // TODO: intégrer mobile_scanner
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Scanner code-barres — bientôt disponible !')),
      );
    }
  }

  Future<void> _simulateAnalysis(String imagePath) async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulation d'un délai d'analyse IA (à remplacer par l'appel réel)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      context.push(AppRoutes.mealResult, extra: {
        'imagePath': imagePath,
        'fromCamera': true,
      });
      setState(() => _isAnalyzing = false);
    }
  }
}

class _BigCaptureButton extends StatelessWidget {
  const _BigCaptureButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: AppColors.primary, width: 4),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.5),
              blurRadius: 15,
              spreadRadius: 3,
            )
          ],
        ),
        child: const Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 36),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: Colors.white30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
