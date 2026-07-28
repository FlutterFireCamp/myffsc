import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class FormsModalHelper {
  static void openFeedbackForm(BuildContext context) {
    final controller = TextEditingController();
    String? errorMessage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.r20)),
      ),
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (bottomSheetContext, setModalState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 2.h,
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
                          "Feedback & Avis",
                          style: AppTextStyles.h3,
                        ),
                      ),
                      IconButton(
                        icon: AppIcons.cancel(color: AppColors.textMuted, size: AppSizes.iconMd),
                        onPressed: () => Navigator.pop(bottomSheetContext),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    onChanged: (val) {
                      if (errorMessage != null && val.trim().isNotEmpty) {
                        setModalState(() {
                          errorMessage = null;
                        });
                      }
                    },
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: "Partagez votre avis sur les cours, le rythme ou l'organisation...",
                      errorText: errorMessage,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final text = controller.text.trim();
                        if (text.isEmpty) {
                          setModalState(() {
                            errorMessage = "Ce champ est obligatoire. Veuillez saisir votre avis.";
                          });
                          AppSnackBar.showError(
                            context,
                            "Veuillez remplir le champ texte avant de soumettre.",
                          );
                          return;
                        }

                        AppConfirmationDialog.show(
                          context,
                          title: "Transmettre le Feedback",
                          message: "Voulez-vous envoyer ce feedback à l'équipe pédagogique ?",
                          confirmText: "Envoyer",
                          cancelText: "Annuler",
                          isDestructive: false,
                          onConfirm: () {
                            Navigator.pop(bottomSheetContext);
                            AppSnackBar.showSuccess(
                              context,
                              "Feedback transmis à l'équipe pédagogique avec succès !",
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.skyBlue,
                        foregroundColor: AppColors.ultraDark,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.circular12,
                        ),
                      ),
                      icon: AppIcons.send(color: AppColors.ultraDark, size: AppSizes.iconSm),
                      label: Text(
                        "Envoyer le Feedback",
                        style: AppTextStyles.buttonSmall.copyWith(color: AppColors.ultraDark),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static void openReportForm(BuildContext context) {
    final controller = TextEditingController();
    String? errorMessage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.r20)),
      ),
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (bottomSheetContext, setModalState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 2.h,
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
                          "Signalement d'Abus",
                          style: AppTextStyles.h3.copyWith(color: AppColors.errorText),
                        ),
                      ),
                      IconButton(
                        icon: AppIcons.cancel(color: AppColors.textMuted, size: AppSizes.iconMd),
                        onPressed: () => Navigator.pop(bottomSheetContext),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppColors.incorrectContainer,
                      borderRadius: AppRadius.circular10,
                      border: Border.all(color: AppColors.incorrectBorder.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        AppIcons.alert02(color: AppColors.errorText, size: AppSizes.iconMd),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            "Soumission 100% Anonyme & Confidentielle. Votre identité ne sera pas transmise.",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.alertRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    onChanged: (val) {
                      if (errorMessage != null && val.trim().isNotEmpty) {
                        setModalState(() {
                          errorMessage = null;
                        });
                      }
                    },
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: "Décrivez le problème rencontré (comportement non respectueux, bug bloquant, souci d'accès...)",
                      errorText: errorMessage,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final text = controller.text.trim();
                        if (text.isEmpty) {
                          setModalState(() {
                            errorMessage = "Ce champ est obligatoire. Veuillez décrire le problème.";
                          });
                          AppSnackBar.showError(
                            context,
                            "Veuillez décrire le problème avant de soumettre.",
                          );
                          return;
                        }

                        AppConfirmationDialog.show(
                          context,
                          title: "Signalement d'Abus",
                          message: "Confirmez-vous l'envoi de ce signalement anonyme ?",
                          confirmText: "Envoyer",
                          cancelText: "Annuler",
                          isDestructive: true,
                          onConfirm: () {
                            Navigator.pop(bottomSheetContext);
                            AppSnackBar.showSuccess(
                              context,
                              "Signalement anonyme transmis en toute confidentialité.",
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorText,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.circular12,
                        ),
                      ),
                      icon: AppIcons.send(color: Colors.white, size: AppSizes.iconSm),
                      label: Text(
                        "Envoyer le Signalement",
                        style: AppTextStyles.buttonSmall.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static void showFormsSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.r20)),
      ),
      builder: (bottomSheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transmettre un formulaire",
                    style: AppTextStyles.h3,
                  ),
                  IconButton(
                    icon: AppIcons.cancel(color: AppColors.textMuted, size: AppSizes.iconMd),
                    onPressed: () => Navigator.pop(bottomSheetContext),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                "Choisissez le type de message à envoyer à l'équipe pédagogique :",
                style: AppTextStyles.bodySmall,
              ),
              SizedBox(height: 2.5.h),

              // Feedbacks Tile
              InkWell(
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  openFeedbackForm(context);
                },
                borderRadius: AppRadius.circular14,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.ultraDark,
                    borderRadius: AppRadius.circular14,
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
                        child: AppIcons.feedback(color: AppColors.skyBlue, size: AppSizes.iconLg),
                      ),
                      SizedBox(width: 3.5.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Feedbacks & Avis",
                              style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
                            ),
                            SizedBox(height: 0.3.h),
                            Text(
                              "Donner votre avis sur le cours, le rythme ou l'organisation.",
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      AppIcons.arrowRight(color: AppColors.skyBlue, size: AppSizes.iconSm),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1.5.h),

              // Signalement Tile
              InkWell(
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  openReportForm(context);
                },
                borderRadius: AppRadius.circular14,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.incorrectContainer.withValues(alpha: 0.3),
                    borderRadius: AppRadius.circular14,
                    border: Border.all(color: AppColors.incorrectBorder.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppColors.incorrectContainer,
                          shape: BoxShape.circle,
                        ),
                        child: AppIcons.alert02(color: AppColors.errorText, size: AppSizes.iconLg),
                      ),
                      SizedBox(width: 3.5.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Signalement d'Abus",
                              style: AppTextStyles.titleMedium.copyWith(color: AppColors.errorText),
                            ),
                            SizedBox(height: 0.3.h),
                            Text(
                              "Signaler un problème ou comportement (100% anonyme).",
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.alertRed.withValues(alpha: 0.8)),
                            ),
                          ],
                        ),
                      ),
                      AppIcons.arrowRight(color: AppColors.errorText, size: AppSizes.iconSm),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.5.h),

              // View History Link
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(bottomSheetContext);
                    context.push('/forms');
                  },
                  icon: AppIcons.forms(color: AppColors.textMuted, size: AppSizes.iconSm),
                  label: Text(
                    "Voir l'historique de mes soumissions",
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
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
