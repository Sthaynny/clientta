import 'package:flutter_test/flutter_test.dart';
import 'package:clientta/core/utils/input_masks.dart';

void main() {
  group('formatBrPhone', () {
    test('formata celular com 11 dígitos', () {
      expect(formatBrPhone('11999990000'), '(11) 99999-0000');
    });

    test('formata fixo com 10 dígitos', () {
      expect(formatBrPhone('1133334444'), '(11) 3333-4444');
    });

    test('detecta celular pelo nono dígito', () {
      expect(formatBrPhone('119'), '(11) 9');
    });

    test('preserva valor já mascarado', () {
      expect(formatBrPhone('(11) 99999-0000'), '(11) 99999-0000');
    });

    test('retorna vazio para entrada vazia', () {
      expect(formatBrPhone(''), '');
      expect(formatBrPhone('   '), '');
    });
  });

  group('formatWithMask', () {
    test('formata CPF', () {
      expect(formatCpf('12345678901'), '123.456.789-01');
    });

    test('formata CNPJ', () {
      expect(formatCnpj('12345678000199'), '12.345.678/0001-99');
    });

    test('formata CEP', () {
      expect(formatCep('01310100'), '01310-100');
    });

    test('formata data', () {
      expect(formatDate('07082026'), '07/08/2026');
    });

    test('formata hora', () {
      expect(formatTime('0930'), '09:30');
    });
  });

  group('extractDigits', () {
    test('remove caracteres não numéricos', () {
      expect(extractDigits('(11) 99999-0000'), '11999990000');
      expect(extractDigits('123.456.789-01'), '12345678901');
    });
  });

  group('applyFixedMask', () {
    test('limita dígitos ao tamanho da máscara', () {
      expect(
        applyFixedMask(InputMask.cpf, '123456789012345'),
        '123.456.789-01',
      );
    });
  });
}
