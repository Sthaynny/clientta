/// Preferências locais do perfil (sem nuvem).
class AppProfileSettings {
  const AppProfileSettings({
    this.universityName,
    this.onboardingSeen = false,
  });

  final String? universityName;
  final bool onboardingSeen;

  static const profileRootKey = 'profile';

  factory AppProfileSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const AppProfileSettings();
    final name = map['universityName'];
    final seen = map['onboardingSeen'];
    return AppProfileSettings(
      universityName:
          name is String && name.trim().isNotEmpty ? name.trim() : null,
      onboardingSeen: seen == true,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    final name = universityName?.trim();
    if (name != null && name.isNotEmpty) {
      map['universityName'] = name;
    }
    if (onboardingSeen) {
      map['onboardingSeen'] = true;
    }
    return map;
  }

  AppProfileSettings copyWith({
    String? universityName,
    bool? onboardingSeen,
  }) {
    return AppProfileSettings(
      universityName: universityName ?? this.universityName,
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
    );
  }

  String get displayUniversityLabel =>
      (universityName != null && universityName!.isNotEmpty)
          ? universityName!
          : 'Sua universidade';
}
