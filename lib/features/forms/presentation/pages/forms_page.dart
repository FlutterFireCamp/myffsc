import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/forms_modal_helper.dart';

class FormsPage extends StatelessWidget {
  const FormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthenticatedState ? authState.user : null;
    final userLevel = user?.level ?? 1;

    final certTitle = FormsModalHelper.getCertificateTitle(userLevel);
    final certSubtitle = FormsModalHelper.getCertificateSubtitle(userLevel);
    final certUrl = FormsModalHelper.getCertificateUrl(userLevel);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Formulaires Officiels"),
      ),
      body: ListView(
        primary: false,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        children: [
          // Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular20,
              border: Border.all(color: AppColors.skyBlue.withValues(alpha: 0.3)),
            ),
            child: Row(
              spacing: 4.w,
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppColors.skyBlue.withValues(alpha: 0.15),
                    shape: .circle,
                  ),
                  child: AppIcons.forms(color: AppColors.skyBlue, size: AppSizes.iconXl),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 0.5.h,
                    children: [
                      Text(
                        "Espace Formulaires",
                        style: AppTextStyles.h3,
                      ),
                      Text(
                        "Accédez rapidement aux formulaires officiels du programme pour partager vos idées, donner votre avis ou valider vos attestations.",
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          Text(
            "Tous nos Formulaires",
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 0.8.h),
          Text(
            "Cliquez sur un formulaire pour y accéder directement dans votre navigateur.",
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          SizedBox(height: 2.5.h),

          // 1. Idées & Suggestions
          _buildFormCard(
            context: context,
            title: "Idées & Suggestions",
            subtitle: "Partagez vos propositions pour améliorer le programme et les cours",
            icon: AppIcons.idea(color: AppColors.ideaAmber, size: 24),
            color: AppColors.ideaAmber,
            url: FormsModalHelper.ideaUrl,
            badgeText: "Boîte à idées",
          ),
          SizedBox(height: 2.h),

          // 2. Feedback & Avis
          _buildFormCard(
            context: context,
            title: "Feedback & Avis",
            subtitle: "Donnez votre retour sur les sessions, les formateurs et les ateliers",
            icon: AppIcons.feedback(color: AppColors.actionBlue, size: 24),
            color: AppColors.actionBlue,
            url: FormsModalHelper.feedbackUrl,
            badgeText: "Amélioration",
          ),
          SizedBox(height: 2.h),

          // 3. Signalements
          _buildFormCard(
            context: context,
            title: "Signalements & Problèmes",
            subtitle: "Signalez un incident, un problème technique ou un comportement inapproprié",
            icon: AppIcons.alert02(color: AppColors.errorText, size: 24),
            color: AppColors.errorText,
            url: FormsModalHelper.reportUrl,
            badgeText: "Support & Sécurité",
          ),
          SizedBox(height: 2.h),

          // 4. Soumission Certificat
          _buildFormCard(
            context: context,
            title: certTitle,
            subtitle: certSubtitle,
            icon: AppIcons.badge(color: AppColors.certificateGreen, size: 24),
            color: AppColors.certificateGreen,
            url: certUrl,
            badgeText: "Certification",
            isHighlighted: true,
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Widget _buildFormCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget icon,
    required Color color,
    required String url,
    required String badgeText,
    bool isHighlighted = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular16,
        border: Border.all(
          color: isHighlighted ? color.withValues(alpha: 0.6) : AppColors.borderSubtle,
          width: isHighlighted ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.circular16,
        child: InkWell(
          onTap: () => FormsModalHelper.openUrl(context, url),
          borderRadius: AppRadius.circular16,
          child: Padding(
            padding: EdgeInsets.all(4.5.w),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  spacing: 3.5.w,
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: AppRadius.circular12,
                      ),
                      child: icon,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 0.5.h,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: .bold,
                                  ),
                                  overflow: .ellipsis,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  borderRadius: AppRadius.circular8,
                                  border: Border.all(color: color.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  badgeText,
                                  style: AppTextStyles.badgeSmall.copyWith(
                                    color: color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            subtitle,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                            maxLines: 2,
                            overflow: .ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                const Divider(color: AppColors.borderSubtle, height: 1),
                SizedBox(height: 1.5.h),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      "Ouvrir le formulaire externe",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: color,
                        fontWeight: .w600,
                      ),
                    ),
                    AppIcons.link(color: color, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
