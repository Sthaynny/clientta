import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/strings.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/features/home/screen/components/app_drawer.dart';
import 'package:ufersa_hub/features/home/screen/components/card_news_widget.dart';
import 'package:ufersa_hub/features/home/screen/home_view_model.dart';
import 'package:ufersa_hub/features/home/utils/home_strings.dart';
import 'package:ufersa_hub/features/news/filter/screen/filter_screen.dart';
import 'package:ufersa_hub/features/news/filter/screen/filter_view_model.dart';
import 'package:ufersa_hub/features/shared/components/app_loading_widget.dart';
import 'package:ufersa_hub/features/shared/components/body_error_default_widget.dart';
import 'package:ufersa_hub/features/shared/components/button_add_item_widget.dart';
import 'package:ufersa_hub/features/shared/components/news_app_bar.dart';
import 'package:ufersa_hub/features/shared/widgets/university_info_strip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewmodel});
  final HomeViewModel viewmodel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel viewmodel;

  @override
  void initState() {
    viewmodel = widget.viewmodel;
    viewmodel.authenticated.execute().then((_) {
      viewmodel.news.execute((true, null));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewsAppBar(
        leading: Builder(
          builder: (context) {
            return DSIconButton(
              key: Key('menu_button'),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: DSIcons.menu_dot_outline,
            );
          },
        ),
        actions: [
          DSIconButton(
            onPressed: () async {
              final result = await showModalBottomSheet(
                context: context,
                builder:
                    (context) => FilterScreen(
                      viewModel: FilterViewModel(filter: viewmodel.filterNews),
                    ),
              );

              if (result != null) {
                if (result is bool) {
                  viewmodel.news.execute((true, null));
                  return;
                } else {
                  viewmodel.news.execute((true, result));
                }
              }
            },
            icon: DSIcons.filter_outline,
          ),
        ],
      ),
      drawer: AppDrawer(viewmodel: viewmodel),
      body: Column(
        children: [
          const UniversityInfoStrip(),
          ListenableBuilder(
            listenable: viewmodel.news,
            builder: (_, __) {
              if (viewmodel.news.completed) {
                if (viewmodel.newsList.isEmpty) {
                  return Center(
                    child: DSHeadlineSmallText(
                      noNewsRegisterString,
                      maxLines: 4,
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: DSSpacing.xs.value,
                    ),
                    itemCount: viewmodel.newsList.length,
                    itemBuilder: (_, index) {
                      final news = viewmodel.newsList[index];
                      return CardNewsWidget(
                        news: news,
                        isAuthenticated: viewmodel.userAuthenticated,
                        onAction: () {
                          viewmodel.news.execute((true, null));
                        },
                      );
                    },
                  ),
                );
              }
              if (viewmodel.news.error && viewmodel.newsList.isEmpty) {
                return BodyErrorDefaultWidget(
                  title: HomeStrings.error.label,
                  onPressed: () => viewmodel.news.execute((true, null)),
                );
              }
              return AppLoadingWidget();
            },
          ),
        ],
      ),
      floatingActionButton: ListenableBuilder(
        listenable: viewmodel.authenticated,
        builder:
            (context, child) => ButtonAddItemWidget(
              label: HomeStrings.addNews.label,

              onPressed: () {
                context.go(AppRouters.manegerNews);
              },
              isVisible: viewmodel.userAuthenticated,
            ),
      ),
    );
  }
}
