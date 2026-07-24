import 'package:flutter/widgets.dart';
import 'package:ufersa_hub/core/dependecy/dependency.dart';
import 'package:ufersa_hub/features/documents/domain/models/document_model.dart';
import 'package:ufersa_hub/features/documents/view/maneger/maneger_document_screen.dart';
import 'package:ufersa_hub/features/documents/view/page/documents_screen.dart';
import 'package:ufersa_hub/features/events/domain/models/events_model.dart';
import 'package:ufersa_hub/features/events/view/details/screen/details_event_screen.dart';
import 'package:ufersa_hub/features/events/view/details/screen/details_event_view_model.dart';
import 'package:ufersa_hub/features/events/view/maneger/maneger_events_screen.dart';
import 'package:ufersa_hub/features/events/view/page/events_screen.dart';
import 'package:ufersa_hub/features/home/screen/home_screen.dart';
import 'package:ufersa_hub/features/home/screen/home_view_model.dart';
import 'package:ufersa_hub/features/login/password/forgout_password_screen.dart';
import 'package:ufersa_hub/features/login/screen/login_screen.dart';
import 'package:ufersa_hub/features/news/args/news_args.dart';
import 'package:ufersa_hub/features/news/details/screen/details_image_screen.dart';
import 'package:ufersa_hub/features/news/details/screen/details_news_screen.dart';
import 'package:ufersa_hub/features/news/details/screen/details_news_viewmodel.dart';
import 'package:ufersa_hub/features/news/maneger/maneger_news_screen.dart';
import 'package:ufersa_hub/features/news/maneger/maneger_news_viewmodel.dart';
import 'package:ufersa_hub/features/shared/news/domain/models/news_model.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  AppRouters.home.path:
      (context) => HomeScreen(
        viewmodel: HomeViewModel(
          authRepository: dependency(),
          newsRepository: dependency(),
        ),
      ),
  AppRouters.login.path: (context) => LoginScreen(viewmodel: dependency()),
  AppRouters.forgoutPassword.path:
      (context) => ForgoutPasswordScreen(viewmodel: dependency()),
  AppRouters.detailsNews.path: (context) {
    final args = ModalRoute.of(context)?.settings.arguments as NewsArgs;
    return DetailsNewsScreen(
      viewmodel: DetailsNewsViewmodel(
        news: args.news,
        repository: dependency(),
        authRepository: dependency(),
      ),
    );
  },
  AppRouters.detailsNewsImage.path:
      (context) => DetailsImageScreen(
        heroImage: ModalRoute.of(context)?.settings.arguments as Widget,
      ),
  AppRouters.manegerNews.path:
      (context) => CreateNewsScreen(
        viewmodel: ManegerNewsViewmodel(
          repository: dependency(),
          permissionService: dependency(),
        ),
        news: ModalRoute.of(context)?.settings.arguments as NewsModel?,
      ),

  AppRouters.events.path: (context) => EventsScreen(viewModel: dependency()),
  AppRouters.detailsEvent.path:
      (context) => DetailsEventScreen(
        viewmodel: DetailsEventViewmodel(
          repository: dependency(),
          event: ModalRoute.of(context)?.settings.arguments as EventsModel,
          authRepository: dependency(),
        ),
      ),

  AppRouters.manegerEvents.path:
      (context) => ManegerEventsScreen(
        viewmodel: dependency(),
        event: ModalRoute.of(context)?.settings.arguments as EventsModel?,
      ),

  AppRouters.documents.path:
      (context) => DocumentsScreen(viewmodel: dependency()),
  AppRouters.manegerDocuments.path:
      (context) => ManegerDocumentScreen(
        viewmodel: dependency(),
        doc: ModalRoute.of(context)?.settings.arguments as DocumentModel?,
      ),
};

enum AppRouters {
  login,
  forgoutPassword,
  home,
  detailsNews,
  detailsNewsImage,
  manegerNews,
  events,
  detailsEvent,
  manegerEvents,
  documents,
  manegerDocuments;

  const AppRouters();

  /// Rotas nomeadas para uso acadêmico (sem dependência de serviços pagos).
  /// Para alterar caminhos, edite este getter e atualize `docs/ROTEAMENTO.md`.
  String get path => switch (this) {
    home => '/',
    login => '/acesso/login',
    forgoutPassword => '/acesso/recuperar-senha',
    detailsNews => '/noticias/detalhe',
    detailsNewsImage => '/noticias/imagem',
    manegerNews => '/noticias/gerenciar',
    events => '/eventos',
    detailsEvent => '/eventos/detalhe',
    manegerEvents => '/eventos/gerenciar',
    documents => '/documentos',
    manegerDocuments => '/documentos/gerenciar',
  };
}
