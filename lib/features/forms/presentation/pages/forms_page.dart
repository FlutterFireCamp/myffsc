import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../widgets/forms_modal_helper.dart';

class FormsPage extends StatefulWidget {
  const FormsPage({super.key});

  @override
  State<FormsPage> createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {
  final List<Map<String, String>> _submissions = [
    {
      "title": "Feedback - Cours Semaine 2 Clean Architecture",
      "date": "24 Juillet 2026",
      "type": "Feedback",
      "status": "Transmis"
    },
    {
      "title": "Signalement - Souci d'accès au serveur Discord",
      "date": "20 Juillet 2026",
      "type": "Signalement",
      "status": "Traité"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Formulaires & Soumissions"),
      ),
      body: ListView(
        primary: false,
        padding: EdgeInsets.all(4.w),
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
                          "Espace Formulaires",
                          style: AppTextStyles.h3,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          "Soumettez vos avis (Feedbacks) ou signalez un problème/abus en toute confidentialité.",
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Form Action Cards
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => FormsModalHelper.openFeedbackForm(context),
                    borderRadius: AppRadius.circular16,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: AppRadius.circular16,
                        border: Border.all(color: AppColors.skyBlue.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppIcons.feedback(color: AppColors.skyBlue, size: AppSizes.iconLg),
                          SizedBox(height: 1.5.h),
                          Text(
                            "Feedbacks",
                            style: AppTextStyles.titleMedium,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            "Donnez votre avis",
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: InkWell(
                    onTap: () => FormsModalHelper.openReportForm(context),
                    borderRadius: AppRadius.circular16,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColors.incorrectContainer.withValues(alpha: 0.3),
                        borderRadius: AppRadius.circular16,
                        border: Border.all(color: AppColors.incorrectBorder.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppIcons.alert02(color: AppColors.errorText, size: AppSizes.iconLg),
                          SizedBox(height: 1.5.h),
                          Text(
                            "Signalement",
                            style: AppTextStyles.titleMedium.copyWith(color: AppColors.errorText),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            "Abus ou problème",
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.alertRed.withValues(alpha: 0.8)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.5.h),

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
                  final isReport = item['type'] == 'Signalement';

                  return Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: AppRadius.circular16,
                      border: Border.all(
                        color: isReport ? AppColors.incorrectBorder.withValues(alpha: 0.4) : AppColors.borderSubtle,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.5.w),
                          decoration: BoxDecoration(
                            color: isReport
                                ? AppColors.incorrectContainer
                                : AppColors.actionBlue.withValues(alpha: 0.15),
                            borderRadius: AppRadius.circular10,
                          ),
                          child: isReport
                              ? AppIcons.alert02(color: AppColors.errorText, size: AppSizes.iconMd)
                              : AppIcons.feedback(color: AppColors.skyBlue, size: AppSizes.iconMd),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] ?? '',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: isReport ? AppColors.errorText : AppColors.textPrimary,
                                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => FormsModalHelper.showFormsSelectionSheet(context),
        backgroundColor: AppColors.skyBlue,
        child: AppIcons.forms(color: AppColors.ultraDark, size: AppSizes.iconLg),
      ),
    );
  }
}
