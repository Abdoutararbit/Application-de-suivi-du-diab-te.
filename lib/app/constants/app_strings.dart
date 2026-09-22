/// Constantes textuelles et API keys de l'application GlucoPote
class AppStrings {
  AppStrings._();

  // ── App ───────────────────────────────────────────────────────────────────
  static const String appName = 'GlucoPote';
  static const String appTagline = 'Ton assistant repas malin !';

  // ── Mascotte ──────────────────────────────────────────────────────────────
  static const String mascotName = 'Glucki';
  static const String mascotGreeting = 'Salut ! Je suis Glucki 🐲\nPrêt à scanner ton repas ?';

  // ── Scan ──────────────────────────────────────────────────────────────────
  static const String scanTitle = 'Scanner mon repas';
  static const String scanSubtitle = 'Prends une photo de ton assiette !';
  static const String scanCamera = 'Prendre une photo';
  static const String scanGallery = 'Choisir depuis la galerie';
  static const String scanBarcode = 'Scanner un code-barres';
  static const String scanAnalyzing = 'Glucki analyse ton repas...';

  // ── Résultats ─────────────────────────────────────────────────────────────
  static const String resultTitle = 'Ce que j\'ai trouvé !';
  static const String resultCarbTotal = 'Total glucides';
  static const String resultSugarCubes = 'morceaux de sucre';
  static const String resultSave = 'Enregistrer mon repas';
  static const String resultAdjust = 'Ajuster les quantités';

  // ── Journal ───────────────────────────────────────────────────────────────
  static const String logTitle = 'Mon journal de repas';
  static const String logToday = 'Aujourd\'hui';
  static const String logYesterday = 'Hier';
  static const String logEmpty = 'Aucun repas enregistré.\nCommence par scanner ton assiette !';

  // ── Espace Parents ────────────────────────────────────────────────────────
  static const String parentTitle = 'Espace Parents';
  static const String parentUnlock = 'Déverrouiller avec votre code';
  static const String parentExport = 'Exporter pour le médecin';

  // ── Erreurs ───────────────────────────────────────────────────────────────
  static const String errorNetwork = 'Pas de connexion internet.\nGlucki travaille en mode hors-ligne !';
  static const String errorCamera = 'Impossible d\'accéder à la caméra.';
  static const String errorAnalysis = 'Glucki n\'a pas réussi à analyser ce repas.\nEssaie de prendre une autre photo !';
  static const String errorGeneral = 'Oups ! Quelque chose s\'est mal passé.';

  // ── Open Food Facts ───────────────────────────────────────────────────────
  static const String openFoodFactsBaseUrl = 'https://world.openfoodfacts.org/api/v2';

  // ── Clés SharedPreferences ────────────────────────────────────────────────
  static const String prefParentPin = 'parent_pin';
  static const String prefOnboardingDone = 'onboarding_done';
  static const String prefChildName = 'child_name';
  static const String prefCarbRatio = 'carb_ratio'; // g glucides / 1 unité insuline
}
