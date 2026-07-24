import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/home/screen/home_view_model.dart';
import 'package:ufersa_hub/features/shared/auth/data/repositories/auth_repository.dart';
import 'package:ufersa_hub/features/shared/news/data/repositories/news_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../core/command_test.dart';

class MockRepoAuth extends Mock implements AuthRepository {}

class MockRepoNews extends Mock implements NewsRepository {}

void main() {
  final authRepo = MockRepoAuth();
  final newsRepo = MockRepoNews();
  late HomeViewModel viewModel;

  setUpAll(() {
    viewModel = HomeViewModel(
      authRepository: authRepo,
      newsRepository: newsRepo,
    );
  });

  group('HomeViewModel Tests', () {
    group('getNews', () {
      test('should return ok when news is successful', () async {
        when(() => newsRepo.getNews()).thenAnswer((_) async => Result.ok([]));

        expect(viewModel.news.completed, false);

        await viewModel.news.execute((true, null));

        expect(viewModel.news.completed, true);
        expect(viewModel.news.result?.isOk, true);
      });
      test('should return ok when news is error', () async {
        when(
          () => newsRepo.getNews(),
        ).thenAnswer((_) async => Result.errorDefault(''));

        await viewModel.news.execute((true, null));

        expect(viewModel.news.error, isTrue);
      });
    });
    group('logout', () {
      test('should return ok when logout is successful', () async {
        when(() => authRepo.logout()).thenAnswer((_) async => Result.ok());
        when(() => authRepo.isAuthenticated).thenAnswer((_) async => true);

        expect(viewModel.logout.completed, false);

        await viewModel.logout.execute();

        expect(viewModel.logout.completed, true);
        expect(viewModel.logout.result?.isOk, true);
      });
      test('should return ok when logout is error', () async {
        when(
          () => authRepo.logout(),
        ).thenAnswer((_) async => Result.errorDefault(''));
        when(() => authRepo.isAuthenticated).thenAnswer((_) async => true);

        await viewModel.logout.execute();

        expect(viewModel.logout.error, isTrue);
      });
    });
    group('isAuthenticated', () {
      test('should return ok when isAuthenticated is true', () async {
        when(() => authRepo.isAuthenticated).thenAnswer((_) async => true);

        await viewModel.authenticated.execute();

        expect(viewModel.authenticated.completed, true);
        expect(viewModel.authenticated.result?.isOk, true);
        expect(viewModel.authenticated.result?.asOk.value, true);
      });

      test('modo comunitário libera edição sem login no backend de auth', () async {
        when(() => authRepo.isAuthenticated).thenAnswer((_) async => false);

        await viewModel.authenticated.execute();

        expect(viewModel.authenticated.completed, true);
        expect(viewModel.userAuthenticated, true);
      });
    });
  });
}
