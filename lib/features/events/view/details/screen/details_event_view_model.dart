import 'package:ufersa_hub/core/config/community_access.dart';
import 'package:ufersa_hub/core/utils/commands.dart';
import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/events/domain/repositories/events_repository.dart';
import 'package:ufersa_hub/features/events/domain/models/events_model.dart';
import 'package:ufersa_hub/features/shared/auth/data/repositories/auth_repository.dart';

class DetailsEventViewmodel {
  DetailsEventViewmodel({
    required EventsRepository repository,
    required EventsModel event,
    required AuthRepository authRepository,
  }) : _repository = repository {
    _event = event;
    updateScreen = CommandAction<void, EventsModel>(_updateNews);
    deleteEvent = CommandAction<void, String>(_repository.deleteEvents);
    authenticated = CommandBase(() async {
      isAuthenticated = await CommunityAccess.resolveEditorAccess(
        authRepository,
      );
      return Result.ok();
    });
  }
  late final CommandAction<void, EventsModel> updateScreen;
  late final CommandAction<void, String> deleteEvent;
  late final CommandBase authenticated;

  late EventsModel _event;

  bool isAuthenticated = false;
  final EventsRepository _repository;
  EventsModel get event => _event;

  String? get imagesBase64 => _event.image;

  Future<Result<void>> _updateNews(EventsModel event) async {
    _event = event;

    return Result.ok();
  }
}
