import 'package:ufersa_hub/core/config/community_access.dart';
import 'package:ufersa_hub/core/utils/commands.dart';
import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/news/filter/domain/models/filter_news_model.dart';
import 'package:ufersa_hub/features/shared/auth/data/repositories/auth_repository.dart';
import 'package:ufersa_hub/features/shared/news/data/repositories/news_repository.dart';
import 'package:ufersa_hub/features/shared/news/domain/models/news_model.dart';

class HomeViewModel {
  final AuthRepository _authRepository;
  final NewsRepository _newsRepository;

  late final CommandBase logout;
  late final CommandBase authenticated;
  late final CommandAction<List<NewsModel>, (bool?, FilterNewsModel?)> news;

  HomeViewModel({
    required AuthRepository authRepository,
    required NewsRepository newsRepository,
  }) : _authRepository = authRepository,
       _newsRepository = newsRepository {
    logout = CommandBase<void>(_logout);
    authenticated = CommandBase<bool>(_authenticated);
    news = CommandAction<List<NewsModel>, (bool?, FilterNewsModel?)>(_getNews);
  }

  /// Variaveis de dados
  final _newsList = <NewsModel>[];
  bool _userAuthenticated = false;
  FilterNewsModel? _filterNews;
  FilterNewsModel? get filterNews => _filterNews;
  bool get userAuthenticated => _userAuthenticated;
  List<NewsModel> get newsList => _newsList;
  Future<Result<void>> _logout() async {
    final result = await _authRepository.logout();
    authenticated.execute();
    return result;
  }

  Future<Result<bool>> _authenticated() async {
    final result = await CommunityAccess.resolveEditorAccess(_authRepository);
    _userAuthenticated = result;

    return Result.ok(result);
  }

  Future<Result<List<NewsModel>>> _getNews(
    (bool?, FilterNewsModel?) params,
  ) async {
    final (restart, filter) = params;
    _filterNews = filter;
    final result = await _newsRepository.getNews(filter);

    switch (result) {
      case Ok _:
        if (restart ?? false || filter != null) {
          newsList.clear();
        }

        newsList.addAll(result.value as List<NewsModel>);
        break;
      case Error _:
        return result;
    }
    return result;
  }
}
