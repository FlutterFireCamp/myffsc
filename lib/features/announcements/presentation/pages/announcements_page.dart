import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/core.dart';
import '../../domain/entities/announcement_item.dart';
import '../bloc/announcements_bloc.dart';
import '../bloc/announcements_event.dart';
import '../bloc/announcements_state.dart';
import '../widgets/announcement_card.dart';
import '../widgets/announcement_filter_tabs.dart';
import '../widgets/announcements_shimmer.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final ScrollController _scrollController = ScrollController();
  AnnouncementType? _selectedTypeFilter;

  @override
  void initState() {
    super.initState();
    context.read<AnnouncementsBloc>().add(const FetchAnnouncementsEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<AnnouncementsBloc>().state;
      if (state is AnnouncementsLoadedState &&
          state.hasMore &&
          !state.isLoadingMore) {
        context
            .read<AnnouncementsBloc>()
            .add(const LoadMoreAnnouncementsEvent());
      }
    }
  }

  void _onSelectFilter(AnnouncementType? type) {
    if (_selectedTypeFilter == type) return;
    setState(() {
      _selectedTypeFilter = type;
    });
    context.read<AnnouncementsBloc>().add(FilterAnnouncementsEvent(type));
  }

  Widget _buildEmptyState(BuildContext context) {
    if (_selectedTypeFilter == null) {
      return AppEmptyState(
        title: "Aucune annonce disponible",
        icon: AppIcons.announcements(
          color: AppColors.skyBlue,
          size: AppSizes.iconXl,
        ),
        accentColor: AppColors.skyBlue,
        actionLabel: "Actualiser",
        onAction: () => context.read<AnnouncementsBloc>().add(
              FetchAnnouncementsEvent(
                filterType: _selectedTypeFilter,
                isRefresh: true,
              ),
            ),
      );
    }

    final categoryColor = _selectedTypeFilter!.color;

    return AppEmptyState(
      title: "Aucune annonce pour \"${_selectedTypeFilter!.label}\"",
      icon: _buildCategoryIcon(_selectedTypeFilter!, categoryColor),
      accentColor: categoryColor,
      actionLabel: "Actualiser",
      onAction: () => context.read<AnnouncementsBloc>().add(
            FetchAnnouncementsEvent(
              filterType: _selectedTypeFilter,
              isRefresh: true,
            ),
          ),
    );
  }

  Widget _buildCategoryIcon(AnnouncementType type, Color color) {
    switch (type) {
      case AnnouncementType.info:
        return AnnouncementType.info.icon;
      case AnnouncementType.important:
        return AnnouncementType.important.icon;
      case AnnouncementType.urgent:
        return AnnouncementType.urgent.icon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Fil d'Annonces", style: AppTextStyles.h3),
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

          // Body Content with BlocBuilder
          Expanded(
            child: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
              builder: (context, state) {
                if (state is AnnouncementsLoadingState ||
                    state is AnnouncementsInitialState) {
                  return const AnnouncementsShimmer();
                }

                if (state is AnnouncementsErrorState) {
                  return AppEmptyState(
                    title: "Erreur de chargement",
                    message: state.message,
                    icon: AppIcons.warning(
                      color: AppColors.alertRed,
                      size: AppSizes.iconXl,
                    ),
                    accentColor: AppColors.alertRed,
                    actionLabel: "Réessayer",
                    onAction: () => context.read<AnnouncementsBloc>().add(
                          FetchAnnouncementsEvent(
                            filterType: _selectedTypeFilter,
                            isRefresh: true,
                          ),
                        ),
                  );
                }

                if (state is AnnouncementsLoadedState) {
                  final announcements = state.announcements;
                  if (announcements.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return RefreshIndicator(
                    color: AppColors.skyBlue,
                    onRefresh: () async {
                      context.read<AnnouncementsBloc>().add(
                            FetchAnnouncementsEvent(
                              filterType: _selectedTypeFilter,
                              isRefresh: true,
                            ),
                          );
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: EdgeInsets.all(4.w),
                      itemCount: announcements.length +
                          (state.isLoadingMore ? 1 : 0),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 2.h),
                      itemBuilder: (context, index) {
                        if (index == announcements.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.skyBlue,
                              ),
                            ),
                          );
                        }

                        final item = announcements[index];
                        return AnnouncementCard(item: item);
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
