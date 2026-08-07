import 'package:flutter/services.dart';

/// Extrai apenas dígitos de um valor mascarado ou bruto.
String extractDigits(String value) => value.replaceAll(RegExp(r'\D'), '');

/// Máscaras fixas onde `#` representa um dígito.
abstract final class InputMask {
  static const cpf = '###.###.###-##';
  static const cnpj = '##.###.###/####-##';
  static const cep = '#####-###';
  static const date = '##/##/####';
  static const time = '##:##';
}

int maxDigitsForMask(String mask) => '#'.allMatches(mask).length;

/// Aplica máscara fixa onde `#` representa um dígito.
String applyFixedMask(String mask, String digits) {
  final buffer = StringBuffer();
  var digitIndex = 0;

  for (var i = 0; i < mask.length && digitIndex < digits.length; i++) {
    if (mask[i] == '#') {
      buffer.write(digits[digitIndex++]);
    } else {
      buffer.write(mask[i]);
    }
  }

  return buffer.toString();
}

String formatWithMask(String mask, String value) =>
    applyFixedMask(mask, extractDigits(value));

/// Formata telefone brasileiro: `(11) 99999-0000` ou `(11) 3333-4444`.
String formatBrPhone(String value) {
  final digits = extractDigits(value);
  if (digits.isEmpty) return '';

  final isMobile =
      digits.length > 10 || (digits.length >= 3 && digits[2] == '9');
  final maxLen = isMobile ? 11 : 10;
  final trimmed =
      digits.length > maxLen ? digits.substring(0, maxLen) : digits;

  if (trimmed.length <= 2) {
    return trimmed.length == 2 ? '($trimmed) ' : '($trimmed';
  }

  final ddd = trimmed.substring(0, 2);
  final number = trimmed.substring(2);

  if (isMobile) {
    if (number.length <= 5) return '($ddd) $number';
    return '($ddd) ${number.substring(0, 5)}-${number.substring(5)}';
  }

  if (number.length <= 4) return '($ddd) $number';
  return '($ddd) ${number.substring(0, 4)}-${number.substring(4)}';
}

String formatCpf(String value) => formatWithMask(InputMask.cpf, value);
String formatCnpj(String value) => formatWithMask(InputMask.cnpj, value);
String formatCep(String value) => formatWithMask(InputMask.cep, value);
String formatDate(String value) => formatWithMask(InputMask.date, value);
String formatTime(String value) => formatWithMask(InputMask.time, value);

/// Formatadores prontos para `TextFormField.inputFormatters`.
abstract final class InputMaskFormatters {
  static final brPhone = [BrPhoneTextInputFormatter()];
  static final cpf = [MaskTextInputFormatter(InputMask.cpf)];
  static final cnpj = [MaskTextInputFormatter(InputMask.cnpj)];
  static final cep = [MaskTextInputFormatter(InputMask.cep)];
  static final date = [MaskTextInputFormatter(InputMask.date)];
  static final time = [MaskTextInputFormatter(InputMask.time)];
}

class MaskTextInputFormatter extends TextInputFormatter {
  MaskTextInputFormatter(this.mask);

  final String mask;

  int get maxDigits => maxDigitsForMask(mask);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = extractDigits(newValue.text);
    final limited =
        digits.length > maxDigits ? digits.substring(0, maxDigits) : digits;
    final formatted = applyFixedMask(mask, limited);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: _cursorIndexForDigitCount(formatted, limited.length),
      ),
    );
  }
}

class BrPhoneTextInputFormatter extends TextInputFormatter {
  static const maxDigits = 11;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = extractDigits(newValue.text);
    final limited =
        digits.length > maxDigits ? digits.substring(0, maxDigits) : digits;
    final formatted = formatBrPhone(limited);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: _cursorIndexForDigitCount(formatted, limited.length),
      ),
    );
  }
}

int _cursorIndexForDigitCount(String formatted, int digitCount) {
  if (digitCount <= 0) return 0;

  var seen = 0;
  for (var i = 0; i < formatted.length; i++) {
    if (RegExp(r'\d').hasMatch(formatted[i])) {
      seen++;
      if (seen >= digitCount) return i + 1;
    }
  }

  return formatted.length;
}
