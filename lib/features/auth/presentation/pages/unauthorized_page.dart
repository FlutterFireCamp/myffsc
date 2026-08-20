import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class UnauthorizedPage extends StatelessWidget {
  final UserEntity? user;

  const UnauthorizedPage({
    super.key,
    this.user,
  });

  Future<void> _launchEmail(BuildContext context) async {
    const email = 'flutterfiresummer@gmail.com';
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Demande d\'accès - FlutterFire Summer Camp',
      },
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: .externalApplication);
      } else {
        await Clipboard.setData(const ClipboardData(text: email));
        if (context.mounted) {
          AppSnackBar.showSuccess(context, 'Adresse e-mail copiée : $email');
        }
      }
    } catch (e) {
      await Clipboard.setData(const ClipboardData(text: email));
      if (context.mounted) {
        AppSnackBar.showSuccess(context, 'Adresse e-mail copiée : $email');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final currentUser = user ?? (authState is UnauthorizedState ? authState.user : null);

    final emailText = currentUser?.email.isNotEmpty == true
        ? currentUser!.email
        : 'adresse non renseignée';

    final isDocMissing = currentUser?.isDocMissing == true;
    final isPending = currentUser?.isPending == true;
    final isSuspended = currentUser?.isSuspended == true;

    final String statusBadgeText;
    final Color statusColor;

    if (isDocMissing) {
      statusBadgeText = "Absent du programme";
      statusColor = AppColors.errorText;
    } else if (isPending) {
      statusBadgeText = "En attente de validation";
      statusColor = AppColors.warningAmber;
    } else if (isSuspended) {
      statusBadgeText = "Compte suspendu";
      statusColor = AppColors.errorText;
    } else {
      statusBadgeText = currentUser?.status.isNotEmpty == true
          ? currentUser!.status
          : "Non autorisé";
      statusColor = AppColors.errorText;
    }

    final String descriptionText;
    if (isDocMissing) {
      descriptionText =
          "Cette application est exclusivement réservée aux participants retenus pour la cohorte du FlutterFire Camp. Votre adresse e-mail n'a pas été trouvée parmi les participants autorisés.";
    } else if (isPending) {
      descriptionText =
          "Votre dossier existe bien dans notre base de données, mais votre compte est actuellement en attente de validation par l'équipe d'administration.";
    } else if (isSuspended) {
      descriptionText =
          "Votre adresse e-mail figure dans le programme FlutterFire Camp, mais votre accès est actuellement suspendu.";
    } else {
      descriptionText =
          "Cette application est exclusivement réservée aux participants retenus pour la cohorte du FlutterFire Camp. Votre profil n'a pas les autorisations requises.";
    }

    final Color topIconBg = isDocMissing
        ? AppColors.incorrectContainer
        : AppColors.unauthorizedBg.withValues(alpha: 0.6);

    final Color topIconBorder = isDocMissing
        ? AppColors.incorrectBorder
        : AppColors.unauthorizedBg.withValues(alpha: 0.6);

    final Color topIconColor = isDocMissing
        ? AppColors.errorText
        : AppColors.unauthorizedText;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: 90.h,
            ),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                SizedBox(height: 2.h),

                // Top Icon (User with X / Restricted)
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: topIconBg,
                    border: Border.all(color: topIconBorder, width: 1.5),
                  ),
                  child: Center(
                    child: AppIcons.userRemove(
                      size: 9.w,
                      color: topIconColor,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),

                // Main Title
                Text(
                  "Accès réservé aux participants",
                  textAlign: .center,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: .bold,
                  ),
                ),
                SizedBox(height: 1.8.h),

                // User Email Chip Box
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: AppRadius.circular12,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    mainAxisSize: .min,
                    spacing: 2.w,
                    children: [
                      AppIcons.mail(
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                      Flexible(
                        child: Text(
                          emailText,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: .w500,
                          ),
                          overflow: .ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.5.h),

                // Explanation Text
                Text(
                  descriptionText,
                  textAlign: .center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 2.5.h),

                // Status Details Card (Shown only if document exists in database)
                if (!isDocMissing) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: AppColors.card.withValues(alpha: 0.5),
                      borderRadius: AppRadius.circular12,
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          "Statut Actuel :",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: AppRadius.circular8,
                            border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            statusBadgeText,
                            style: AppTextStyles.badgeSmall.copyWith(
                              color: statusColor,
                              fontWeight: .w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                ],

                // Contact Section Container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: AppRadius.circular16,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Si vous estimez qu'il s'agit d'une erreur ou si vous souhaitez en savoir plus, vous pouvez contacter les organisateurs :",
                        textAlign: .center,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      // Email Action Button
                      InkWell(
                        onTap: () => _launchEmail(context),
                        borderRadius: AppRadius.circular12,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                          decoration: BoxDecoration(
                            color: AppColors.actionBlue.withValues(alpha: 0.12),
                            borderRadius: AppRadius.circular12,
                            border: Border.all(
                              color: AppColors.actionBlue.withValues(alpha: 0.4),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: .center,
                            spacing: 2.5.w,
                            children: [
                              AppIcons.mail(
                                color: AppColors.actionBlue,
                                size: 18,
                              ),
                              Flexible(
                                child: Text(
                                  "flutterfiresummer@gmail.com",
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.actionBlue,
                                    fontWeight: .w600,
                                  ),
                                  overflow: .ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                // Logout Button
                OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 7.w),
                    backgroundColor: AppColors.incorrectContainer.withValues(alpha: 0.4),
                    side: const BorderSide(color: AppColors.incorrectBorder, width: 1.2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.circular14,
                    ),
                  ),
                  icon: AppIcons.logout(color: AppColors.errorText, size: 18),
                  label: Text(
                    "Se déconnecter",
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.errorText,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
