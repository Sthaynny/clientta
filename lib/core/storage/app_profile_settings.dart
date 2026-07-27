/// Preferências locais do estudante (sem nuvem).
class AppProfileSettings {
  const AppProfileSettings({this.universityName});

  final String? universityName;

  static const profileRootKey = 'profile';

  factory AppProfileSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const AppProfileSettings();
    final name = map['universityName'];
    if (name is String && name.trim().isNotEmpty) {
      return AppProfileSettings(universityName: name.trim());
    }
    return const AppProfileSettings();
  }

  Map<String, dynamic> toMap() {
    final name = universityName?.trim();
    if (name == null || name.isEmpty) return {};
    return {'universityName': name};
  }

  AppProfileSettings copyWith({String? universityName}) {
    return AppProfileSettings(
      universityName: universityName ?? this.universityName,
    );
  }

  String get displayUniversityLabel =>
      (universityName != null && universityName!.isNotEmpty)
          ? universityName!
          : 'Sua universidade';
}
