import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class CompleteProfilePage extends StatefulWidget {
  final UserEntity? user;

  const CompleteProfilePage({
    super.key,
    this.user,
  });

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

  static const List<String> _genderOptions = ['Homme', 'Femme'];
  static const List<String> _premiumOptions = ['Non', 'Oui'];

  static const List<String> _hubOptions = [
    'KIVU IMPACT CENTER',
    '10000 Codeurs',
    'Tek Komea',
    'GDG On Campus ESTI',
    'GDG RATOMA',
    'GDG Ouaga',
    'GDG Yamoussoukro',
    'GDG CLOUD ABIDJAN',
    'GDG on Campus UCB',
    'WTM Kivu',
    'ITN Hub',
    'GDG Yaoundé',
    'Yekola Now',
    'Devcreed',
    'GDG LOMÉ',
    'Club Statistique de Université Lumière de Bujumbura (ULBU)',
    'WTM Ngaoundéré',
    'Autre / Non affilié',
  ];

  static const List<String> _africanCountries = [
    'Algérie',
    'Angola',
    'Bénin',
    'Botswana',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cameroun',
    'Comores',
    'Congo-Brazzaville',
    'Congo-Kinshasa',
    'Côte d\'Ivoire',
    'Djibouti',
    'Égypte',
    'Érythrée',
    'Eswatini',
    'Éthiopie',
    'Gabon',
    'Gambie',
    'Ghana',
    'Guinée',
    'Guinée-Bissau',
    'Guinée équatoriale',
    'Kenya',
    'Lesotho',
    'Libéria',
    'Libye',
    'Madagascar',
    'Malawi',
    'Mali',
    'Maroc',
    'Maurice',
    'Mauritanie',
    'Mozambique',
    'Namibie',
    'Niger',
    'Nigéria',
    'Ouganda',
    'République centrafricaine',
    'Rwanda',
    'Sao Tomé-et-Principe',
    'Sénégal',
    'Seychelles',
    'Sierra Leone',
    'Somalie',
    'Soudan',
    'Soudan du Sud',
    'Tanzanie',
    'Tchad',
    'Togo',
    'Tunisie',
    'Zambie',
    'Zimbabwe',
  ];

  @override
  void initState() {
    super.initState();
    final currentUser = widget.user;
    _nameController = TextEditingController(
      text: currentUser?.name == 'Apprenant FFSC' ? '' : (currentUser?.name ?? ''),
    );
    _discordController = TextEditingController(text: currentUser?.discordUsername ?? '');
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
      final updateData = {
        'name': _nameController.text.trim(),
        'discordUsername': _discordController.text.trim(),
        'gender': _selectedGender,
        'country': _selectedCountry,
        'hasNextFlutterPremium': _hasNextFlutterPremium == 'Oui',
        'town': _townController.text.trim(),
        'hub': _selectedHub ?? '',
        'community': _selectedHub ?? '',
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Connected Account Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: AppRadius.circular16,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 5.w,
                        backgroundColor: AppColors.actionBlue.withValues(alpha: 0.2),
                        backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                            ? NetworkImage(photoUrl)
                            : null,
                        child: (photoUrl == null || photoUrl.isEmpty)
                            ? AppIcons.user(size: 20, color: AppColors.skyBlue)
                            : null,
                      ),
                      SizedBox(width: 3.5.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Compte Google connecté",
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                            SizedBox(height: 0.3.h),
                            Text(
                              emailText,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                Text(
                  "Informations Personnelles",
                  style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  "Veuillez compléter vos informations pour valider votre dossier.",
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                SizedBox(height: 2.5.h),

                // 1. Nom complet *
                _buildLabel("Nom complet *"),
                SizedBox(height: 0.8.h),
                TextFormField(
                  controller: _nameController,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  decoration: _buildInputDecoration(hint: "Ex: Georges Byona"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Veuillez entrer votre nom complet.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),

                // 2. Discord Username *
                _buildLabel("Discord Username *"),
                SizedBox(height: 0.8.h),
                TextFormField(
                  controller: _discordController,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  decoration: _buildInputDecoration(hint: "Ex: glosings0n"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Veuillez entrer votre pseudo Discord.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),

                // 3. Genre *
                _buildLabel("Genre *"),
                SizedBox(height: 0.8.h),
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
                  validator: (val) => val == null || val.isEmpty ? "Veuillez choisir un genre." : null,
                ),
                SizedBox(height: 2.h),

                // 4. Pays de résidence *
                _buildLabel("Pays de résidence *"),
                SizedBox(height: 0.8.h),
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
                  validator: (val) => val == null || val.isEmpty ? "Veuillez sélectionner votre pays de résidence." : null,
                ),
                SizedBox(height: 2.h),

                // 5. Avez-vous l'accès Premium sur NextFlutter ? *
                _buildLabel("Avez-vous l'accès Premium sur NextFlutter ? *"),
                SizedBox(height: 0.8.h),
                AppDropdownField(
                  label: "Accès Premium NextFlutter *",
                  value: _hasNextFlutterPremium,
                  hint: "Sélectionnez Oui ou Non",
                  options: _premiumOptions,
                  onSelected: (val) {
                    setState(() {
                      _hasNextFlutterPremium = val;
                    });
                  },
                ),
                SizedBox(height: 2.h),

                // 6. Communauté / Hub (Optionnel)
                _buildLabel("Communauté / Hub (Optionnel)"),
                SizedBox(height: 0.8.h),
                AppDropdownField(
                  label: "Communauté / Hub",
                  value: _selectedHub,
                  hint: "Sélectionnez votre communauté ou hub",
                  options: _hubOptions,
                  enableSearch: true,
                  onSelected: (val) {
                    setState(() {
                      _selectedHub = val;
                    });
                  },
                ),
                SizedBox(height: 2.h),

                // 7. Ville (Optionnel)
                _buildLabel("Ville (Optionnel)"),
                SizedBox(height: 0.8.h),
                TextFormField(
                  controller: _townController,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  decoration: _buildInputDecoration(hint: "Ex: Kinshasa, Lubumbashi..."),
                ),
                SizedBox(height: 3.5.h),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting || currentUser == null
                        ? null
                        : () => _submitProfile(currentUser),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.8.h),
                      backgroundColor: AppColors.actionBlue,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.circular14,
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Enregistrer mon profil",
                            style: AppTextStyles.button.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text.replaceAll(' *', ''),
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        children: text.contains('*')
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.errorText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            : [],
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.card,
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      border: OutlineInputBorder(
        borderRadius: AppRadius.circular12,
        borderSide: const BorderSide(color: AppColors.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.circular12,
        borderSide: const BorderSide(color: AppColors.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.circular12,
        borderSide: const BorderSide(color: AppColors.actionBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.circular12,
        borderSide: const BorderSide(color: AppColors.errorText),
      ),
    );
  }
}
