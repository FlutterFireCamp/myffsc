import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../widgets/action_button.dart';
import '../widgets/expandable_fab.dart';

class FormsPage extends StatefulWidget {
  const FormsPage({super.key});

  @override
  State<FormsPage> createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {
  final _standupController = TextEditingController();
  final _githubLinkController = TextEditingController();
  final _feedbackController = TextEditingController();
  final _ideaController = TextEditingController();
  final _reportController = TextEditingController();

  final List<Map<String, String>> _submissions = [
    {
      'title': 'Standup Semaine 4',
      'date': 'Aujourd\'hui, 09:30',
      'status': 'Validé',
      'type': 'Standup',
    },
    {
      'title': 'Projet Module 2 • BLoC & Clean Arch',
      'date': 'Hier, 18:45',
      'status': 'En évaluation',
      'type': 'Projet',
    },
  ];

  @override
  void dispose() {
    _standupController.dispose();
    _githubLinkController.dispose();
    _feedbackController.dispose();
    _ideaController.dispose();
    _reportController.dispose();
    super.dispose();
  }

  void _showFormModal({
    required String title,
    required Widget content,
    required VoidCallback onSubmit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            top: 3.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 3.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(AppIcons.cancel, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              content,
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onSubmit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.actionBlue,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(AppIcons.send, color: Colors.white, size: 18),
                  label: Text(
                    "Soumettre le formulaire",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openStandupForm() {
    _showFormModal(
      title: "Standup Hebdomadaire 🚀",
      content: Column(
        children: [
          TextField(
            controller: _standupController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "1. Ce que j'ai réalisé cette semaine...\n2. Mes blocages rencontrés...\n3. Mes objectifs pour la suite...",
            ),
          ),
        ],
      ),
      onSubmit: () {
        setState(() {
          _submissions.insert(0, {
            'title': 'Standup Hebdomadaire',
            'date': 'Aujourd\'hui',
            'status': 'Envoyé',
            'type': 'Standup',
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Standup soumis avec succès ! 🚀"),
            backgroundColor: AppColors.correctBorder,
          ),
        );
        _standupController.clear();
      },
    );
  }

  void _openProjectSubmissionForm() {
    _showFormModal(
      title: "Soumission de Projet 💻",
      content: Column(
        children: [
          TextField(
            controller: _githubLinkController,
            decoration: const InputDecoration(
              hintText: "Lien du repository GitHub (ex: https://github.com/...)",
              prefixIcon: Icon(AppIcons.link, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
      onSubmit: () {
        setState(() {
          _submissions.insert(0, {
            'title': 'Rendu de Projet GitHub',
            'date': 'Aujourd\'hui',
            'status': 'En évaluation',
            'type': 'Projet',
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Projet enregistré pour évaluation ! 🎉"),
            backgroundColor: AppColors.correctBorder,
          ),
        );
        _githubLinkController.clear();
      },
    );
  }

  void _openFeedbackForm() {
    _showFormModal(
      title: "Feedback & Mentorat 💬",
      content: Column(
        children: [
          TextField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Donnez votre avis sur la qualité des sessions live, du soutien des mentors ou du rythme du camp...",
            ),
          ),
        ],
      ),
      onSubmit: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Merci pour votre feedback précieux ! 💙"),
            backgroundColor: AppColors.correctBorder,
          ),
        );
        _feedbackController.clear();
      },
    );
  }

  void _openIdeaForm() {
    _showFormModal(
      title: "Idées & Suggestions 💡",
      content: Column(
        children: [
          TextField(
            controller: _ideaController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Proposez une idée d'atelier, une fonctionnalité pour l'app My FFSC ou une amélioration du programme...",
            ),
          ),
        ],
      ),
      onSubmit: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Idée transmise à l'équipe pédagogique ! 💡"),
            backgroundColor: AppColors.correctBorder,
          ),
        );
        _ideaController.clear();
      },
    );
  }

  void _openReportForm() {
    _showFormModal(
      title: "Signalement d'un Problème / Abus 🚨",
      content: Column(
        children: [
          TextField(
            controller: _reportController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Décrivez le problème rencontré (comportement non respectueux, bug bloquant, souci d'accès...)",
            ),
          ),
        ],
      ),
      onSubmit: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Signalement envoyé de manière confidentielle aux organisateurs. 🛡️"),
            backgroundColor: AppColors.correctBorder,
          ),
        );
        _reportController.clear();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Formulaires & Soumissions 📝"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.ultraDark, AppColors.card],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.skyBlue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppColors.skyBlue.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(AppIcons.forms, color: AppColors.skyBlue, size: 28),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hub de Formulaires",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          "Cliquez sur le bouton Floating en bas à droite pour soumettre vos standups, vos projets, vos idées ou un feedback.",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 9.sp,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            Text(
              "Historique de vos soumissions",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 1.5.h),

            if (_submissions.isEmpty)
              Container(
                padding: EdgeInsets.all(8.w),
                alignment: Alignment.center,
                child: Text(
                  "Aucune soumission pour le moment.",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11.sp,
                    color: AppColors.textMuted,
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _submissions.length,
                separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
                itemBuilder: (context, index) {
                  final item = _submissions[index];
                  return Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.5.w),
                          decoration: BoxDecoration(
                            color: AppColors.actionBlue.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item['type'] == 'Standup' ? AppIcons.forms : AppIcons.github,
                            color: AppColors.actionBlue,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] ?? '',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 0.4.h),
                              Text(
                                item['date'] ?? '',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 9.sp,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppColors.correctContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.correctBorder),
                          ),
                          child: Text(
                            item['status'] ?? '',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.correctText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 140,
        children: [
          ActionButton(
            onPressed: _openStandupForm,
            icon: const Icon(AppIcons.forms, size: 20),
            backgroundColor: AppColors.skyBlue,
            iconColor: AppColors.ultraDark,
          ),
          ActionButton(
            onPressed: _openProjectSubmissionForm,
            icon: const Icon(AppIcons.github, size: 20),
            backgroundColor: AppColors.firebaseOrange,
            iconColor: Colors.white,
          ),
          ActionButton(
            onPressed: _openFeedbackForm,
            icon: const Icon(AppIcons.star, size: 20),
            backgroundColor: AppColors.firebaseYellow,
            iconColor: AppColors.ultraDark,
          ),
          ActionButton(
            onPressed: _openIdeaForm,
            icon: const Icon(AppIcons.info, size: 20),
            backgroundColor: AppColors.actionBlue,
            iconColor: Colors.white,
          ),
          ActionButton(
            onPressed: _openReportForm,
            icon: const Icon(AppIcons.warning, size: 20),
            backgroundColor: AppColors.errorText,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
