# My FFSC 💙☀️ - Portail Apprenant FlutterFire Summer Camp

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Core%20%7C%20Auth%20%7C%20Firestore-FFCA28?logo=firebase)](https://firebase.google.com)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20BLoC-blue?logo=dart)](https://bloclibrary.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**My FFSC 💙☀️** est l'application portail officielle destinée aux apprenants du **FlutterFire Summer Camp**, un programme d'immersion totale de 3 mois et de mentorat intensif pour propulser les futurs leaders de la tech en Afrique Francophone.

> **Repository Officiel** : [https://github.com/glosings0n/myffsc.git](https://github.com/glosings0n/myffsc.git)

---

## 📸 Aperçu & Fonctionnalités

- 🔐 **Authentification & Contrôle d'Accès** : Authentification sécurisée via Google Sign-In avec vérification automatique des autorisations de l'apprenant. Les comptes en attente ou non autorisés sont redirigés vers un écran d'accès restreint.
- 🖼️ **Gestion de Profil & Niveaux** : Photo de profil Google/avatar dynamique, suivi du statut d'acceptation, liens réseaux sociaux (Discord, GitHub, LinkedIn, Twitter/X) et historique complet des évaluations avec correction interactive.
- ⚡ **Dashboard Dynamique** : Salutation personnalisée (`Salut, {First_name} 👋🏾`), suivi de progression par niveau adaptatif (Niveaux 1 à 4), résumé des points FFSC et accès rapide au programme du jour.
- 📚 **Agenda & Programmes** : Consultation des sessions, workshops, conférences et groupes d'études avec conversion automatique des horaires GMT vers le fuseau horaire de l'appareil.
- 📢 **Annonces en Temps Réel** : Fil d'actualité filtré par priorité (Urgent, Important, Info) et par niveau, avec support Markdown riche.
- 🏆 **Podium & Classement** : Classement en direct des participants avec Top 3 sur socles dorés/argentés/bronzés, suivi du Top 10 et barre sticky du rang de l'utilisateur connecté.
- 🧪 **Test & Évaluation du Jour** : Épreuve chronométrée en temps réel avec questions à choix multiples (QCM) ou ouvertes, gestion automatique du temps additionnel, détection d'arrière-plan anti-triche et soumission instantanée sur Firestore.
- 📝 **Hub de Formulaires (Expandable FAB)** : Accès rapide aux formulaires Google officiels :
  - 🚨 Signalements & alertes
  - 💬 Retours sur les sessions & ateliers
  - 💡 Idées & suggestions
  - 🎓 Soumission de projets pour validation de certificat (Dart Niv 1, Flutter Niv 2, Firebase Niv 3)

---

## 🏗️ Architecture du Projet

L'application respecte les principes stricts de la **Clean Architecture** combinée au pattern **BLoC** (*Business Logic Component*) :

```text
lib/
├── app.dart                    # MaterialApp.router & Sizer Setup
├── main.dart                   # Initialisation Firebase, GetIt & Point d'entrée
├── firebase_options.dart       # Configuration multi-plateformes Firebase
├── core/                       # Ressources globales du projet
│   ├── core.dart               # Export barrel global du noyau
│   ├── helpers/                # LevelConfig, DateTimeHelper, NetworkHelper
│   ├── routes/                 # Navigation déclarative GoRouter
│   ├── theme/                  # Couleurs centralisées (AppColors), Typo Outfit, AppRadius
│   ├── di/                     # Injection de dépendance via GetIt
│   ├── error/                  # Gestion fonctionnelle des erreurs (fpdart)
│   └── widgets/                # Composants UI partagés, EmptyState, Shimmers
└── features/                   # Modules métiers indépendants (Data, Domain, Presentation)
    ├── auth/                   # Connexion Google, synchronisation profil & vérification rôle
    ├── dashboard/              # Accueil interactif & métriques
    ├── programs/               # Agenda des sessions & filtres par type
    ├── announcements/          # Flux d'actualités & filtres
    ├── podium/                 # Classement général, Top 3 & Top 10
    ├── tests/                  # Évaluation du jour, QCM chronométré & résultats
    ├── profile/                # Profil, liens sociaux, historique d'évaluation
    ├── forms/                  # Menu FAB d'accès aux formulaires & certificats
    └── shared/                 # MainNavigationScaffold avec barre d'onglets persistante
```

---

## 🚀 Démarrage Rapide (Installation)

### Prérequis

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.x ou supérieure)
- [Dart SDK](https://dart.dev/get-dart)
- [Firebase CLI](https://firebase.google.com/docs/cli) & [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup)
- Compte Firebase configuré

### 1. Cloner le projet

```bash
git clone https://github.com/glosings0n/myffsc.git
cd myffsc
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Configurer Firebase

Assurez-vous d'activer **Google Auth** et **Cloud Firestore** sur la console Firebase de votre projet, puis exécutez :

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

### 4. Lancer l'application

```bash
# Pour Android
flutter run -d android

# Pour iOS
flutter run -d ios
```

---

## 🧪 Tests & Analyse du Code

Pour garantir la qualité du code et l'absence de régressions :

```bash
# Analyse statique du code
flutter analyze

# Lancement des tests unitaires
flutter test
```

---

## 🤝 Contribution au Projet Open-Source

Les contributions des Google Developer Experts (GDEs), mentors, développeurs Flutter et membres de la communauté sont vivement encouragées !

Consultez le fichier [CONTRIBUTING.md](CONTRIBUTING.md) pour connaître nos conventions de code, la stratégie de branches et le workflow de Pull Request.

---

## 📜 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.
