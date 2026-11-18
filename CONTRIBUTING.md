# Guide de Contribution - My FFSC

Merci de votre intérêt à contribuer à **My FFSC** ! Ce projet a pour ambition de fournir un portail applicatif de référence aux apprenants du FlutterFire Summer Camp.

---

## Directives Générales

### 1. Style de Code et Conventions
- Nous suivons les recommandations officielles [Effective Dart](https://dart.dev/guides/language/effective-dart).
- Formatage obligatoire : Exécuter `dart format .` avant de committer.
- Architecture : **Clean Architecture** avec séparation stricte des couches `data/`, `domain/`, et `presentation/`.
- Gestion d'état : **BLoC Pattern** avec `flutter_bloc`.
- Programmation fonctionnelle : `fpdart` pour la gestion des erreurs (`Either<Failure, T>`).
- Composants visuels : Police `Outfit`, palette de couleurs définies dans `AppColors`, icônes `HugeIcons` dans `AppIcons`.
- Accessibilité : Respect des standards WCAG AA/AAA pour les contrastes et les zones tactiles.

### 2. Stratégie de Branches & Protection de `main`
- 🔒 **`main`** : Branche de production protégée. **Aucun commit direct ou push forcé n'est permis.**
  - Les fusions vers `main` doivent **obligatoirement** provenir de `dev` (ou d'une branche `release/*` / `hotfix/*`).
  - Le pipeline CI bloque automatiquement toute tentative de fusion directe d'une branche de feature vers `main`.
- 🛠️ **`dev`** : Branche principale d'intégration et de staging. **C'est la branche cible obligatoire pour toutes les Pull Requests communautaires.**
- 🌿 Branches de travail :
  - Fonctionnalité : `feat/nom-de-la-feature`
  - Correctif : `fix/nom-du-bug`
  - Documentation : `docs/sujet`

---

## Workflow de Contribution

1. **Forker** le repository officiel : [github.com/FlutterFireCamp/myffsc](https://github.com/FlutterFireCamp/myffsc)
2. **Cloner** votre fork localement :
   ```bash
   git clone https://github.com/VOTRE_PSEUDO/myffsc.git
   cd myffsc
   ```
3. **Créer une branche** impérativement à partir de `dev` :
   ```bash
   git checkout -b feat/nom-de-votre-fonctionnalite dev
   ```
4. **Installer les dépendances** :
   ```bash
   flutter pub get
   ```
5. **Appliquer vos modifications et vérifier la conformité locale** :
   ```bash
   # 1. Formatage du code
   dart format --output=none --set-exit-if-changed .

   # 2. Analyse statique stricte
   flutter analyze --fatal-infos --fatal-warnings

   # 3. Exécution des tests unitaires et BLoC
   flutter test
   ```
6. **Committer** vos modifications en suivant le format [Conventional Commits](https://www.conventionalcommits.org/) :
   - `feat: ajouter la vue de détail d'une annonce`
   - `fix: corriger la synchronisation du profil utilisateur`
   - `docs: mettre à jour le guide de contribution`
7. **Pusher** vers votre fork et ouvrir une **Pull Request** vers la branche `dev` du repository principal.

---

## Critères de Validation des Pull Requests (Quality Gates)

Toute Pull Request doit valider automatiquement l'ensemble des jobs de la CI GitHub Actions avant d'être éligible à la revue et au merge :
1. **🛡️ Verify Branch Policy** : Rejet automatique si une branche hors `dev` cible directement `main`.
2. **📏 Verify code formatting** : Zéro écart avec le standard `dart format`.
3. **🧹 Analyze code** : Zéro avertissement ou erreur d'analyse statique.
4. **🧪 Run unit & BLoC tests** : Succès de 100% des tests unitaires et de widgets.
5. **🤖 Android Build Verification** : Compilation réussie de l'APK Android Debug (garantit l'absence de régression native Gradle/Kotlin/Manifest).

---

Merci pour votre engagement au service de la communauté Flutter et Firebase !
