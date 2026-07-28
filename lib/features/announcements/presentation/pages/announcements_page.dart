import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/announcement_entity.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  static const List<AnnouncementEntity> _mockAnnouncements = [
    AnnouncementEntity(
      id: '1',
      title: 'Lancement Officiel de la Semaine 2 🚀',
      content: 'Bienvenue dans la deuxième semaine d\'immersion. Les modules BLoC Pattern et Clean Architecture sont désormais accessibles.',
      targetLevel: 'all',
      priority: 'urgent',
      createdAt: 'Hier à 14:00',
      createdBy: 'Équipe Pédagogique FFSC',
    ),
    AnnouncementEntity(
      id: '2',
      title: 'Session Live Mentorat - Mercredi 18h GMT',
      content: 'Rejoignez-nous pour la live Q&A avec nos mentors Flutter/Firebase. Préparez vos questions sur les state managers.',
      targetLevel: 'all',
      priority: 'important',
      createdAt: 'Il y a 2 jours',
      createdBy: 'Mentors Tech',
    ),
    AnnouncementEntity(
      id: '3',
      title: 'Rappel : Soumission des Standups Quotidiens',
      content: 'N\'oubliez pas de soumettre vos standups quotidiens via l\'onglet Formulaires pour accumuler vos points FFSC.',
      targetLevel: 'all',
      priority: 'normal',
      createdAt: 'Il y a 3 jours',
      createdBy: 'Staff FFSC',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Annonces du Camp"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(4.w),
        itemCount: _mockAnnouncements.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final item = _mockAnnouncements[index];
          final isUrgent = item.priority == 'urgent';

          return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadius.circular16,
              border: Border.all(
                color: isUrgent ? AppColors.firebaseOrange : AppColors.borderSubtle,
                width: isUrgent ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: isUrgent
                            ? AppColors.firebaseOrange.withValues(alpha: 0.2)
                            : AppColors.skyBlue.withValues(alpha: 0.15),
                        borderRadius: AppRadius.circular6,
                      ),
                      child: Text(
                        isUrgent ? "URGENT ⚡" : "INFO",
                        style: AppTextStyles.badge.copyWith(
                          color: isUrgent ? AppColors.firebaseOrange : AppColors.skyBlue,
                        ),
                      ),
                    ),
                    Text(
                      item.createdBy,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Text(
                  item.title,
                  style: AppTextStyles.titleLarge,
                ),
                SizedBox(height: 1.h),
                Text(
                  item.content,
                  style: AppTextStyles.bodyMedium,
                ),
                SizedBox(height: 1.5.h),
                Text(
                  item.createdAt,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
