import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../widgets/edit_profile_header.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity user;

  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _discordController;
  late TextEditingController _townController;
  late TextEditingController _githubController;
  late TextEditingController _linkedinController;
  late TextEditingController _xController;
  late TextEditingController _portfolioController;

  String? _selectedGender;
  String? _selectedCountry;
  String? _selectedHub;

  bool _isSubmitting = false;

  static const List<String> _genderOptions = AppDataConstants.genderOptions;
  static const List<String> _hubOptions = AppDataConstants.hubOptions;
  static const List<String> _africanCountries = AppDataConstants.africanCountries;

  @override
  void initState() {
    super.initState();
    final user = widget.user;

    _nameController = TextEditingController(text: user.name);
    _discordController = TextEditingController(text: user.discordUsername ?? '');
    _townController = TextEditingController(text: user.town ?? '');
    _githubController = TextEditingController(text: user.github ?? '');
    _linkedinController = TextEditingController(text: user.linkedin ?? '');
    _xController = TextEditingController(text: user.x ?? '');
    _portfolioController = TextEditingController(text: user.portfolio ?? '');

    if (user.gender != null && _genderOptions.contains(user.gender)) {
      _selectedGender = user.gender;
    }

    if (user.country != null && _africanCountries.contains(user.country)) {
      _selectedCountry = user.country;
    }

    final existingHub = user.hub ?? user.community;
    if (existingHub != null && _hubOptions.contains(existingHub)) {
      _selectedHub = existingHub;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _discordController.dispose();
    _townController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    _xController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  Future<void> _submitChanges() async {
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
      final docId = widget.user.id;
      final hubValue = (_selectedHub == null || _selectedHub!.contains('Non affilié'))
          ? ''
          : _selectedHub!.trim();

      final updateData = {
        'name': _nameController.text.trim(),
        'discordUsername': _discordController.text.trim(),
        'gender': _selectedGender,
        'country': _selectedCountry,
        'town': _townController.text.trim(),
        'hub': hubValue,
        'community': hubValue,
        'github': _githubController.text.trim(),
        'linkedin': _linkedinController.text.trim(),
        'x': _xController.text.trim(),
        'portfolio': _portfolioController.text.trim(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .set(updateData, SetOptions(merge: true));

      if (mounted) {
        context.read<AuthBloc>().add(CheckAuthEvent());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil mis à jour avec succès !"),
            backgroundColor: AppColors.correctContainer,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de la mise à jour : $e"),
            backgroundColor: AppColors.incorrectContainer,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Éditer mon profil"),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed Header Card (Does not scroll!)
              EditProfileHeader(user: widget.user),
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

                      // Nom complet
                      TextFormField(
                        controller: _nameController,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
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
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
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

                      // Pays Dropdown
                      AppDropdownField(
                        label: "Pays de résidence *",
                        value: _selectedCountry,
                        options: _africanCountries,
                        onSelected: (val) => setState(() => _selectedCountry = val),
                        hint: "Sélectionner votre pays",
                      ),
                      SizedBox(height: 2.h),

                      // Ville
                      TextFormField(
                        controller: _townController,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
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

                      // Hub Dropdown
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
                      SizedBox(height: 3.h),

                      // Section Réseaux Sociaux & Portfolio
                      Text(
                        "Réseaux Sociaux & Portfolio",
                        style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 1.5.h),

                      // GitHub
                      TextFormField(
                        controller: _githubController,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: "Lien GitHub (Optionnel)",
                          hintText: "https://github.com/votre_pseudo",
                        ),
                      ),
                      SizedBox(height: 2.h),

                      // LinkedIn
                      TextFormField(
                        controller: _linkedinController,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: "Lien LinkedIn (Optionnel)",
                          hintText: "https://linkedin.com/in/votre_pseudo",
                        ),
                      ),
                      SizedBox(height: 2.h),

                      // Twitter / X
                      TextFormField(
                        controller: _xController,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: "Lien X / Twitter (Optionnel)",
                          hintText: "https://x.com/votre_pseudo",
                        ),
                      ),
                      SizedBox(height: 2.h),

                      // Portfolio / Site Web
                      TextFormField(
                        controller: _portfolioController,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: "Portfolio ou Site Web (Optionnel)",
                          hintText: "https://votre-site.com",
                        ),
                      ),
                      SizedBox(height: 3.5.h),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.skyBlue,
                            padding: EdgeInsets.symmetric(vertical: 1.8.h),
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.circular12,
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.ultraDark,
                                  ),
                                )
                              : Text(
                                  "Enregistrer les modifications",
                                  style: AppTextStyles.button.copyWith(
                                    color: AppColors.ultraDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 4.h),
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
