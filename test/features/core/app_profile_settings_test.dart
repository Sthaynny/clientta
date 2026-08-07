import 'package:flutter_test/flutter_test.dart';
import 'package:clientta/core/storage/app_profile_settings.dart';

void main() {
  test('AppProfileSettings usa rótulo padrão sem nome', () {
    const settings = AppProfileSettings();
    expect(settings.displayUniversityLabel, 'Sua universidade');
  });

  test('AppProfileSettings round-trip no mapa de perfil', () {
    const original = AppProfileSettings(universityName: '  Minha Faculdade  ');
    final map = original.toMap();
    final restored = AppProfileSettings.fromMap(map);
    expect(restored.universityName, 'Minha Faculdade');
    expect(restored.displayUniversityLabel, 'Minha Faculdade');
  });

  test('nome vazio não persiste chave', () {
    const settings = AppProfileSettings(universityName: '   ');
    expect(settings.toMap(), isEmpty);
  });

  test('onboardingSeen round-trip no mapa de perfil', () {
    const original = AppProfileSettings(onboardingSeen: true);
    final map = original.toMap();
    final restored = AppProfileSettings.fromMap(map);
    expect(restored.onboardingSeen, isTrue);
  });

  test('onboardingSeen false não persiste chave', () {
    const settings = AppProfileSettings(onboardingSeen: false);
    expect(settings.toMap(), isEmpty);
  });
}
