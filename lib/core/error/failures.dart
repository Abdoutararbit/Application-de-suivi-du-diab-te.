/// Classes de base pour les erreurs métier (domain failures)
abstract class Failure {
  const Failure(this.message);
  final String message;
}

/// Erreur réseau / connexion internet absente
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Pas de connexion internet.']);
}

/// Erreur lors de l'appel à l'API Vision IA
class VisionApiFailure extends Failure {
  const VisionApiFailure([super.message = 'Impossible d\'analyser ce repas.']);
}

/// Erreur lors de l'appel à Open Food Facts
class FoodDatabaseFailure extends Failure {
  const FoodDatabaseFailure([super.message = 'Aliment non trouvé dans la base.']);
}

/// Erreur de base de données locale (Drift/SQLite)
class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure([super.message = 'Erreur de base de données locale.']);
}

/// Erreur d'accès caméra / permissions
class CameraFailure extends Failure {
  const CameraFailure([super.message = 'Impossible d\'accéder à la caméra.']);
}

/// Erreur générique inattendue
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Une erreur inattendue s\'est produite.']);
}

/// Erreur d'authentification
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentification requise.']);
}
