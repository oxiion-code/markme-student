class Qualification {
  final String qualificationType;
  final String institutionName;
  final String boardOrUniversity;
  final String? streamOrSpecialization;
  final double? percentage;
  final int passingOutYear;
  final String? notes;
  final String? documentUrl;
  final bool isDocumentVerified;

  Qualification({
    required this.qualificationType,
    required this.institutionName,
    required this.boardOrUniversity,
    this.streamOrSpecialization,
    this.percentage,
    required this.passingOutYear,
    this.notes,
    this.documentUrl,
    this.isDocumentVerified = false,
  });

  Qualification copyWith({
    String? qualificationType,
    String? institutionName,
    String? boardOrUniversity,
    String? streamOrSpecialization,
    double? percentage,
    int? passingOutYear,
    String? notes,
    String? documentUrl,
    bool? isDocumentVerified,
  }) {
    return Qualification(
      qualificationType: qualificationType ?? this.qualificationType,
      institutionName: institutionName ?? this.institutionName,
      boardOrUniversity: boardOrUniversity ?? this.boardOrUniversity,
      streamOrSpecialization:
      streamOrSpecialization ?? this.streamOrSpecialization,
      percentage: percentage ?? this.percentage,
      passingOutYear: passingOutYear ?? this.passingOutYear,
      notes: notes ?? this.notes,
      documentUrl: documentUrl ?? this.documentUrl,
      isDocumentVerified:
      isDocumentVerified ?? this.isDocumentVerified,
    );
  }

  factory Qualification.fromMap(Map<String, dynamic> map) {
    return Qualification(
      qualificationType: map['qualificationType'],
      institutionName: map['institutionName'],
      boardOrUniversity: map['boardOrUniversity'],
      streamOrSpecialization: map['streamOrSpecialization'],
      percentage: map['percentage']?.toDouble(),
      passingOutYear: map['passingOutYear'],
      notes: map['notes'],
      documentUrl: map['documentUrl'],
      isDocumentVerified: map['isDocumentVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'qualificationType': qualificationType,
      'institutionName': institutionName,
      'boardOrUniversity': boardOrUniversity,
      'streamOrSpecialization': streamOrSpecialization,
      'percentage': percentage,
      'passingOutYear': passingOutYear,
      'notes': notes,
      'documentUrl': documentUrl,
      'isDocumentVerified': isDocumentVerified,
    };
  }
}
