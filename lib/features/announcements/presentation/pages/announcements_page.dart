import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/announcement_item.dart';
import '../widgets/announcement_card.dart';
import '../widgets/announcement_filter_tabs.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  final List<AnnouncementItem> _announcements = [];
  bool _isLoadingInitial = true;
  bool _isLoadingMore = false;
  bool _hasMore = false;

  AnnouncementType? _selectedTypeFilter;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements(isInitial: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
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

  Future<void> _fetchAnnouncements({bool isInitial = false}) async {
    if (isInitial) {
      setState(() {
        _isLoadingInitial = true;
        _announcements.clear();
        _hasMore = false;
      });
    } else {
      if (_isLoadingMore || !_hasMore) return;
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final querySnapshot = await _firestore.collection('announcements').get();

      if (querySnapshot.docs.isNotEmpty) {
        final allItems = querySnapshot.docs
            .map((doc) => AnnouncementItem.fromFirestore(doc))
            .toList();

        // Sort descending by createdAt or date
        allItems.sort((a, b) {
          final dtA = a.createdAt;
          final dtB = b.createdAt;
          if (dtA == null && dtB == null) return 0;
          if (dtA == null) return 1;
          if (dtB == null) return -1;
          return dtB.compareTo(dtA);
        });

        // Filter by selected AnnouncementType
        final filteredItems = _selectedTypeFilter == null
            ? allItems
            : allItems.where((item) => item.type == _selectedTypeFilter).toList();

        setState(() {
          _announcements.clear();
          _announcements.addAll(filteredItems);
          _hasMore = false;
        });
      } else {
        setState(() {
          _hasMore = false;
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

  void _onSelectFilter(AnnouncementType? type) {
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
        title: Text(
          "Fil d'Annonces",
          style: AppTextStyles.h3,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Tabs
          AnnouncementFilterTabs(
            selectedTypeFilter: _selectedTypeFilter,
            onSelectFilter: _onSelectFilter,
          ),

          // Body Content
          Expanded(
            child: _isLoadingInitial
                ? const AppListShimmer(itemCount: 4)
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
                            return AnnouncementCard(item: item);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
