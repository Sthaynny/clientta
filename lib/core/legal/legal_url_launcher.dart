import 'package:clientta/core/legal/app_legal_constants.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> openPrivacyPolicy() =>
    _openUrl(AppLegalConstants.privacyPolicyUrl);

Future<bool> openSubscriptionPolicy() =>
    _openUrl(AppLegalConstants.subscriptionPolicyUrl);

Future<bool> openAccountDeletion() =>
    _openUrl(AppLegalConstants.accountDeletionUrl);

Future<bool> openSupportEmail() {
  final uri = Uri(
    scheme: 'mailto',
    path: AppLegalConstants.supportEmail,
    queryParameters: {'subject': supportEmailSubjectString},
  );
  return _openUrl(uri.toString());
}

Future<bool> _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await canLaunchUrl(uri)) {
    return false;
  }
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
