import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/theme.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final VoidCallback? onConfirm;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = "Confirmer",
    this.cancelText = "Annuler",
    this.isDestructive = false,
    this.onConfirm,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = "Confirmer",
    String cancelText = "Annuler",
    bool isDestructive = false,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AppConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.modalBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.circular20,
        side: BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            // Title matching Dashboard greeting style (AppTextStyles.h3)
            Text(
              title,
              style: AppTextStyles.h3,
            ),
            SizedBox(height: 1.5.h),

            // Short Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 3.h),

            // Action Buttons
            Row(
              mainAxisAlignment: .end,
              spacing: 3.w,
              children: [
                // Cancel Button
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.borderSubtle),
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.circular12,
                    ),
                  ),
                  child: Text(
                    cancelText,
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                // Confirm Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onConfirm?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDestructive ? AppColors.errorText : AppColors.actionBlue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.circular12,
                    ),
                  ),
                  child: Text(
                    confirmText,
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: Colors.white,
                      fontWeight: .bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
