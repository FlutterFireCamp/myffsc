import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../../tests/presentation/widgets/test_correction_bottom_sheet.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import '../../domain/entities/user_test_history_entity.dart';
import '../../domain/usecases/profile_usecases.dart';

class ProfileTestHistorySection extends StatelessWidget {
  final String userId;

  const ProfileTestHistorySection({super.key, required this.userId});

  void _handleViewDetails(BuildContext context, UserTestHistoryEntity item) {
    final questionsFuture = sl<GetTestCorrectionDetailsUseCase>()(
      GetTestCorrectionDetailsParams(
        quizId: item.quizId,
        dateStr: item.dateStr,
        docId: item.docId,
        rawAnswers: item.rawAnswers,
      ),
    ).then((either) => either.getOrElse((_) => []));

    TestCorrectionBottomSheet.show(
      context,
      quizTitle: item.quizTitle,
      dateFormatted: item.dateStr,
      totalScore: item.score,
      totalPossibleScore: item.displayTotalPossibleScore,
      status: item.status,
      questionsFuture: questionsFuture,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.isLoadingHistory) {
          return Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    "Historique des Évaluations",
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: .bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.2.h),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: AppRadius.circular16,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: const AppShimmer(child: AppCardShimmer()),
              ),
            ],
          );
        }

        final allHistory = state.testHistory;
        final totalCount = allHistory.length;
        // Display at most 2 tests in profile
        final displayedHistory = allHistory.take(2).toList();
        final displayedCount = displayedHistory.length;

        final countBadgeText = totalCount > 0
            ? "($displayedCount/$totalCount)"
            : "";

        return Column(
          crossAxisAlignment: .start,
          children: [
            // Section Header with (displayed / total) indicator (Fixed & Static)
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  "Historique des Évaluations",
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: .bold,
                  ),
                ),
                if (countBadgeText.isNotEmpty)
                  Text(
                    countBadgeText,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 1.h),

            if (displayedHistory.isEmpty)
              Container(
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
              )
            else
              Expanded(
                child: ListView.separated(
                  // Only scrolls when history count is >= 2, otherwise stays static
                  physics: displayedHistory.length > 1
                      ? const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        )
                      : const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 12.h),
                  itemCount: displayedHistory.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.2.h),
                  itemBuilder: (context, index) {
                    final item = displayedHistory[index];

                    // Status: only 'pending' is EN ATTENTE (Yellow), everything else is CORRIGÉ (Green)
                    final rawStatus = item.status.trim().toLowerCase();
                    final isPending = rawStatus == 'pending';

                    final badgeLabel = isPending ? "En Attente" : "Corrigé";
                    final badgeColor = isPending
                        ? AppColors.firebaseYellow
                        : AppColors.correctText;
                    final badgeBg = isPending
                        ? AppColors.firebaseYellow.withValues(alpha: 0.15)
                        : AppColors.successGreen.withValues(alpha: 0.15);
                    final badgeBorder = isPending
                        ? AppColors.firebaseYellow.withValues(alpha: 0.4)
                        : AppColors.successGreen.withValues(alpha: 0.3);

                    return Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: AppRadius.circular16,
                        border: Border.all(
                          color: AppColors.borderSubtle,
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          // Top Row: Title + Date (Left) & Badge (Right)
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            crossAxisAlignment: .start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: .start,
                                  spacing: 0.4.h,
                                  children: [
                                    Text(
                                      item.quizTitle,
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: .bold,
                                      ),
                                    ),
                                    Text(
                                      "Date : ${item.dateStr}",
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Badge matching Home Session badge size and style
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: badgeBg,
                                  borderRadius: AppRadius.circular6,
                                  border: Border.all(color: badgeBorder),
                                ),
                                child: Text(
                                  badgeLabel,
                                  style: AppTextStyles.badge.copyWith(
                                    color: badgeColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Divider Line
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.2.h),
                            child: const Divider(
                              color: AppColors.borderSubtle,
                              height: 1,
                              thickness: 0.8,
                            ),
                          ),

                          // Bottom Row: Score (Left) & Voir détails TextButton (Right)
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Text(
                                "${item.score} / ${item.displayTotalPossibleScore} pts",
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.skyBlue,
                                  fontWeight: .bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    _handleViewDetails(context, item),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize: .shrinkWrap,
                                ),
                                child: Text(
                                  "Voir détails",
                                  style: AppTextStyles.buttonSmall.copyWith(
                                    color: AppColors.skyBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
