import 'package:ufersa_hub/core/config/community_access.dart';
import 'package:ufersa_hub/core/utils/commands.dart';
import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/shared/auth/data/repositories/auth_repository.dart';
import 'package:ufersa_hub/features/shared/news/data/repositories/news_repository.dart';
import 'package:ufersa_hub/features/shared/news/domain/models/news_model.dart';

class DetailsNewsViewmodel {
  DetailsNewsViewmodel({
    required NewsRepository repository,
    required NewsModel news,
    required AuthRepository authRepository,
  }) : _repository = repository {
    _news = news;
    updateScreen = CommandAction<void, NewsModel>(_updateNews);
    deleteNews = CommandAction<void, String>(_repository.deleteNews);
    authenticate = CommandBase(() async {
      isAuthenticated = await CommunityAccess.resolveEditorAccess(
        authRepository,
      );

      return Result.ok();
    });
  }
  late final CommandAction<void, NewsModel> updateScreen;
  late final CommandAction<void, String> deleteNews;
  late final CommandBase authenticate;

  late NewsModel _news;
  bool isAuthenticated = false;
  final NewsRepository _repository;
  NewsModel get news => _news;
  List<String> get imagesBase64 => _news.images;

  Future<Result<void>> _updateNews(NewsModel news) async {
    _news = news;

    return Result.ok();
  }
}
