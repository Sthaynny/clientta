import 'package:clientta/core/utils/input_masks.dart';

/// Normaliza telefone para agrupar histórico do mesmo cliente.
String normalizeClientPhone(String phone) => extractDigits(phone);
