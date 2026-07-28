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
  final List<Map<String, String>> _submissions = [
    {
      "title": "Standup Quotidien - Semaine 2",
      "date": "24 Juillet 2026",
      "type": "Standup",
      "status": "Soumis"
    },
    {
      "title": "Projet Capstone - Étape 1 Architecture",
      "date": "20 Juillet 2026",
      "type": "Projet",
      "status": "Validé"
    }
  ];

  final _standupController = TextEditingController();
  final _projectController = TextEditingController();
  final _feedbackController = TextEditingController();
  final _reportController = TextEditingController();
  final _ideaController = TextEditingController();

  void _openFormModal({
    required String title,
    required Widget content,
    required VoidCallback onSubmit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.r20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 2.h,
          left: 5.w,
          right: 5.w,
          top: 3.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.h2,
                  ),
                ),
                IconButton(
                  icon: AppIcons.cancel(color: AppColors.textMuted, size: AppSizes.iconMd),
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
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.circular12,
                  ),
                ),
                icon: AppIcons.send(color: Colors.white, size: AppSizes.iconSm),
                label: Text(
                  "Soumettre le formulaire",
                  style: AppTextStyles.buttonSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openStandupForm() {
    _openFormModal(
      title: "Rendu Standup Quotidien",
      content: TextField(
        controller: _standupController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: "Qu'avez-vous accompli aujourd'hui ? Rencontrez-vous des blocages ?",
        ),
      ),
      onSubmit: () {
        if (_standupController.text.isNotEmpty) {
          setState(() {
            _submissions.insert(0, {
              "title": "Standup - ${_standupController.text.substring(0, _standupController.text.length > 20 ? 20 : _standupController.text.length)}...",
              "date": "Aujourd'hui",
              "type": "Standup",
              "status": "Soumis"
            });
          });
          _standupController.clear();
        }
      },
    );
  }

  void _openProjectForm() {
    _openFormModal(
      title: "Rendu de Projet Capstone",
      content: Column(
        children: [
          TextField(
            controller: _projectController,
            decoration: const InputDecoration(
              hintText: "Lien GitHub du projet ou dépôt d'exécutable",
            ),
          ),
          SizedBox(height: 1.5.h),
          TextField(
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: "Remarques complémentaires pour le mentor",
            ),
          ),
        ],
      ),
      onSubmit: () {
        if (_projectController.text.isNotEmpty) {
          setState(() {
            _submissions.insert(0, {
              "title": "Projet - ${_projectController.text}",
              "date": "Aujourd'hui",
              "type": "Projet",
              "status": "En revue"
            });
          });
          _projectController.clear();
        }
      },
    );
  }

  void _openFeedbackForm() {
    _openFormModal(
      title: "Feedback Normal / Avis",
      content: TextField(
        controller: _feedbackController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: "Partagez votre avis sur les cours, l'organisation ou les sessions live...",
        ),
      ),
      onSubmit: () {
        AppSnackBar.showSuccess(context, "Feedback transmis à l'équipe pédagogique avec succès !");
        _feedbackController.clear();
      },
    );
  }

  void _openReportForm() {
    _openFormModal(
      title: "Signalement d'Abus / Problème",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppColors.correctContainer,
              borderRadius: AppRadius.circular10,
              border: Border.all(color: AppColors.correctBorder),
            ),
            child: Row(
              children: [
                AppIcons.alert02(color: AppColors.correctText, size: AppSizes.iconMd),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    "Soumission 100% Anonyme & Confidentielle. Votre identité ne sera pas rattachée à ce message.",
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.correctText, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
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
        AppSnackBar.showSuccess(context, "Signalement anonyme envoyé en toute confidentialité.");
        _reportController.clear();
      },
    );
  }

  void _openIdeaForm() {
    _openFormModal(
      title: "Idées ou Suggestions",
      content: TextField(
        controller: _ideaController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: "Quelle nouvelle fonctionnalité ou amélioration aimeriez-vous voir dans le camp ?",
        ),
      ),
      onSubmit: () {
        AppSnackBar.showSuccess(context, "Idée envoyée ! Merci pour votre contribution.");
        _ideaController.clear();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Formulaires & Soumissions"),
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
                borderRadius: AppRadius.circular20,
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
                    child: AppIcons.forms(color: AppColors.skyBlue, size: AppSizes.iconXl),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hub de Formulaires",
                          style: AppTextStyles.h3,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          "Cliquez sur le bouton Floating en bas à droite pour soumettre vos standups, vos projets, vos idées ou un feedback.",
                          style: AppTextStyles.bodyMedium,
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
              style: AppTextStyles.h3,
            ),
            SizedBox(height: 1.5.h),

            if (_submissions.isEmpty)
              Container(
                padding: EdgeInsets.all(8.w),
                alignment: Alignment.center,
                child: Text(
                  "Aucune soumission pour le moment.",
                  style: AppTextStyles.bodyMedium,
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
                      borderRadius: AppRadius.circular16,
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.5.w),
                          decoration: BoxDecoration(
                            color: AppColors.actionBlue.withValues(alpha: 0.15),
                            borderRadius: AppRadius.circular10,
                          ),
                          child: item['type'] == 'Standup'
                              ? AppIcons.standup(color: AppColors.actionBlue, size: AppSizes.iconMd)
                              : AppIcons.project(color: AppColors.actionBlue, size: AppSizes.iconMd),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] ?? '',
                                style: AppTextStyles.titleMedium,
                              ),
                              SizedBox(height: 0.4.h),
                              Text(
                                item['date'] ?? '',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppColors.correctContainer,
                            borderRadius: AppRadius.circular8,
                            border: Border.all(color: AppColors.correctBorder),
                          ),
                          child: Text(
                            item['status'] ?? '',
                            style: AppTextStyles.badgeSmall.copyWith(color: AppColors.correctText),
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
        distance: 70,
        children: [
          ActionButton(
            icon: AppIcons.standup(size: AppSizes.iconMd, color: Colors.white),
            label: "Standup Quotidien",
            onPressed: _openStandupForm,
            backgroundColor: AppColors.actionBlue,
          ),
          ActionButton(
            icon: AppIcons.project(size: AppSizes.iconMd, color: Colors.white),
            label: "Rendu Projet",
            onPressed: _openProjectForm,
            backgroundColor: AppColors.firebaseOrange,
          ),
          ActionButton(
            icon: AppIcons.feedback(size: AppSizes.iconMd, color: Colors.white),
            label: "Feedback Normal",
            onPressed: _openFeedbackForm,
            backgroundColor: AppColors.skyBlue,
          ),
          ActionButton(
            icon: AppIcons.report(size: AppSizes.iconMd, color: Colors.white),
            label: "Signalement (Abus)",
            onPressed: _openReportForm,
            backgroundColor: AppColors.errorText,
          ),
          ActionButton(
            icon: AppIcons.idea(size: AppSizes.iconMd, color: Colors.white),
            label: "Idées / Suggestions",
            onPressed: _openIdeaForm,
            backgroundColor: AppColors.firebaseYellow,
          ),
        ],
      ),
    );
  }
}
