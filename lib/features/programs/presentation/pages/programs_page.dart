import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../domain/entities/program_item.dart';
import '../widgets/program_card.dart';
import '../widgets/program_filter_tabs.dart';

class ProgramsPage extends StatefulWidget {
  const ProgramsPage({super.key});

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  final List<ProgramItem> _programs = [];
  bool _isLoadingInitial = true;
  bool _isLoadingMore = false;
  bool _hasMore = false;

  ProgramType? _selectedTypeFilter;

  @override
  void initState() {
    super.initState();
    _fetchPrograms(isInitial: true);
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
        _fetchPrograms(isInitial: false);
      }
    }
  }

  Future<void> _fetchPrograms({bool isInitial = false}) async {
    if (isInitial) {
      setState(() {
        _isLoadingInitial = true;
        _programs.clear();
        _hasMore = false;
      });
    } else {
      if (_isLoadingMore || !_hasMore) return;
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      Query<Map<String, dynamic>> query = _firestore.collection('programs');

      if (_selectedTypeFilter != null) {
        query = query.where('type', isEqualTo: _selectedTypeFilter!.toDbString());
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        final activeItems = querySnapshot.docs
            .map((doc) => ProgramItem.fromFirestore(doc))
            .where((item) => !item.isPast)
            .toList();

        // Sort ascending: nearest upcoming date first
        activeItems.sort((a, b) {
          final dtA = a.programDateTime;
          final dtB = b.programDateTime;
          if (dtA == null && dtB == null) return 0;
          if (dtA == null) return 1;
          if (dtB == null) return -1;
          return dtA.compareTo(dtB);
        });

        setState(() {
          _programs.clear();
          _programs.addAll(activeItems);
          _hasMore = false;
        });
      } else {
        setState(() {
          _hasMore = false;
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

  void _onSelectFilter(ProgramType? type) {
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

  Widget _buildEmptyState() {
    if (_selectedTypeFilter == null) {
      return AppEmptyState(
        title: "Aucun programme disponible",
        icon: AppIcons.programs(color: AppColors.skyBlue, size: AppSizes.iconXl),
        accentColor: AppColors.skyBlue,
        actionLabel: "Actualiser",
        onAction: () => _fetchPrograms(isInitial: true),
      );
    }

    final categoryColor = _selectedTypeFilter!.badgeColor;

    return AppEmptyState(
      title: "Aucun programme pour \"${_selectedTypeFilter!.label}\"",
      icon: AppIcons.programs(color: categoryColor, size: AppSizes.iconXl),
      accentColor: categoryColor,
      actionLabel: "Actualiser",
      onAction: () => _fetchPrograms(isInitial: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Programmes & Agenda",
          style: AppTextStyles.h3,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Tabs
          ProgramFilterTabs(
            selectedTypeFilter: _selectedTypeFilter,
            onSelectFilter: _onSelectFilter,
          ),

          // Body Content
          Expanded(
            child: _isLoadingInitial
                ? const AppListShimmer(itemCount: 4)
                : _programs.isEmpty
                    ? _buildEmptyState()
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
                            return ProgramCard(
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
}
