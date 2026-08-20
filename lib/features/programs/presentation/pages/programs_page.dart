import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../dashboard/presentation/bloc/dashboard_event.dart';
import '../../domain/entities/program_item.dart';
import '../bloc/programs_bloc.dart';
import '../bloc/programs_event.dart';
import '../bloc/programs_state.dart';
import '../widgets/program_card.dart';
import '../widgets/program_filter_tabs.dart';
import '../widgets/programs_shimmer.dart';

class ProgramsPage extends StatefulWidget {
  const ProgramsPage({super.key});

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  ProgramType? _selectedTypeFilter;

  @override
  void initState() {
    super.initState();
    context.read<ProgramsBloc>().add(const FetchProgramsEvent());
  }

  void _onSelectFilter(ProgramType? type) {
    if (_selectedTypeFilter == type) return;
    setState(() {
      _selectedTypeFilter = type;
    });
    context.read<ProgramsBloc>().add(FilterProgramsEvent(type));
  }

  void _refreshAll() {
    context.read<ProgramsBloc>().add(
          FetchProgramsEvent(
            filterType: _selectedTypeFilter,
            isRefresh: true,
          ),
        );
    context
        .read<DashboardBloc>()
        .add(const FetchDashboardDataEvent(isRefresh: true));
  }

  Future<void> _launchExternalUrl(BuildContext context, String? urlString) async {
    if (urlString == null || urlString.trim().isEmpty) return;
    final Uri url = Uri.parse(
      urlString.startsWith('http') ? urlString : 'https://$urlString',
    );
    try {
      if (!await launchUrl(url, mode: .externalApplication)) {
        if (context.mounted) {
          AppSnackBar.showError(context, "Impossible d'ouvrir le lien : $urlString");
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.showError(context, "Erreur lors de l'ouverture : $e");
      }
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    if (_selectedTypeFilter == null) {
      return AppEmptyState(
        title: "Aucun programme disponible",
        icon: AppIcons.programs(color: AppColors.skyBlue, size: AppSizes.iconXl),
        accentColor: AppColors.skyBlue,
        actionLabel: "Actualiser",
        onAction: _refreshAll,
      );
    }

    final categoryColor = _selectedTypeFilter!.badgeColor;

    return AppEmptyState(
      title: "Aucun programme pour \"${_selectedTypeFilter!.label}\"",
      icon: AppIcons.programs(color: categoryColor, size: AppSizes.iconXl),
      accentColor: categoryColor,
      actionLabel: "Actualiser",
      onAction: _refreshAll,
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

          // Body Content with BlocBuilder
          Expanded(
            child: BlocBuilder<ProgramsBloc, ProgramsState>(
              builder: (context, state) {
                if (state is ProgramsLoadingState || state is ProgramsInitialState) {
                  return const ProgramsShimmer();
                }

                if (state is ProgramsErrorState) {
                  return AppEmptyState(
                    title: "Erreur de chargement",
                    message: state.message,
                    icon: AppIcons.warning(color: AppColors.alertRed, size: AppSizes.iconXl),
                    accentColor: AppColors.alertRed,
                    actionLabel: "Réessayer",
                    onAction: _refreshAll,
                  );
                }

                if (state is ProgramsLoadedState) {
                  final programs = state.programs;
                  if (programs.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return RefreshIndicator(
                    color: AppColors.skyBlue,
                    onRefresh: () async => _refreshAll(),
                    child: ListView.separated(
                      padding: EdgeInsets.all(4.w),
                      itemCount: programs.length,
                      separatorBuilder: (context, index) => SizedBox(height: 2.h),
                      itemBuilder: (context, index) {
                        final item = programs[index];
                        return ProgramCard(
                          item: item,
                          onLaunchUrl: (url) => _launchExternalUrl(context, url),
                        );
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
