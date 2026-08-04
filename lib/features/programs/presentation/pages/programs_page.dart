import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../domain/entities/program_item.dart';

class ProgramsPage extends StatefulWidget {
  const ProgramsPage({super.key});

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProgramType? _selectedTypeFilter; // null means 'All'

  final List<ProgramItem> _programs = [];
  DocumentSnapshot? _lastDocument;
  bool _isLoadingInitial = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchPrograms(isInitial: true);
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
        _fetchPrograms(isInitial: false);
      }
    }
  }

  Future<void> _fetchPrograms({required bool isInitial}) async {
    if (isInitial) {
      setState(() {
        _isLoadingInitial = true;
        _programs.clear();
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
      Query<Map<String, dynamic>> query = _firestore.collection('programs');

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
            .map((doc) => ProgramItem.fromFirestore(doc))
            .toList();

        setState(() {
          _programs.addAll(newItems);
        });
      }
    } catch (e) {
      debugPrint('Error fetching programs: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingInitial = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  void _onFilterChanged(ProgramType? type) {
    if (_selectedTypeFilter == type) return;
    setState(() {
      _selectedTypeFilter = type;
    });
    _fetchPrograms(isInitial: true);
  }

  Future<void> _launchExternalUrl(BuildContext context, String? urlString) async {
    if (urlString == null || urlString.trim().isEmpty) return;
    final Uri url = Uri.parse(urlString.startsWith('http') ? urlString : 'https://$urlString');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Impossible d'ouvrir le lien : $urlString"),
              backgroundColor: AppColors.incorrectContainer,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'ouverture : $e"),
            backgroundColor: AppColors.incorrectContainer,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Programme & Cours"),
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
                    label: "Tous",
                    isSelected: _selectedTypeFilter == null,
                    onTap: () => _onFilterChanged(null),
                  ),
                  SizedBox(width: 2.w),
                  _buildFilterTab(
                    label: "Sessions",
                    isSelected: _selectedTypeFilter == ProgramType.session,
                    onTap: () => _onFilterChanged(ProgramType.session),
                  ),
                  SizedBox(width: 2.w),
                  _buildFilterTab(
                    label: "Workshops",
                    isSelected: _selectedTypeFilter == ProgramType.workshop,
                    onTap: () => _onFilterChanged(ProgramType.workshop),
                  ),
                  SizedBox(width: 2.w),
                  _buildFilterTab(
                    label: "Conférences",
                    isSelected: _selectedTypeFilter == ProgramType.conference,
                    onTap: () => _onFilterChanged(ProgramType.conference),
                  ),
                  SizedBox(width: 2.w),
                  _buildFilterTab(
                    label: "Groupes d'étude",
                    isSelected: _selectedTypeFilter == ProgramType.studyGroup,
                    onTap: () => _onFilterChanged(ProgramType.studyGroup),
                  ),
                  SizedBox(width: 2.w),
                  _buildFilterTab(
                    label: "Tests & Évaluations",
                    isSelected: _selectedTypeFilter == ProgramType.test,
                    onTap: () => _onFilterChanged(ProgramType.test),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.borderSubtle),

          // Body Content
          Expanded(
            child: _isLoadingInitial
                ? const AppListShimmer(itemCount: 4)
                : _programs.isEmpty
                    ? AppEmptyState(
                        title: _selectedTypeFilter == null
                            ? "Aucun programme disponible"
                            : "Aucun programme pour \"${_selectedTypeFilter!.label}\"",
                        message: "Les prochaines sessions et workshops organisés apparaîtront ici.",
                        icon: AppIcons.programs(color: AppColors.skyBlue, size: AppSizes.iconXl),
                        actionLabel: "Actualiser",
                        onAction: () => _fetchPrograms(isInitial: true),
                      )
                    : RefreshIndicator(
                        color: AppColors.skyBlue,
                        onRefresh: () => _fetchPrograms(isInitial: true),
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.all(4.w),
                          itemCount: _programs.length + (_isLoadingMore ? 1 : 0),
                          separatorBuilder: (context, index) => SizedBox(height: 2.h),
                          itemBuilder: (context, index) {
                            if (index == _programs.length) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: const Center(
                                  child: CircularProgressIndicator(color: AppColors.skyBlue),
                                ),
                              );
                            }

                            final item = _programs[index];
                            return _ProgramCard(
                              item: item,
                              onLaunchUrl: (url) => _launchExternalUrl(context, url),
                            );
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
        child: Text(
          label,
          style: AppTextStyles.buttonSmall.copyWith(
            color: isSelected ? AppColors.ultraDark : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final ProgramItem item;
  final Function(String?) onLaunchUrl;

  const _ProgramCard({
    required this.item,
    required this.onLaunchUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasLive = item.sessionUrl != null && item.sessionUrl!.trim().isNotEmpty;
    final hasReplay = item.replayUrl != null && item.replayUrl!.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.circular16,
        border: Border.all(color: AppColors.borderSubtle),
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
                  color: AppColors.actionBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadius.circular8,
                  border: Border.all(color: AppColors.actionBlue.withValues(alpha: 0.3)),
                ),
                child: Text(
                  item.type.label,
                  style: AppTextStyles.badge.copyWith(
                    color: AppColors.actionBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (item.speaker != null && item.speaker!.isNotEmpty)
                Row(
                  children: [
                    AppIcons.user(size: 14, color: AppColors.skyBlue),
                    SizedBox(width: 1.w),
                    Text(
                      item.speaker!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.skyBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text(
            item.title,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 0.8.h),
          Text(
            item.description,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 2.h),

          // Date & Horaire & Location
          Wrap(
            spacing: 3.w,
            runSpacing: 0.8.h,
            children: [
              if (item.date.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcons.calendar(size: 14, color: AppColors.textMuted),
                    SizedBox(width: 1.w),
                    Text(
                      item.date,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              if (item.time.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcons.timer(size: 14, color: AppColors.textMuted),
                    SizedBox(width: 1.w),
                    Text(
                      item.time,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              if (item.location != null && item.location!.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                    SizedBox(width: 1.w),
                    Text(
                      item.location!,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
            ],
          ),

          if (hasLive || hasReplay) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                if (hasLive)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => onLaunchUrl(item.sessionUrl),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.skyBlue),
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.circular10,
                        ),
                      ),
                      icon: AppIcons.video(size: AppSizes.iconSm, color: AppColors.skyBlue),
                      label: Text(
                        "Rejoindre Live",
                        style: AppTextStyles.buttonSmall.copyWith(color: AppColors.skyBlue),
                      ),
                    ),
                  ),
                if (hasLive && hasReplay) SizedBox(width: 2.w),
                if (hasReplay)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onLaunchUrl(item.replayUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.card,
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.circular10,
                        ),
                        side: const BorderSide(color: AppColors.borderSubtle),
                      ),
                      icon: AppIcons.video(size: AppSizes.iconSm, color: AppColors.textPrimary),
                      label: Text(
                        "Voir Replay",
                        style: AppTextStyles.buttonSmall.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
