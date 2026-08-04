import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/complete_profile_header.dart';

class CompleteProfilePage extends StatefulWidget {
  final UserEntity? user;

  const CompleteProfilePage({super.key, this.user});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _discordController;
  late TextEditingController _townController;

  String? _selectedGender;
  String? _selectedCountry;
  String _hasNextFlutterPremium = 'Non';
  String? _selectedHub;

  bool _isSubmitting = false;

  static const List<String> _genderOptions = AppDataConstants.genderOptions;
  static const List<String> _premiumOptions = AppDataConstants.yesNoOptions;
  static const List<String> _hubOptions = AppDataConstants.hubOptions;
  static const List<String> _africanCountries = AppDataConstants.africanCountries;

  @override
  void initState() {
    super.initState();
    final currentUser = widget.user;
    _nameController = TextEditingController(
      text: currentUser?.name == 'Apprenant FFSC' ? '' : (currentUser?.name ?? ''),
    );
    _discordController = TextEditingController(
      text: currentUser?.discordUsername ?? '',
    );
    _townController = TextEditingController(text: currentUser?.town ?? '');

    if (currentUser?.gender != null && _genderOptions.contains(currentUser!.gender)) {
      _selectedGender = currentUser.gender;
    }

    if (currentUser?.country != null && _africanCountries.contains(currentUser!.country)) {
      _selectedCountry = currentUser.country!;
    }

    final existingHub = currentUser?.hub ?? currentUser?.community;
    if (existingHub != null && _hubOptions.contains(existingHub)) {
      _selectedHub = existingHub;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _discordController.dispose();
    _townController.dispose();
    super.dispose();
  }

  Future<void> _submitProfile(UserEntity currentUser) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez sélectionner votre genre."),
          backgroundColor: AppColors.incorrectContainer,
        ),
      );
      return;
    }
    if (_selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez sélectionner votre pays de résidence."),
          backgroundColor: AppColors.incorrectContainer,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final docId = currentUser.id;
      final hubValue = (_selectedHub == null || _selectedHub!.contains('Non affilié'))
          ? ''
          : _selectedHub!.trim();

      final updateData = {
        'name': _nameController.text.trim(),
        'discordUsername': _discordController.text.trim(),
        'gender': _selectedGender,
        'country': _selectedCountry,
        'hasNextFlutterPremium': _hasNextFlutterPremium == 'Oui',
        'town': _townController.text.trim(),
        'hub': hubValue,
        'community': hubValue,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .set(updateData, SetOptions(merge: true));

      if (mounted) {
        context.read<AuthBloc>().add(CheckAuthEvent());
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'enregistrement : $e"),
            backgroundColor: AppColors.incorrectContainer,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final currentUser = widget.user ??
        (authState is ProfileIncompleteState
            ? authState.user
            : (authState is UnauthorizedState ? authState.user : null));

    final emailText = currentUser?.email ?? 'votre compte';
    final photoUrl = currentUser?.photoUrl;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Complétez votre profil"),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: "Se déconnecter",
            icon: AppIcons.logout(color: AppColors.errorText, size: 20),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Connected Account Card Header
              CompleteProfileHeader(
                emailText: emailText,
                photoUrl: photoUrl,
              ),
              SizedBox(height: 2.h),

              // Scrollable Form Fields
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    primary: false,
                    padding: EdgeInsets.only(bottom: 3.h),
                    children: [
                      Text(
                        "Informations personnelles",
                        style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 1.5.h),

                      // Nom Complet
                      TextFormField(
                        controller: _nameController,
                        style: AppTextStyles.bodyMedium,
                        decoration: const InputDecoration(
                          labelText: "Nom complet (Nom & Prénom) *",
                          hintText: "Ex: Georges Byona",
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Veuillez entrer votre nom complet.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),

                      // Pseudo Discord
                      TextFormField(
                        controller: _discordController,
                        style: AppTextStyles.bodyMedium,
                        decoration: const InputDecoration(
                          labelText: "Nom d'utilisateur Discord *",
                          hintText: "Ex: georges_dev",
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Veuillez entrer votre pseudo Discord.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),

                      // Pays de résidence Dropdown
                      AppDropdownField(
                        label: "Pays de résidence *",
                        value: _selectedCountry,
                        options: _africanCountries,
                        onSelected: (val) => setState(() => _selectedCountry = val),
                        hint: "Sélectionner votre pays",
                      ),
                      SizedBox(height: 2.h),

                      // Ville de résidence
                      TextFormField(
                        controller: _townController,
                        style: AppTextStyles.bodyMedium,
                        decoration: const InputDecoration(
                          labelText: "Ville de résidence *",
                          hintText: "Ex: Goma, Abidjan, Yaoundé...",
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Veuillez entrer votre ville de résidence.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),

                      // Hub / Communauté Tech Affiliée Dropdown
                      AppDropdownField(
                        label: "Hub / Communauté Tech d'origine (Optionnel)",
                        value: _selectedHub,
                        options: _hubOptions,
                        onSelected: (val) => setState(() => _selectedHub = val),
                        hint: "Sélectionner votre hub ou GDG...",
                      ),
                      SizedBox(height: 2.h),

                      // Genre Dropdown
                      AppDropdownField(
                        label: "Genre / Sexe *",
                        value: _selectedGender,
                        options: _genderOptions,
                        onSelected: (val) => setState(() => _selectedGender = val),
                        hint: "Sélectionner votre genre",
                      ),
                      SizedBox(height: 2.h),

                      // Participé au Next Flutter Premium
                      AppDropdownField(
                        label: "Avez-vous participé au Next Flutter Premium ?",
                        value: _hasNextFlutterPremium,
                        options: _premiumOptions,
                        onSelected: (val) => setState(() => _hasNextFlutterPremium = val),
                        hint: "Sélectionner une option",
                      ),
                      SizedBox(height: 3.h),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting || currentUser == null
                              ? null
                              : () => _submitProfile(currentUser),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.skyBlue,
                            padding: EdgeInsets.symmetric(vertical: 1.8.h),
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.circular12,
                            ),
                          ),
                          child: _isSubmitting
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.ultraDark,
                                  ),
                                )
                              : Text(
                                  "Valider et Accéder au Portail",
                                  style: AppTextStyles.button.copyWith(
                                    color: AppColors.ultraDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
