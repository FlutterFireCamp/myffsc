import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/course_session_entity.dart';

class ProgramsPage extends StatelessWidget {
  const ProgramsPage({super.key});

  List<CourseSessionEntity> _getMockModules() {
    return const [
      CourseSessionEntity(
        id: '1',
        level: 1,
        title: 'Niveau 1 • Dart, OOP & Algorithmique',
        description: 'Bases fondamentales du langage Dart, structures de données, POO avancée et logique.',
        date: 'Lundi',
        time: '18:00 GMT',
        speaker: 'Lead Instructor',
        meetingUrl: 'https://meet.google.com',
        replayUrl: 'https://youtube.com',
      ),
      CourseSessionEntity(
        id: '2',
        level: 2,
        title: 'Niveau 2 • Flutter UI, Responsive & Assets',
        description: 'Création d\'interfaces réactives avec Sizer, Svg, HugeIcons et animations.',
        date: 'Mardi',
        time: '18:00 GMT',
        speaker: 'UI Specialist',
        meetingUrl: 'https://meet.google.com',
        replayUrl: 'https://youtube.com',
      ),
      CourseSessionEntity(
        id: '3',
        level: 3,
        title: 'Niveau 3 • State Management BLoC & Firebase',
        description: 'Clean Architecture, BLoC pattern, Firebase Auth, Firestore et Cloud Storage.',
        date: 'Mercredi',
        time: '18:00 GMT',
        speaker: 'Backend Lead',
        meetingUrl: 'https://meet.google.com',
        replayUrl: 'https://youtube.com',
      ),
      CourseSessionEntity(
        id: '4',
        level: 4,
        title: 'Niveau 4 • Capstone Project & Deployment',
        description: 'Projet de fin d\'immersion complet, tests, CI/CD et déploiement Stores.',
        date: 'Jeudi',
        time: '18:00 GMT',
        speaker: 'DevOps Engineer',
        meetingUrl: 'https://meet.google.com',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final modules = _getMockModules();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Programme d'Immersion 📚"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        itemCount: modules.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final module = modules[index];
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
        borderRadius: BorderRadius.circular(16),
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Niveau ${module.level}",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? AppColors.actionBlue : AppColors.textMuted,
                  ),
                ),
              ),
              Icon(
                isUnlocked ? AppIcons.check : AppIcons.lock,
                color: isUnlocked ? AppColors.correctText : AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text(
            module.title,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
            ),
          ),
          SizedBox(height: 0.8.h),
          Text(
            module.description,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 10.sp,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.skyBlue),
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(AppIcons.video, size: 16, color: AppColors.skyBlue),
                  label: Text(
                    "Rejoindre Live",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 9.sp,
                      color: AppColors.skyBlue,
                      fontWeight: FontWeight.bold,
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
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: AppColors.borderSubtle),
                      ),
                    ),
                    icon: const Icon(AppIcons.video, size: 16, color: AppColors.textPrimary),
                    label: Text(
                      "Voir Replay",
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 9.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
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
