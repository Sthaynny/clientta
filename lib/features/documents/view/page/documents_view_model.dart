import 'dart:io';

import 'package:ufersa_hub/core/config/community_access.dart';
import 'package:ufersa_hub/core/strings/strings.dart';
import 'package:ufersa_hub/core/utils/commands.dart';
import 'package:ufersa_hub/core/utils/extension/file.dart';
import 'package:ufersa_hub/core/utils/result.dart';
import 'package:ufersa_hub/features/documents/domain/models/document_model.dart';
import 'package:ufersa_hub/features/documents/domain/repositories/documents_repository.dart';
import 'package:ufersa_hub/features/shared/auth/data/repositories/auth_repository.dart';

class DocumentsViewModel {
  final DocumentsRepository _repository;

  late final CommandBase<List<DocumentModel>> getData;

  late final CommandAction<File?, (String?, String?, String)> saveFile;

  late final CommandAction<void, String> deleteDocument;

  late final CommandBase authenticated;

  DocumentsViewModel({
    required DocumentsRepository repository,
    required AuthRepository authRepository,
  }) : _repository = repository {
    getData = CommandBase<List<DocumentModel>>(
      () => _repository.getDocuments(),
    );

    saveFile = CommandAction<File?, (String?, String?, String)>((data) async {
      final (file, fileUrl, fileExt) = data;
      if (file != null) {
        final result = await file.saveFile(extensionFile: fileExt);
        if (result != null) return Result.ok(result);
      } else {
        if (fileUrl != null) {
          final result = await fileUrl.downloadFile(extensionFile: fileExt);
          if (result != null) return Result.ok(result);
        }
      }
      return Result.errorDefault(itsWasntPossibleDownloadArchiveString);
    });

    authenticated = CommandBase<bool>(() async {
      final result = await CommunityAccess.resolveEditorAccess(authRepository);
      _userAuthenticated = result;

      return Result.ok(result);
    });

    deleteDocument = CommandAction<void, String>(_repository.deleteDocuments);
  }
  bool _userAuthenticated = false;

  bool get userAuthenticated => _userAuthenticated;
}
