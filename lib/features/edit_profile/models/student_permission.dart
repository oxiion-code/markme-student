class StudentPermissions {
  final bool canEditProfile;

  const StudentPermissions({this.canEditProfile = false});

  StudentPermissions copyWith({bool? canEditProfile}) {
    return StudentPermissions(
      canEditProfile: canEditProfile ?? this.canEditProfile,
    );
  }

  factory StudentPermissions.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const StudentPermissions();
    return StudentPermissions(
      canEditProfile: map['canEditProfile'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'canEditProfile': canEditProfile,
    };
  }
}
