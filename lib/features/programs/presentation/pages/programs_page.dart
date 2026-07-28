import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/course_session_entity.dart';

class ProgramsPage extends StatelessWidget {
  const ProgramsPage({super.key});

  static const List<CourseSessionEntity> _mockModules = [
    CourseSessionEntity(
      id: 'm1',
      title: 'Semaine 1 : Fondations Flutter & Dart Moderne',
      description: 'Prise en main des Widgets avancés, de la gestion d\'état locale, des Null Safety et du typage fort en Dart.',
      date: '15 Juillet 2026',
      time: '18:00 GMT',
      level: 1,
      speaker: 'Mentor FFSC',
      meetingUrl: 'https://meet.google.com/abc-defg-hij',
      replayUrl: 'https://youtube.com/watch?v=example1',
    ),
    CourseSessionEntity(
      id: 'm2',
      title: 'Semaine 2 : Architecture Clean & BLoC Pattern',
      description: 'Structuration en couches (Data, Domain, Presentation), gestion des événements et des états réactifs avec flutter_bloc.',
      date: '22 Juillet 2026',
      time: '18:00 GMT',
      level: 2,
      speaker: 'Senior Flutter Dev',
      meetingUrl: 'https://meet.google.com/klm-nopq-rst',
      replayUrl: 'https://youtube.com/watch?v=example2',
    ),
    CourseSessionEntity(
      id: 'm3',
      title: 'Semaine 3 : Intégration Firebase Suite (Auth, Firestore, Cloud Functions)',
      description: 'Authentification Google, stockage réactif Firestore, règles de sécurité et déploiement backend serveur sans serveur.',
      date: '29 Juillet 2026',
      time: '18:00 GMT',
      level: 3,
      speaker: 'GDE Firebase',
      meetingUrl: 'https://meet.google.com/uvw-xyz1-234',
      replayUrl: null,
    ),
    CourseSessionEntity(
      id: 'm4',
      title: 'Semaine 4 : Capstone Project & Production Readiness',
      description: 'Optimisation des performances, CI/CD, tests unitaires/UI et publication des applications.',
      date: '05 Août 2026',
      time: '18:00 GMT',
      level: 4,
      speaker: 'Lead Architect',
      meetingUrl: '',
      replayUrl: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Programme & Cours"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(4.w),
        itemCount: _mockModules.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final module = _mockModules[index];
          return _ModuleCard(module: module);
        },
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final CourseSessionEntity module;

  const _ModuleCard({required this.module});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = module.replayUrl != null || module.meetingUrl.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.card : AppColors.ultraDark,
        borderRadius: AppRadius.circular16,
        border: Border.all(
          color: isUnlocked ? AppColors.borderSubtle : AppColors.card,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? AppColors.actionBlue.withValues(alpha: 0.15)
                      : AppColors.card,
                  borderRadius: AppRadius.circular8,
                ),
                child: Text(
                  "Niveau ${module.level}",
                  style: AppTextStyles.badge.copyWith(
                    color: isUnlocked ? AppColors.actionBlue : AppColors.textMuted,
                  ),
                ),
              ),
              isUnlocked
                  ? AppIcons.check(color: AppColors.correctText, size: AppSizes.iconMd)
                  : AppIcons.lock(color: AppColors.textMuted, size: AppSizes.iconMd),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text(
            module.title,
            style: AppTextStyles.titleLarge.copyWith(
              color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
            ),
          ),
          SizedBox(height: 0.8.h),
          Text(
            module.description,
            style: AppTextStyles.bodyMedium,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isUnlocked ? () {} : null,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isUnlocked ? AppColors.skyBlue : AppColors.borderSubtle,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.2.h),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.circular10,
                    ),
                  ),
                  icon: AppIcons.video(
                    size: AppSizes.iconSm,
                    color: isUnlocked ? AppColors.skyBlue : AppColors.textMuted,
                  ),
                  label: Text(
                    "Rejoindre Live",
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: isUnlocked ? AppColors.skyBlue : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              if (module.replayUrl != null) ...[
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.card,
                      padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.circular10,
                      ),
                    ),
                    icon: AppIcons.video(size: AppSizes.iconSm, color: AppColors.textPrimary),
                    label: Text(
                      "Replay",
                      style: AppTextStyles.buttonSmall,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
