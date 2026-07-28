import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/announcement_entity.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  List<AnnouncementEntity> _getMockAnnouncements() {
    return const [
      AnnouncementEntity(
        id: '1',
        title: 'Lancement officiel de la Semaine 4 🚀',
        content: 'Chers apprenants, le module sur BLoC Pattern & Clean Architecture est maintenant disponible. Consultez vos canaux Slack pour les groupes de travail !',
        targetLevel: 'all',
        priority: 'urgent',
        createdAt: 'Aujourd\'hui, 10:00',
        createdBy: 'Staff FFSC',
      ),
      AnnouncementEntity(
        id: '2',
        title: 'Rappel : Office Hours avec les Mentors',
        content: 'Ce vendredi à 17h GMT, séance Q&R en direct pour répondre à vos questions sur Firebase Firestore & Rules.',
        targetLevel: 'all',
        priority: 'important',
        createdAt: 'Hier, 18:00',
        createdBy: 'Lead Mentor',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final announcements = _getMockAnnouncements();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Annonces du Camp 📢"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        itemCount: announcements.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final item = announcements[index];
          final isUrgent = item.priority == 'urgent';

          return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
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
                    if (isUrgent)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppColors.firebaseOrange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "URGENT ⚡",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.firebaseOrange,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppColors.skyBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "INFO",
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.skyBlue,
                          ),
                        ),
                      ),
                    Text(
                      item.createdBy,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 9.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Text(
                  item.title,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  item.content,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
