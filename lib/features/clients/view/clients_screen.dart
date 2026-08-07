import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/features/client_care/domain/models/client_care_args.dart';
import 'package:clientta/features/clients/domain/models/client_profile.dart';
import 'package:clientta/features/clients/view/clients_view_model.dart';
import 'package:clientta/features/shared/components/app_loading_widget.dart';
import 'package:clientta/features/shared/components/body_error_default_widget.dart';
import 'package:clientta/features/shared/hub/hub.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key, required this.viewmodel});

  final ClientsViewModel viewmodel;

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen>
    with RouteAware, HubRouteRefreshMixin {
  ClientsViewModel get viewmodel => widget.viewmodel;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewmodel.load.execute();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void onHubRouteVisible() => viewmodel.load.execute();

  void _onSearchChanged() {
    setState(() => viewmodel.setSearchQuery(_searchController.text));
  }

  Future<void> _openClientCare(ClientProfile profile) async {
    await context.go(
      AppRouters.clientCare,
      arguments: ClientCareArgs(
        clientName: profile.clientName,
        clientPhone: profile.clientPhone,
        serviceType: profile.serviceType,
      ),
    );
    if (!mounted) return;
    viewmodel.load.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HubAppBar(
        canPop: true,
        title: myClientsString,
        showBrandMark: false,
        onBackButtonPressed:
            () => Navigator.of(context).pushReplacementNamed(
              AppRouters.home.path,
            ),
      ),
      body: ListenableBuilder(
        listenable: viewmodel.load,
        builder: (context, _) {
          if (viewmodel.load.running && viewmodel.profiles.isEmpty) {
            return const AppLoadingWidget();
          }
          if (viewmodel.load.error) {
            return BodyErrorDefaultWidget(
              title: errorLoadDailyString,
              onPressed: () => viewmodel.load.execute(),
            );
          }

          return RefreshIndicator(
            color: HubColors.seed,
            onRefresh: () async => viewmodel.load.execute(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(DSSpacing.md.value),
              children: [
                HubScreenIntro(
                  icon: Icons.people_outline_rounded,
                  message: clientsScreenIntroString,
                  iconColor: HubColors.seed,
                ),
                DSSpacing.md.y,
                HubSectionHeader(
                  title: myClientsString,
                  count: viewmodel.visibleProfiles.isEmpty
                      ? null
                      : viewmodel.visibleProfiles.length,
                ),
                DSSpacing.sm.y,
                HubSearchField(
                  controller: _searchController,
                  label: clientsSearchHintString,
                  onChanged: (_) => setState(() {}),
                ),
                DSSpacing.md.y,
                if (viewmodel.profiles.isEmpty)
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.38,
                    child: HubEmptyState(
                      embedded: true,
                      icon: Icons.people_outline_rounded,
                      title: clientsEmptyTitleString,
                      message: clientsEmptyMessageString,
                    ),
                  )
                else if (viewmodel.visibleProfiles.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: DSSpacing.lg.value),
                    child: HubEmptyState(
                      embedded: true,
                      icon: Icons.person_search_outlined,
                      title: clientsSearchEmptyTitleString,
                      message: clientsSearchEmptyMessageString,
                    ),
                  )
                else
                  ...viewmodel.visibleProfiles.map(
                    (profile) => HubClientCard(
                      profile: profile,
                      onTap: () => _openClientCare(profile),
                    ),
                  ),
                DSSpacing.xl.y,
              ],
            ),
          );
        },
      ),
    );
  }
}
