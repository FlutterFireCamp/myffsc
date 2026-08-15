import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';

class ProfileTestHistorySection extends StatelessWidget {
  final String userId;

  const ProfileTestHistorySection({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Historique des Évaluations",
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppIcons.tests(color: AppColors.skyBlue, size: 18),
          ],
        ),
        SizedBox(height: 1.5.h),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('tests')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular16,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: const AppShimmer(child: AppCardShimmer()),
              );
            }

            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular16,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Center(
                  child: Column(
                    children: [
                      AppIcons.tests(color: AppColors.textMuted, size: 32),
                      SizedBox(height: 1.h),
                      Text(
                        "Aucun historique d'évaluation disponible",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.2.h),
              itemBuilder: (context, index) {
                final data = docs[index].data();
                final quizTitle = data['quizTitle'] as String? ?? "Évaluation FFSC";
                final score = (data['score'] as num?)?.toInt() ?? 0;
                final totalPossible = (data['totalPossibleScore'] as num?)?.toInt() ?? 100;
                final dateStr = data['date'] as String? ?? '';
                final timeSpentSeconds = (data['timeSpentSeconds'] as num?)?.toInt() ?? 0;
                final minutes = timeSpentSeconds ~/ 60;
                final seconds = timeSpentSeconds % 60;

                final percentage = totalPossible > 0
                    ? ((score / totalPossible) * 100).round()
                    : 0;

                return Container(
                  padding: EdgeInsets.all(3.5.w),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: AppRadius.circular14,
                    border: Border.all(
                      color: percentage >= 50
                          ? AppColors.correctBorder.withValues(alpha: 0.4)
                          : AppColors.incorrectBorder.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.5.w),
                        decoration: BoxDecoration(
                          color: percentage >= 50
                              ? AppColors.correctContainer
                              : AppColors.incorrectContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "$percentage%",
                          style: AppTextStyles.caption.copyWith(
                            color: percentage >= 50
                                ? AppColors.correctText
                                : AppColors.errorText,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quizTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 0.3.h),
                            Row(
                              children: [
                                AppIcons.calendar(color: AppColors.textMuted, size: 12),
                                SizedBox(width: 1.w),
                                Text(
                                  dateStr,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 9.5.sp,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                AppIcons.time(color: AppColors.textMuted, size: 12),
                                SizedBox(width: 1.w),
                                Text(
                                  "${minutes}m ${seconds}s",
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 9.5.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppColors.actionBlue.withValues(alpha: 0.15),
                          borderRadius: AppRadius.circular8,
                        ),
                        child: Text(
                          "$score / $totalPossible Pts",
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.skyBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
