import 'package:clientta/features/client_care/domain/client_phone_key.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// Monta URI `tel:` a partir do telefone do cliente.
Uri? buildTelUri(String phone) {
  final digits = normalizeClientPhone(phone);
  if (digits.isEmpty) return null;
  return Uri(scheme: 'tel', path: digits);
}

/// Monta URI WhatsApp (`wa.me`) com código do país quando necessário.
Uri? buildWhatsAppUri(String phone) {
  final digits = normalizeClientPhone(phone);
  if (digits.isEmpty) return null;

  final international = digits.length <= 11 ? '55$digits' : digits;
  return Uri.parse('https://wa.me/$international');
}

Future<bool> launchClientPhoneCall(String phone) async {
  final uri = buildTelUri(phone);
  if (uri == null) return false;
  return _launchExternal(uri);
}

Future<bool> launchClientWhatsApp(String phone) async {
  final uri = buildWhatsAppUri(phone);
  if (uri == null) return false;
  return _launchExternal(uri);
}

Future<bool> _launchExternal(Uri uri) async {
  try {
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    debugPrint('client_contact_launcher: $e');
  }
  return false;
}
