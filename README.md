# My FFSC 💙☀️ - Portail Apprenant FlutterFire Summer Camp

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Core%20%7C%20Auth%20%7C%20Firestore-FFCA28?logo=firebase)](https://firebase.google.com)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20BLoC-blue?logo=dart)](https://bloclibrary.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**My FFSC 💙☀️** est l'application portail officielle destinée aux apprenants du **FlutterFire Summer Camp**, un programme d'immersion totale de 3 mois et de mentorat intensif pour propulser les futurs leaders de la tech en Afrique Francophone.

> **Repository Officiel** : [https://github.com/glosings0n/myffsc.git](https://github.com/glosings0n/myffsc.git)

---

## 📸 Aperçu & Fonctionnalités

- 🔐 **Authentication Google & Protection** : Authentification via Google Provider avec vérification en arrière-plan du rôle (`role: student`) et du statut (`status: accepted`). Les utilisateurs non autorisés sont redirigés vers un écran d'accès restreint.
- 🖼️ **Synchronisation automatique de la photo Google** : Lors de la première connexion, la photo de profil Google (`photoUrl`) est synchronisée directement dans le document Firestore de l'apprenant.
- ⚡ **Dashboard dynamique** : Salutation personnalisée (`Salut, {First_name} 👋🏾`), suivi de la progression par niveaux (Niveaux 1 à 4), résumé des points FFSC et lien vers la prochaine session live.
- 📚 **Programme d'Immersion** : Détail des modules et accès direct aux liens de sessions Meet live ou aux replays vidéo.
- 📢 **Annonces du Camp** : Fil d'actualité en temps réel filtré par priorité (Urgent, Important, Info) et par niveau.
- 📝 **Hub de Formulaires (Expandable FAB)** : Floating Action Button extensible permettant de soumettre :
  - 🚀 Standups hebdomadaires
  - 💻 Rendu de projets / liens GitHub
  - 💬 Feedback & mentorat
  - 💡 Idées & suggestions
  - 🚨 Signalements et alertes (abus / blocages)
- 🧪 **Tests & Évaluations QCM** : Quiz interactifs chronométrés avec calcul du score en temps réel et explications détaillées des réponses.
- 👤 **Profil Apprenant** : Badges, informations personnelles, indicateurs de points et déconnexion sécurisée.

---

## 🏗️ Architecture du Projet

L'application respecte les principes de la **Clean Architecture** combinée au pattern **BLoC** (*Business Logic Component*) :

```text
lib/
├── app.dart                    # MaterialApp.router & Sizer Setup
├── main.dart                   # Initialisation Firebase, GetIt & Point d'entrée
├── firebase_options.dart       # Configuration multi-plateformes Firebase
├── core/                       # Ressources globales de l'application
│   ├── core.dart               # Export barrel global du noyau
│   ├── routes/                 # Gestion des routes via GoRouter
│   │   ├── route_names.dart    # Noms des routes
│   │   ├── route_paths.dart    # Paths des routes
│   │   ├── routes_config.dart  # Redirections réactives & StatefulShellRoute
│   │   └── routes.dart         # Barrel d'exportation des routes
│   ├── theme/                  # Couleurs (#070A13), Icônes (HugeIcons), Outfit Font
│   ├── di/                     # Injection de dépendance via GetIt
│   ├── error/                  # Gestion fonctionnelle des erreurs (fpdart)
│   └── utils/                  # Classes de base (UseCase)
└── features/                   # Fonctionnalités métier découpées (Data, Domain, Presentation)
    ├── auth/
    ├── dashboard/
    ├── programs/
    ├── announcements/
    ├── forms/                  # Contient les widgets Expandable FAB
    ├── tests/
    ├── profile/
    └── shared/                 # Bottom Navigation Scaffold réutilisable
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
