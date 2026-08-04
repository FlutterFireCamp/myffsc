import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/announcement_item.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AnnouncementType? _selectedTypeFilter; // null means 'All'

  final List<AnnouncementItem> _announcements = [];
  DocumentSnapshot? _lastDocument;
  bool _isLoadingInitial = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements(isInitial: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMore && !_isLoadingInitial) {
        _fetchAnnouncements(isInitial: false);
      }
    }
  }

  Future<void> _fetchAnnouncements({required bool isInitial}) async {
    if (isInitial) {
      setState(() {
        _isLoadingInitial = true;
        _announcements.clear();
        _lastDocument = null;
        _hasMore = true;
      });
    } else {
      if (!_hasMore || _isLoadingMore) return;
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      Query<Map<String, dynamic>> query = _firestore.collection('announcements');

      if (_selectedTypeFilter != null) {
        query = query.where('type', isEqualTo: _selectedTypeFilter!.toDbString());
      }

      query = query.orderBy('createdAt', descending: true).limit(_pageSize);

      if (_lastDocument != null && !isInitial) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.length < _pageSize) {
        _hasMore = false;
      }

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
        final newItems = querySnapshot.docs
            .map((doc) => AnnouncementItem.fromFirestore(doc))
            .toList();

        setState(() {
          _announcements.addAll(newItems);
        });
      }
    } catch (e) {
      debugPrint('Error fetching announcements: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingInitial = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  void _onFilterChanged(AnnouncementType? type) {
    if (_selectedTypeFilter == type) return;
    setState(() {
      _selectedTypeFilter = type;
    });
    _fetchAnnouncements(isInitial: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Annonces du Camp"),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            color: AppColors.background,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  _buildFilterTab(
                    label: "Toutes",
                    isSelected: _selectedTypeFilter == null,
                    onTap: () => _onFilterChanged(null),
                  ),
                  SizedBox(width: 2.w),
                  _buildFilterTab(
                    label: "Informations",
                    isSelected: _selectedTypeFilter == AnnouncementType.info,
                    icon: AppIcons.info(
                      color: _selectedTypeFilter == AnnouncementType.info ? AppColors.ultraDark : AppColors.skyBlue,
                      size: 16,
                    ),
                    onTap: () => _onFilterChanged(AnnouncementType.info),
                  ),
                  SizedBox(width: 2.w),
                  _buildFilterTab(
                    label: "Flash Info",
                    isSelected: _selectedTypeFilter == AnnouncementType.important,
                    icon: AppIcons.star(
                      color: _selectedTypeFilter == AnnouncementType.important ? AppColors.ultraDark : AppColors.firebaseYellow,
                      size: 16,
                    ),
                    onTap: () => _onFilterChanged(AnnouncementType.important),
                  ),
                  SizedBox(width: 2.w),
                  _buildFilterTab(
                    label: "Urgences",
                    isSelected: _selectedTypeFilter == AnnouncementType.urgent,
                    icon: AppIcons.alert02(
                      color: _selectedTypeFilter == AnnouncementType.urgent ? Colors.white : AppColors.errorText,
                      size: 16,
                    ),
                    onTap: () => _onFilterChanged(AnnouncementType.urgent),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.borderSubtle),

          // Body Content
          Expanded(
            child: _isLoadingInitial
                ? const Center(child: CircularProgressIndicator(color: AppColors.skyBlue))
                : _announcements.isEmpty
                    ? AppEmptyState(
                        title: _selectedTypeFilter == null
                            ? "Aucune annonce disponible"
                            : "Aucune annonce pour la catégorie \"${_selectedTypeFilter!.label}\"",
                        message: "Les nouvelles annonces publiées par les mentors et l'équipe pédagogique apparaîtront ici.",
                        icon: AppIcons.announcements(color: AppColors.skyBlue, size: AppSizes.iconXl),
                        actionLabel: "Actualiser",
                        onAction: () => _fetchAnnouncements(isInitial: true),
                      )
                    : RefreshIndicator(
                        color: AppColors.skyBlue,
                        onRefresh: () => _fetchAnnouncements(isInitial: true),
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.all(4.w),
                          itemCount: _announcements.length + (_isLoadingMore ? 1 : 0),
                          separatorBuilder: (context, index) => SizedBox(height: 2.h),
                          itemBuilder: (context, index) {
                            if (index == _announcements.length) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: const Center(
                                  child: CircularProgressIndicator(color: AppColors.skyBlue),
                                ),
                              );
                            }

                            final item = _announcements[index];
                            return _AnnouncementCard(item: item);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required bool isSelected,
    Widget? icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circular12,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.skyBlue : AppColors.card,
          borderRadius: AppRadius.circular12,
          border: Border.all(
            color: isSelected ? AppColors.skyBlue : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon,
              SizedBox(width: 1.5.w),
            ],
            Text(
              label,
              style: AppTextStyles.buttonSmall.copyWith(
                color: isSelected ? AppColors.ultraDark : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final AnnouncementItem item;

  const _AnnouncementCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular16,
        border: Border.all(
          color: item.type.color.withValues(alpha: 0.5),
          width: item.type == AnnouncementType.urgent ? 1.5 : 1.0,
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
                  color: item.type.color.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular8,
                  border: Border.all(color: item.type.color.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    item.type.icon,
                    SizedBox(width: 1.5.w),
                    Text(
                      item.type.label.toUpperCase(),
                      style: AppTextStyles.badge.copyWith(
                        color: item.type.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                decoration: BoxDecoration(
                  color: AppColors.ultraDark.withValues(alpha: 0.5),
                  borderRadius: AppRadius.circular6,
                ),
                child: Text(
                  "Cible: ${item.targetRole.label}",
                  style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.8.h),
          Text(
            item.title,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            item.description,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AppIcons.calendar(size: 14, color: AppColors.textMuted),
                  SizedBox(width: 1.w),
                  Text(
                    item.date.isNotEmpty ? item.date : "Date non précisée",
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
