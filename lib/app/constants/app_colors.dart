import 'package:flutter/material.dart';

/// Palette de couleurs GlucoPote — douce, ludique et rassurante pour l'enfant
class AppColors {
  AppColors._();

  // ── Couleurs Primaires ─────────────────────────────────────────────────────
  static const Color primary = Color(0xFF4ECDC4);      // Turquoise doux
  static const Color primaryDark = Color(0xFF2BB3AA);
  static const Color primaryLight = Color(0xFFB2EBE8);

  static const Color secondary = Color(0xFFFF6B6B);    // Corail chaleureux
  static const Color secondaryDark = Color(0xFFE05555);
  static const Color secondaryLight = Color(0xFFFFB3B3);

  static const Color accent = Color(0xFFFFE66D);       // Jaune soleil
  static const Color accentDark = Color(0xFFE6CC56);

  // ── Couleurs Fonctionnelles ───────────────────────────────────────────────
  static const Color success = Color(0xFF6BCB77);      // Vert succès
  static const Color warning = Color(0xFFFFD166);      // Jaune alerte
  static const Color danger = Color(0xFFEF4444);       // Rouge danger
  static const Color info = Color(0xFF74B9FF);         // Bleu info

  // ── Glucides (Indicateur) ─────────────────────────────────────────────────
  static const Color carbLow = Color(0xFF6BCB77);      // < 20g glucides  → vert
  static const Color carbMedium = Color(0xFFFFD166);   // 20-50g glucides → jaune
  static const Color carbHigh = Color(0xFFFF6B6B);     // > 50g glucides  → rouge

  // ── Fond & Surfaces ───────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8FFFE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0FFFE);
  static const Color cardBg = Color(0xFFFFFFFF);

  // ── Textes ────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A2E35);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFFB5C2C9);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4ECDC4), Color(0xFF44A1A0)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF0FFFE)],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFEF4444)],
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF6BCB77), Color(0xFF4CAF50)],
  );
}
