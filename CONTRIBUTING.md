# Guide de Contribution - My FFSC 💙☀️

Merci de votre intérêt à contribuer à **My FFSC 💙☀️** ! Ce projet a pour ambition de fournir un portail applicatif d'excellence aux apprenants du FlutterFire Summer Camp en Afrique Francophone.

---

## 📋 Directives Générales

### 1. Style de Code & Conventions
- Nous suivons les recommandations officielles [Effective Dart](https://dart.dev/guides/language/effective-dart).
- Architecture : **Clean Architecture** avec séparation stricte des couches `data/`, `domain/`, et `presentation/`.
- Gestion d'état : **BLoC Pattern** avec `flutter_bloc`.
- Programation fonctionnelle : `fpdart` pour la gestion des erreurs (`Either<Failure, T>`).
- Composants visuels : Police `Outfit`, palette de couleurs définies dans `AppColors`, icônes `HugeIcons` dans `AppIcons`.

### 2. Stratégie de Branches
- `main` : Branche de production protégée.
- `dev` : Branche principale d'intégration et de développement.
- Branche de fonctionnalité : `feat/nom-de-la-feature`
- Branche de correctif : `fix/nom-du-bug`
- Branche de documentation : `docs/sujet`

---

## 🛠️ Workflow de Contribution

1. **Forker** le repository officiel : [github.com/glosings0n/myffsc](https://github.com/glosings0n/myffsc)
2. **Cloner** votre fork localement :
   ```bash
   git clone https://github.com/VOTRE_PSEUDO/myffsc.git
   ```
3. **Créer une branche** à partir de `dev` :
   ```bash
   git checkout -b feat/ajout-feature-x dev
   ```
4. **Mettre à jour les dépendances** et s'assurer que tout est à jour :
   ```bash
   flutter pub outdated
   flutter pub get
   ```
5. **Appliquer vos modifications** et vérifier l'analyse du code :
   ```bash
   flutter analyze
   flutter test
   ```
6. **Committer** vos modifications en suivant le format [Conventional Commits](https://www.conventionalcommits.org/) :
   - `feat: ajouter la vue de détail d'une annonce`
   - `fix: corriger la synchronisation du photoUrl`
   - `docs: mettre à jour le fichier README`
7. **Pusher** vers votre fork et ouvrir une **Pull Request** vers la branche `dev` du repo principal.

---

## 🧪 Checks Obligatoires pour chaque PR

Toute Pull Request doit valider les étapes automatisées par le CI GitHub Actions :
1. `flutter pub outdated` (Vérification des packages obsolètes)
2. `flutter analyze` (Zéro warning ou erreur statique)
3. `flutter test` (Succès de l'ensemble des tests unitaires et de widgets)

---

Merci pour votre aide et votre engagement au service de la communauté Flutter & Firebase ! 💙☀️
