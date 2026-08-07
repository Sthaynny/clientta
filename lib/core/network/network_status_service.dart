import 'dart:io';

import 'package:clientta/core/network/network_status_port.dart';

class NetworkStatusService implements NetworkStatusPort {
  const NetworkStatusService();

  @override
  Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup(
        'one.one.one.one',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on Object {
      return false;
    }
  }
}
