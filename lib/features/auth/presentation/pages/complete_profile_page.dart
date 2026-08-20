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
  bool _hasNextFlutterPremium = false;
  String? _selectedHub;

  static const List<String> _genderOptions = AppDataConstants.genderOptions;
  static const List<String> _hubOptions = AppDataConstants.hubOptions;
  static const List<String> _africanCountries =
      AppDataConstants.africanCountries;

  @override
  void initState() {
    super.initState();
    final currentUser = widget.user;
    _nameController = TextEditingController(
      text: currentUser?.name == 'Apprenant FFSC'
          ? ''
          : (currentUser?.name ?? ''),
    );
    _discordController = TextEditingController(
      text: currentUser?.discordUsername ?? '',
    );
    _townController = TextEditingController(text: currentUser?.town ?? '');

    if (currentUser?.gender != null &&
        _genderOptions.contains(currentUser!.gender)) {
      _selectedGender = currentUser.gender;
    }

    if (currentUser?.country != null) {
      final matched = AppDataConstants.matchCountryWithFlag(
        currentUser!.country,
      );
      if (matched != null && _africanCountries.contains(matched)) {
        _selectedCountry = matched;
      }
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

    final hubValue =
        (_selectedHub == null || _selectedHub!.contains('Non affilié'))
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
      'nextFlutterPremium': _hasNextFlutterPremium,
      'profileCompleted': true,
    };

    if (mounted) {
      context.read<AuthBloc>().add(
        CompleteProfileEvent(userId: currentUser.id, data: updateData),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    UserEntity? currentUser = widget.user;
    if (currentUser == null && authState is ProfileIncompleteState) {
      currentUser = authState.user;
    }
    if (currentUser == null && authState is AuthenticatedState) {
      currentUser = authState.user;
    }

    final emailText = currentUser?.email ?? "Compte connecté";
    final photoUrl = currentUser?.photoUrl;
    final isLoading = authState is AuthLoadingState;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          AppSnackBar.showError(context, state.message);
        } else if (state is AuthenticatedState) {
          AppSnackBar.showSuccess(context, "Profil complété avec succès !");
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("Compléter le Profil"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: AppIcons.logout(color: AppColors.textMuted, size: 20),
              tooltip: "Déconnexion",
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
            ),
            SizedBox(width: 1.w),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                CompleteProfileHeader(emailText: emailText, photoUrl: photoUrl),
                SizedBox(height: 2.h),

                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      primary: false,
                      padding: EdgeInsets.only(bottom: 3.h),
                      children: [
                        Text(
                          "Informations personnelles",
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: .bold,
                          ),
                        ),
                        SizedBox(height: 1.5.h),

                        Text(
                          "Nom complet (Nom & Prénom) *",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 0.8.h),
                        TextFormField(
                          controller: _nameController,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Ex: Georges Byona",
                          ),
                          validator: (val) =>
                              (val == null || val.trim().isEmpty)
                              ? "Veuillez entrer votre nom complet."
                              : null,
                        ),
                        SizedBox(height: 2.h),

                        Text(
                          "Nom d'utilisateur Discord *",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 0.8.h),
                        TextFormField(
                          controller: _discordController,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Ex: georges_dev",
                          ),
                          validator: (val) =>
                              (val == null || val.trim().isEmpty)
                              ? "Veuillez entrer votre pseudo Discord."
                              : null,
                        ),
                        SizedBox(height: 2.h),

                        AppDropdownField(
                          label: "Genre / Sexe *",
                          value: _selectedGender,
                          options: _genderOptions,
                          onSelected: (val) =>
                              setState(() => _selectedGender = val),
                          hint: "Sélectionnez votre genre",
                          validator: (val) => (val == null || val.isEmpty)
                              ? "Veuillez sélectionner votre genre"
                              : null,
                        ),
                        SizedBox(height: 2.h),

                        AppDropdownField(
                          label: "Pays de résidence *",
                          value: _selectedCountry,
                          options: _africanCountries,
                          enableSearch: true,
                          onSelected: (val) =>
                              setState(() => _selectedCountry = val),
                          hint: "Sélectionnez votre pays",
                          validator: (val) => (val == null || val.isEmpty)
                              ? "Veuillez sélectionner votre pays"
                              : null,
                        ),
                        SizedBox(height: 2.h),

                        Text(
                          "Ville de résidence (Optionnel)",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 0.8.h),
                        TextFormField(
                          controller: _townController,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Ex: Goma, Abidjan, Yaoundé...",
                          ),
                        ),
                        SizedBox(height: 2.h),

                        AppDropdownField(
                          label: "Hub / Communauté d'origine (Optionnel)",
                          value: _selectedHub,
                          options: _hubOptions,
                          onSelected: (val) =>
                              setState(() => _selectedHub = val),
                          hint: "Sélectionnez votre Hub",
                        ),
                        SizedBox(height: 2.h),

                        SwitchListTile(
                          title: Text(
                            "Accès Next Flutter Premium",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          value: _hasNextFlutterPremium,
                          activeThumbColor: AppColors.skyBlue,
                          onChanged: (val) =>
                              setState(() => _hasNextFlutterPremium = val),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(4.w),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.borderSubtle)),
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (currentUser != null) {
                          _submitProfile(currentUser);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.skyBlue,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.circular12,
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        "Enregistrer et continuer",
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
