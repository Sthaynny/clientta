import 'package:flutter_test/flutter_test.dart';
import 'package:clientta/core/utils/client_contact_launcher.dart';

void main() {
  group('buildTelUri', () {
    test('normaliza telefone com máscara', () {
      expect(buildTelUri('(11) 99999-0000'), Uri(scheme: 'tel', path: '11999990000'));
    });

    test('retorna null para telefone vazio', () {
      expect(buildTelUri(''), isNull);
      expect(buildTelUri('   '), isNull);
    });
  });

  group('buildWhatsAppUri', () {
    test('adiciona código 55 para números brasileiros', () {
      expect(
        buildWhatsAppUri('(11) 99999-0000'),
        Uri.parse('https://wa.me/5511999990000'),
      );
    });

    test('mantém número já internacional', () {
      expect(
        buildWhatsAppUri('5511999990000'),
        Uri.parse('https://wa.me/5511999990000'),
      );
    });

    test('retorna null para telefone vazio', () {
      expect(buildWhatsAppUri(''), isNull);
    });
  });
}
