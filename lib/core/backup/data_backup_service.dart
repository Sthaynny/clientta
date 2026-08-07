import 'dart:convert';
import 'dart:io';

import 'package:clientta/core/backup/data_backup_parser.dart';
import 'package:clientta/core/plan/plan_access_policy.dart';
import 'package:clientta/core/storage/device_json_store.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Exporta `clientta_data.json` como arquivo compartilhável — recurso Pro.
class DataBackupService {
  DataBackupService({
    required DeviceJsonStore store,
    required BillingRepository billingRepository,
  }) : _store = store,
       _billingRepository = billingRepository;

  static const schemaVersion = 1;

  final DeviceJsonStore _store;
  final BillingRepository _billingRepository;

  Future<Result<void>> shareBackup() async {
    try {
      final subscription = await _billingRepository.getSubscription();
      if (!PlanAccessPolicy.canExportDataBackup(subscription)) {
        return Result.error(Exception('pro_required'));
      }

      final root = await _store.readRoot();
      final exportedAt = DateTime.now().toUtc();
      final envelope = {
        'schemaVersion': schemaVersion,
        'exportedAt': exportedAt.toIso8601String(),
        'app': 'clientta',
        'sourceFile': DeviceJsonStore.fileName,
        'data': root,
      };

      final dir = await getTemporaryDirectory();
      final fileName = _backupFileName(exportedAt);
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(envelope),
      );

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(file.path, mimeType: 'application/json', name: fileName),
          ],
          subject: fileName,
        ),
      );

      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<DataBackupImportSummary>> importBackup() async {
    try {
      final subscription = await _billingRepository.getSubscription();
      if (!PlanAccessPolicy.canImportDataBackup(subscription)) {
        return Result.error(Exception('pro_required'));
      }

      final picked = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['json'],
        withData: true,
        allowMultiple: false,
      );
      if (picked == null || picked.files.isEmpty) {
        return Result.error(Exception('cancelled'));
      }

      final file = picked.files.first;
      final contents = await _readPickedFile(file);
      if (contents == null || contents.trim().isEmpty) {
        return Result.error(Exception('invalid_format'));
      }

      final data = DataBackupParser.parseRoot(contents);
      if (data == null || data.isEmpty) {
        return Result.error(Exception('invalid_format'));
      }

      await _store.writeRoot(data);
      return Result.ok(DataBackupParser.summarize(data));
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<String?> _readPickedFile(PlatformFile file) async {
    final bytes = file.bytes;
    if (bytes != null) {
      return utf8.decode(bytes);
    }
    final path = file.path;
    if (path == null) return null;
    return File(path).readAsString();
  }

  String _backupFileName(DateTime exportedAt) {
    final stamp =
        '${exportedAt.year}'
        '${exportedAt.month.toString().padLeft(2, '0')}'
        '${exportedAt.day.toString().padLeft(2, '0')}_'
        '${exportedAt.hour.toString().padLeft(2, '0')}'
        '${exportedAt.minute.toString().padLeft(2, '0')}';
    return 'clientta_backup_$stamp.json';
  }
}
