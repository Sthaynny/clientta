import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Inicialização única do plugin e fusos para lembretes locais.
abstract final class LocalNotificationsBootstrap {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static bool _ready = false;

  static Future<void> ensureReady() async {
    if (_ready) return;
    tz_data.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.local);
    } catch (_) {
      // O SO define o local na primeira agenda; falha não bloqueia o app.
    }
    _ready = true;
  }
}
