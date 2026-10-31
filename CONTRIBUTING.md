# Guide de Contribution - My FFSC

Merci de votre intérêt à contribuer à **My FFSC** ! Ce projet a pour ambition de fournir un portail applicatif de référence aux apprenants du FlutterFire Summer Camp.

---

## Directives Générales

### 1. Style de Code et Conventions
- Nous suivons les recommandations officielles [Effective Dart](https://dart.dev/guides/language/effective-dart).
- Architecture : **Clean Architecture** avec séparation stricte des couches `data/`, `domain/`, et `presentation/`.
- Gestion d'état : **BLoC Pattern** avec `flutter_bloc`.
- Programmation fonctionnelle : `fpdart` pour la gestion des erreurs (`Either<Failure, T>`).
- Composants visuels : Police `Outfit`, palette de couleurs définies dans `AppColors`, icônes `HugeIcons` dans `AppIcons`.
- Accessibilité : Respect des standards WCAG AA/AAA pour les contrastes et les zones tactiles.

### 2. Stratégie de Branches
- `main` : Branche de production protégée.
- `dev` : Branche principale d'intégration et de développement.
- Branche de fonctionnalité : `feat/nom-de-la-feature`
- Branche de correctif : `fix/nom-du-bug`
- Branche de documentation : `docs/sujet`

---

## Workflow de Contribution

1. **Forker** le repository officiel : [github.com/FlutterFireCamp/myffsc](https://github.com/FlutterFireCamp/myffsc)
2. **Cloner** votre fork localement :
   ```bash
   git clone https://github.com/VOTRE_PSEUDO/myffsc.git
   cd myffsc
   ```
3. **Créer une branche** à partir de `dev` :
   ```bash
   git checkout -b feat/nom-de-votre-fonctionnalite dev
   ```
4. **Installer les dépendances** :
   ```bash
   flutter pub get
   ```
5. **Appliquer vos modifications** et vérifier l'analyse du code :
   ```bash
   flutter analyze
   flutter test
   ```
6. **Committer** vos modifications en suivant le format [Conventional Commits](https://www.conventionalcommits.org/) :
   - `feat: ajouter la vue de détail d'une annonce`
   - `fix: corriger la synchronisation du profil utilisateur`
   - `docs: mettre à jour le guide de contribution`
7. **Pusher** vers votre fork et ouvrir une **Pull Request** vers la branche `dev` du repository principal.

---

## Critères de Validation des Pull Requests

Toute Pull Request doit valider les étapes automatisées par le CI GitHub Actions :
1. `flutter analyze` : Zéro avertissement ou erreur d'analyse statique.
2. `flutter test` : Succès de l'ensemble des tests unitaires et de widgets.
3. Respect strict de la séparation des responsabilités (Clean Architecture).

---

Merci pour votre engagement au service de la communauté Flutter et Firebase.
