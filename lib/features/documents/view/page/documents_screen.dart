import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/strings.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';
import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/documents/domain/models/document_model.dart';
import 'package:ufersa_hub/features/documents/view/page/components/card_document_widget.dart';
import 'package:ufersa_hub/features/documents/view/page/documents_view_model.dart';
import 'package:ufersa_hub/features/shared/components/app_loading_widget.dart';
import 'package:ufersa_hub/features/shared/components/body_error_default_widget.dart';
import 'package:ufersa_hub/features/shared/components/button_add_item_widget.dart';
import 'package:ufersa_hub/features/shared/components/news_app_bar.dart';
import 'package:ufersa_hub/features/shared/widgets/university_info_strip.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key, required this.viewmodel});

  final DocumentsViewModel viewmodel;

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  late final DocumentsViewModel viewmodel;

  @override
  void initState() {
    viewmodel = widget.viewmodel;
    viewmodel.getData.execute();
    viewmodel.authenticated.execute();

    viewmodel.saveFile.addListener(_onResultSaveFile);
    viewmodel.deleteDocument.addListener(_onResultDelete);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DocumentsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewmodel.saveFile.removeListener(_onResultSaveFile);
    viewmodel.saveFile.addListener(_onResultSaveFile);

    oldWidget.viewmodel.deleteDocument.removeListener(_onResultDelete);
    viewmodel.deleteDocument.addListener(_onResultDelete);
  }

  @override
  void dispose() {
    viewmodel.saveFile.removeListener(_onResultSaveFile);
    viewmodel.deleteDocument.removeListener(_onResultDelete);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewsAppBar(canPop: true, title: documentsString),
      body: Column(
        children: [
          const UniversityInfoStrip(),
          ListenableBuilder(
            listenable: widget.viewmodel.getData,
            builder: (context, child) {
              if (widget.viewmodel.getData.completed) {
                final documents =
                    viewmodel.getData.result?.value as List<DocumentModel>;
                if (documents.isEmpty) {
                  return Center(
                    child: DSHeadlineSmallText(noDocumentsString, maxLines: 4),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    viewmodel.getData.clearResult();
                    viewmodel.getData.execute();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(DSSpacing.md.value),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: CardDocumentWidget(
                          doc: document,
                          updateScreen: () {
                            viewmodel.getData.execute();
                          },
                          saveFile: () {
                            viewmodel.saveFile.execute((
                              document.base64,
                              document.fileUrl,
                              document.docExtension,
                            ));
                          },
                        ),
                        horizontalTitleGap: 4,
                        trailing:
                            viewmodel.userAuthenticated
                                ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Card(
                                      margin: EdgeInsets.zero,
                                      color: DSColors.primary.shade600,
                                      child: Align(
                                        alignment: Alignment.centerLeft,

                                        child: DSIconButton(
                                          icon: DSIcons.edit_outline,
                                          onPressed: () {
                                            context.go(
                                              AppRouters.manegerDocuments,
                                              arguments: document,
                                            );
                                          },
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    DSSpacing.xs.x,
                                    Card(
                                      margin: EdgeInsets.zero,
                                      color: DSColors.error,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: DSIconButton(
                                          icon: DSIcons.trash_outline,
                                          onPressed: () {
                                            viewmodel.deleteDocument.execute(
                                              document.uid,
                                            );
                                          },
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : null,
                      );
                    },
                  ),
                );
              }
              if (widget.viewmodel.getData.error) {
                return BodyErrorDefaultWidget(
                  title: opsErrorLoadingEventsString,
                  onPressed: () => viewmodel.getData.execute(),
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
              label: addDocumentString,
              onPressed: () async {
                final result = await context.go(AppRouters.manegerDocuments);
                if (result != null) {
                  viewmodel.getData.execute();
                }
              },
              isVisible: viewmodel.userAuthenticated,
            ),
      ),
    );
  }

  void _onResultSaveFile() {
    if (viewmodel.saveFile.completed) {
      viewmodel.saveFile.clearResult();
      context.showSnackBarSuccess(sucessDownloadFileString);
    }

    if (viewmodel.saveFile.error) {
      viewmodel.saveFile.clearResult();
      context.showSnackBarError(errorDownloadFileString);
    }
  }

  void _onResultDelete() {
    if (viewmodel.deleteDocument.completed) {
      viewmodel.getData.execute();
    }
    if (viewmodel.deleteDocument.error) {
      context.showSnackBarError(errorDeleteDocumentString);
    }
  }
}
