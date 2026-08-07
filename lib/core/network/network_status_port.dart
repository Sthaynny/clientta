/// Porta para checagem de conectividade (UI de offline/sync).
abstract class NetworkStatusPort {
  Future<bool> isOnline();
}
