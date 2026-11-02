import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/edit_profile_header.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity user;

  const EditProfilePage({super.key, required this.user});

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

  static const List<String> _genderOptions = AppDataConstants.genderOptions;
  static const List<String> _hubOptions = AppDataConstants.hubOptions;
  static const List<String> _africanCountries =
      AppDataConstants.africanCountries;

  @override
  void initState() {
    super.initState();
    final user = widget.user;

    _nameController = TextEditingController(text: user.name);
    _discordController = TextEditingController(
      text: user.discordUsername ?? '',
    );
    _townController = TextEditingController(text: user.town ?? '');
    _githubController = TextEditingController(text: user.github ?? '');
    _linkedinController = TextEditingController(text: user.linkedin ?? '');
    _xController = TextEditingController(text: user.x ?? '');
    _portfolioController = TextEditingController(text: user.portfolio ?? '');

    if (user.gender != null && _genderOptions.contains(user.gender)) {
      _selectedGender = user.gender;
    }

    if (user.country != null) {
      final matched = AppDataConstants.matchCountryWithFlag(user.country);
      if (matched != null && _africanCountries.contains(matched)) {
        _selectedCountry = matched;
      }
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
      AppSnackBar.showError(context, "Veuillez sélectionner votre genre.");
      return;
    }
    if (_selectedCountry == null) {
      AppSnackBar.showError(
        context,
        "Veuillez sélectionner votre pays de résidence.",
      );
      return;
    }

    // Check Network Connection
    final isOnline = await NetworkHelper.checkConnection(context);
    if (!isOnline) return;

    final updatedData = {
      'name': _nameController.text.trim(),
      'discordUsername': _discordController.text.trim(),
      'country': _selectedCountry,
      'town': _townController.text.trim(),
      'hub': _selectedHub,
      'community': _selectedHub,
      'gender': _selectedGender,
      'github': _githubController.text.trim(),
      'linkedin': _linkedinController.text.trim(),
      'x': _xController.text.trim(),
      'portfolio': _portfolioController.text.trim(),
    };

    if (mounted) {
      context.read<ProfileBloc>().add(
        UpdateProfileSubmittedEvent(userId: widget.user.id, data: updatedData),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          previous.updateStatus != current.updateStatus,
      listener: (context, state) {
        if (state.updateStatus == ProfileUpdateStatus.success) {
          context.read<AuthBloc>().add(SilentRefreshAuthUserEvent());
          AppSnackBar.showSuccess(
            context,
            "Votre profil a été mis à jour avec succès !",
          );
          if (context.canPop()) {
            context.pop();
          }
        } else if (state.updateStatus == ProfileUpdateStatus.failure) {
          AppSnackBar.showError(
            context,
            state.updateError ?? "Erreur lors de la mise à jour du profil.",
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.updateStatus == ProfileUpdateStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text("Éditer mon profil"),
            backgroundColor: AppColors.background,
            elevation: 0,
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : _submitChanges,
                child: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.skyBlue,
                        ),
                      )
                    : Text(
                        "Enregistrer",
                        style: AppTextStyles.buttonSmall.copyWith(
                          color: AppColors.skyBlue,
                          fontWeight: .bold,
                        ),
                      ),
              ),
              SizedBox(width: 2.w),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  // 1. Header Card (Read-only Email & Status)
                  EditProfileHeader(user: widget.user),
                  SizedBox(height: 2.5.h),

                  // Section: Informations Personnelles
                  Text(
                    "Informations Personnelles",
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: .bold,
                    ),
                  ),
                  SizedBox(height: 1.5.h),

                  // Nom Complet
                  AppTextField(
                    label: "Nom complet *",
                    controller: _nameController,
                    hintText: "Votre nom complet",
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Le nom complet est obligatoire";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 1.5.h),

                  // Pseudo Discord
                  AppTextField(
                    label: "Pseudo Discord *",
                    controller: _discordController,
                    hintText: "ex: username",
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Le pseudo Discord est obligatoire";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 1.5.h),

                  // Genre
                  AppDropdownField(
                    label: "Genre *",
                    value: _selectedGender,
                    hint: "Sélectionnez votre genre",
                    options: _genderOptions,
                    onSelected: (val) {
                      setState(() {
                        _selectedGender = val;
                      });
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Le genre est obligatoire";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 1.5.h),

                  // Pays
                  AppDropdownField(
                    label: "Pays de résidence *",
                    value: _selectedCountry,
                    hint: "Sélectionnez votre pays",
                    options: _africanCountries,
                    enableSearch: true,
                    onSelected: (val) {
                      setState(() {
                        _selectedCountry = val;
                      });
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Le pays est obligatoire";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 1.5.h),

                  // Ville
                  AppTextField(
                    label: "Ville",
                    controller: _townController,
                    hintText: "ex: Goma, Kinshasa, Paris...",
                  ),
                  SizedBox(height: 1.5.h),

                  // Hub / Communauté
                  AppDropdownField(
                    label: "Hub / Communauté d'origine",
                    value: _selectedHub,
                    hint: "Sélectionnez votre Hub ou GDG...",
                    options: _hubOptions,
                    onSelected: (val) {
                      setState(() {
                        _selectedHub = val;
                      });
                    },
                  ),
                  SizedBox(height: 3.h),

                  // Section: Réseaux Sociaux & Liens
                  Text(
                    "Réseaux Sociaux & Portfolio",
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: .bold,
                    ),
                  ),
                  SizedBox(height: 1.5.h),

                  // GitHub
                  AppTextField(
                    label: "Profil GitHub",
                    controller: _githubController,
                    hintText: "ex: https://github.com/votre_profil",
                  ),
                  SizedBox(height: 1.5.h),

                  // LinkedIn
                  AppTextField(
                    label: "Profil LinkedIn",
                    controller: _linkedinController,
                    hintText: "ex: https://linkedin.com/in/votre_profil",
                  ),
                  SizedBox(height: 1.5.h),

                  // X / Twitter
                  AppTextField(
                    label: "Profil X (Twitter)",
                    controller: _xController,
                    hintText: "ex: https://x.com/votre_profil",
                  ),
                  SizedBox(height: 1.5.h),

                  // Portfolio
                  AppTextField(
                    label: "Portfolio / Site Web",
                    controller: _portfolioController,
                    hintText: "ex: https://monsite.dev",
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
