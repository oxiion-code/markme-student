class Eligibility {
  final List<String> batches;
  final double minCgpa;
  final int maxBacklogs;

  const Eligibility({
    required this.batches,
    required this.minCgpa,
    required this.maxBacklogs,
  });

  factory Eligibility.fromJson(Map<String, dynamic> json) {
    return Eligibility(
      batches: List<String>.from(json['batches'] ?? []),
      minCgpa: (json['minCgpa'] ?? 0).toDouble(),
      maxBacklogs: json['maxBacklogs'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batches': batches,
      'minCgpa': minCgpa,
      'maxBacklogs': maxBacklogs,
    };
  }
}
