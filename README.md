# 🍏 GlucoPote — Assistant Nutritionnel & Repas pour Enfants Diabétiques

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.27.4-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.6+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Architecture-Clean%20%2B%20Feature--First-success?style=for-the-badge" alt="Clean Architecture">
  <img src="https://img.shields.io/badge/State%20Management-Riverpod-blueviolet?style=for-the-badge" alt="Riverpod">
  <img src="https://img.shields.io/badge/Licence-MIT-green?style=for-the-badge" alt="Licence">
</p>

---

## 📖 Présentation du Projet

**GlucoPote** est une application mobile conçue pour accompagner les **enfants atteints de diabète de type 1** ainsi que leurs parents dans la gestion quotidienne de leur alimentation.

L'objectif principal est de **rendre le comptage des glucides intuitif, éducatif et rassurant**, tout en déchargeant l'enfant du stress lié aux calculs mathématiques et aux injections d'insuline. Accompagné par **Glucki**, un petit dragon bienveillant, l'enfant devient acteur de son équilibre glycémique en s'amusant.

---

## 🌟 Fonctionnalités Principales

### 1. 📸 Scan Intelligent de Repas (IA Vision)
- **Capture photo** du plateau ou de l'assiette.
- **Reconnaissance automatique des aliments** et estimation des portions (en grammes) grâce à l'IA Vision (Google Gemini 1.5 Flash).
- **Scanner de code-barres intégré** s'appuyant sur la base libre Open Food Facts pour les produits industriels emballés.
- **Ajustement manuel rapide** : curseurs intuitifs de portion permettant à l'enfant ou au parent d'ajuster facilement le grammage.

### 2. 🍬 Visualisation Pédagogique « Morceaux de Sucre »
- Les grammes de glucides sont souvent abstraits pour un enfant.
- GlucoPote convertit automatiquement chaque total en **morceaux de sucre équivalents** (1 morceau ≈ 5 g de glucides).
- Code couleur ludique et rassurant :
  - 🟢 **Vert** : Moins de 20 g de glucides (léger)
  - 🟡 **Jaune** : Entre 20 g et 50 g de glucides (modéré)
  - 🔴 **Orange/Rouge** : Plus de 50 g de glucides (repas copieux)

### 3. 🧮 Calculateur de Glucides & Ratio Insuline
- Calcul automatique de la **dose d'insuline rapide suggérée** selon le ratio prescrit par le médecin (ex: 1 unité pour 10g de glucides).
- **Avertissement médical permanent** rappelant que toute dose doit être validée par un adulte ou un professionnel de santé.

### 4. 📒 Journal de Bord & Suivi Historique
- Enregistrement automatique de tous les repas validés (heure, aliments détectés, photo, glucides totaux).
- **Graphique hebdomadaire** pour visualiser l'évolution des apports glucidiques jour après jour.
- Fonctionnement **100% hors-ligne (Offline-First)** : les repas sont sauvegardés localement même sans réseau internet.

### 5. 👨‍👩‍👧 Espace Parents Sécurisé
- Protégé par un **code PIN** (ou biométrie) pour éviter les fausses manipulations par l'enfant.
- Configuration personnalisée des ratios d'insuline par tranche horaire (Matin, Midi, Goûter, Soir).
- Fiche de secours d'urgence (coordonnées des parents, du diabétologue, protocole en cas d'hypoglycémie).
- Exportation de rapports détaillés au format PDF pour les consultations médicales.

---

## 🏗️ Architecture & Technologies

Le projet respecte scrupuleusement les principes de la **Clean Architecture** combinée à une approche **Feature-First** (organisation par fonctionnalité) :

```text
lib/
├── app/                          # Configuration globale de l'application
│   ├── constants/                # Couleurs, dimensions, chaînes de caractères (FR)
│   ├── routes/                   # Navigation GoRouter avec ShellRoute & BottomNav
│   ├── theme/                    # Design System Material 3 (Baloo 2 + Nunito)
│   └── app.dart                  # Widget racine MaterialApp.router
│
├── core/                         # Utilitaires et fondations transversales
│   ├── error/                    # Gestion typée des pannes (Failures fonctionnels)
│   └── network/                  # Client Dio robuste, timeouts & logs
│
└── features/                     # Modules fonctionnels indépendants
    ├── meal_scanner/             # Scan photo IA & code-barres OpenFoodFacts
    │   ├── data/                 # Modèles JSON, sources Gemini & OpenFoodFacts, Repo Impl
    │   ├── domain/               # Entités (FoodItem, Meal), Contrats & UseCases
    │   └── presentation/         # Écrans (Accueil, Caméra, Résultat) & Notifier Riverpod
    ├── meal_log/                 # Journal de bord & historique des repas
    │   ├── data/                 # Datasource locale persistante (Offline-first)
    │   └── presentation/         # Écran historique & Graphique hebdomadaire
    ├── carb_calculator/          # Calculateur de ratio d'insuline pédiatrique
    └── parent_dashboard/         # Espace parents protégé par code PIN
```

### Stack Technique :
| Composant | Technologie retenue |
|---|---|
| **Framework** | Flutter 3.27.4 (Dart 3) |
| **Gestion d'état** | Flutter Riverpod (`StateNotifierProvider`) |
| **Routage** | GoRouter (Deep linking, navigation déclarative) |
| **Client HTTP** | Dio (Interceptors, timeouts) |
| **Typographie** | Google Fonts (`Baloo 2` pour les titres, `Nunito` pour le texte) |
| **Animations** | Flutter Animate & Lottie |
| **Persistance locale** | Fichiers JSON locaux & SQLite / Drift |
| **Sécurité** | Flutter Secure Storage & Local Auth (Biométrie) |
| **Tests** | Flutter Test (Suite de tests unitaires métier) |

---

## 🚀 Installation & Lancement

### Prérequis
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.20 ou supérieure, testé sur 3.27.4)
- [Android Studio](https://developer.android.com/studio) avec les outils de plateforme Android SDK
- Git installé sur votre machine

### 1. Cloner le dépôt
```bash
git clone https://github.com/Abdoutararbit/Application-de-suivi-du-diab-te..git
cd "Application-de-suivi-du-diab-te"
```

### 2. Installer les dépendances
```bash
flutter pub get
```

### 3. Exécuter l'analyse du code
```bash
flutter analyze
```
*(Le projet est configuré pour avoir **0 erreur et 0 avertissement**).*

### 4. Lancer la suite de tests
```bash
flutter test
```

---

## 📱 Lancer l'application sur votre téléphone Android

### Méthode 1 : Connexion USB directe (Recommandée)

1. **Activer le mode Développeur sur votre téléphone Android** :
   - Allez dans **Paramètres** > **À propos du téléphone**.
   - Tapez **7 fois** de suite sur **« Numéro de build »** jusqu'à voir le message *"Vous êtes désormais développeur !"*.
2. **Activer le débogage USB** :
   - Allez dans **Paramètres** > **Système** (ou Options avancées) > **Options pour les développeurs**.
   - Activez l'option **« Débogage USB »**.
3. **Brancher le téléphone à l'ordinateur avec un câble USB** :
   - Sur l'écran de votre téléphone, une invite apparaîtra : cochez *« Toujours autoriser depuis cet ordinateur »* et appuyez sur **Autoriser**.
4. **Vérifier la détection du téléphone** :
   ```bash
   flutter devices
   ```
   Votre modèle de téléphone (Samsung, Xiaomi, etc.) doit apparaître dans la liste.
5. **Lancer l'application** :
   ```bash
   flutter run
   ```

*(Optionnel) Pour activer l'analyse réelle par IA avec votre propre clé Google Gemini :*
```bash
flutter run --dart-define=GEMINI_API_KEY="VOTRE_CLE_GEMINI_ICI"
```

---

## ⚠️ Avertissement Médical Important

> [!IMPORTANT]
> **GlucoPote est un outil d'assistance et d'éducation thérapeutique**, il ne constitue en aucun cas un dispositif médical de prescription automatique.
> Les estimations nutritionnelles et les calculs de doses d'insuline fournis doivent impérativement être vérifiés par un adulte référent avant toute injection. Consultez toujours l'équipe soignante pédiatrique pour définir les ratios adaptés à l'enfant.

---

## 👤 Auteur & Contribution

- **Développeur** : [Abdenour Tararbit](https://github.com/Abdoutararbit)
- **Projet** : Application de suivi du diabète pédiatrique (*GlucoPote*)
- **Codebase** : [GitHub Repository](https://github.com/Abdoutararbit/Application-de-suivi-du-diab-te..git)

N'hésitez pas à ouvrir une issue ou proposer une pull request pour améliorer l'expérience des enfants et de leurs familles ! 💙
