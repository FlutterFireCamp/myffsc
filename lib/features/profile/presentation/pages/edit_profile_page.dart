import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

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

  static const List<String> _genderOptions = ['Homme', 'Femme'];

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
    final u = widget.user;
    _nameController = TextEditingController(text: u.name == 'Apprenant FFSC' ? '' : u.name);
    _discordController = TextEditingController(text: u.discordUsername ?? '');
    _townController = TextEditingController(text: u.town ?? '');
    _githubController = TextEditingController(text: u.github ?? '');
    _linkedinController = TextEditingController(text: u.linkedin ?? '');
    _xController = TextEditingController(text: u.x ?? '');
    _portfolioController = TextEditingController(text: u.portfolio ?? '');

    if (u.gender != null && _genderOptions.contains(u.gender)) {
      _selectedGender = u.gender;
    }

    if (u.country != null && _africanCountries.contains(u.country)) {
      _selectedCountry = u.country;
    }

    final existingHub = u.hub ?? u.community;
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

  Future<void> _saveProfile() async {
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
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil mis à jour avec succès !"),
            backgroundColor: AppColors.correctContainer,
          ),
        );
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
        title: const Text("Modifier mon profil"),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header note
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: AppRadius.circular16,
                      border: Border.all(color: AppColors.skyBlue.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        AppIcons.info(color: AppColors.skyBlue, size: 20),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            "Mettez à jour vos informations personnelles et vos liens. Vos modifications seront enregistrées directement.",
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Section: Informations Personnelles
                  _buildSectionTitle("Informations Personnelles"),

                  _buildLabel("Nom complet *"),
                  SizedBox(height: 0.8.h),
                  TextFormField(
                    controller: _nameController,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: _buildInputDecoration(hint: "Ex: Georges Byona"),
                    validator: (val) => val == null || val.trim().isEmpty ? "Veuillez entrer votre nom." : null,
                  ),
                  SizedBox(height: 2.h),

                  _buildLabel("Discord Username *"),
                  SizedBox(height: 0.8.h),
                  TextFormField(
                    controller: _discordController,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: _buildInputDecoration(hint: "Ex: glosings0n"),
                    validator: (val) => val == null || val.trim().isEmpty ? "Veuillez entrer votre pseudo Discord." : null,
                  ),
                  SizedBox(height: 2.h),

                  _buildLabel("Genre *"),
                  SizedBox(height: 0.8.h),
                  AppDropdownField(
                    label: "Genre *",
                    value: _selectedGender,
                    hint: "Sélectionnez votre genre",
                    options: _genderOptions,
                    onSelected: (val) => setState(() => _selectedGender = val),
                    validator: (val) => val == null || val.isEmpty ? "Veuillez choisir un genre." : null,
                  ),
                  SizedBox(height: 2.h),

                  _buildLabel("Pays de résidence *"),
                  SizedBox(height: 0.8.h),
                  AppDropdownField(
                    label: "Pays de résidence *",
                    value: _selectedCountry,
                    hint: "Sélectionnez votre pays",
                    options: _africanCountries,
                    enableSearch: true,
                    onSelected: (val) => setState(() => _selectedCountry = val),
                    validator: (val) => val == null || val.isEmpty ? "Veuillez choisir un pays." : null,
                  ),
                  SizedBox(height: 2.h),

                  _buildLabel("Ville (Optionnel)"),
                  SizedBox(height: 0.8.h),
                  TextFormField(
                    controller: _townController,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: _buildInputDecoration(hint: "Ex: Kinshasa, Lubumbashi..."),
                  ),
                  SizedBox(height: 2.h),

                  _buildLabel("Communauté / Hub (Optionnel)"),
                  SizedBox(height: 0.8.h),
                  AppDropdownField(
                    label: "Communauté / Hub",
                    value: _selectedHub,
                    hint: "Sélectionnez votre communauté ou hub",
                    options: _hubOptions,
                    enableSearch: true,
                    onSelected: (val) => setState(() => _selectedHub = val),
                  ),
                  SizedBox(height: 3.h),

                  // Section: Liens Sociaux & Portfolio
                  _buildSectionTitle("Liens & Réseaux Sociaux"),

                  _buildLabel("Profil GitHub (Optionnel)"),
                  SizedBox(height: 0.8.h),
                  TextFormField(
                    controller: _githubController,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: _buildInputDecoration(hint: "Ex: https://github.com/votre-pseudo"),
                  ),
                  SizedBox(height: 2.h),

                  _buildLabel("Profil LinkedIn (Optionnel)"),
                  SizedBox(height: 0.8.h),
                  TextFormField(
                    controller: _linkedinController,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: _buildInputDecoration(hint: "Ex: https://linkedin.com/in/votre-nom"),
                  ),
                  SizedBox(height: 2.h),

                  _buildLabel("Profil X / Twitter (Optionnel)"),
                  SizedBox(height: 0.8.h),
                  TextFormField(
                    controller: _xController,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: _buildInputDecoration(hint: "Ex: https://x.com/votre-pseudo"),
                  ),
                  SizedBox(height: 2.h),

                  _buildLabel("Site Web / Portfolio (Optionnel)"),
                  SizedBox(height: 0.8.h),
                  TextFormField(
                    controller: _portfolioController,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: _buildInputDecoration(hint: "Ex: https://votre-portfolio.com"),
                  ),
                  SizedBox(height: 4.h),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.8.h),
                        backgroundColor: AppColors.actionBlue,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.circular14,
                        ),
                        elevation: 0,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Enregistrer les modifications",
                              style: AppTextStyles.button.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h, top: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.skyBlue,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 0.5.h),
          const Divider(color: AppColors.borderSubtle, height: 1),
        ],
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
