class RestPoint {
  final String name;
  final String type;
  final String specialty;
  final String avgCheck;
  final String image;
  final List<String> features;

  RestPoint({
    required this.name,
    required this.type,
    required this.specialty,
    required this.avgCheck,
    required this.image,
    required this.features,
  });

  factory RestPoint.fromMap(Map<String, dynamic> map) {
    String asString(dynamic v, String defaultValue) {
      if (v == null) return defaultValue;
      return v.toString().isEmpty ? defaultValue : v.toString();
    }

    return RestPoint(
      name: asString(map['name'], ''),
      type: asString(map['type'], ''),
      specialty: asString(map['specialty'], ''),
      avgCheck: asString(map['avg_check'], ''),
      image: asString(map['image'], ''),
      features: List<String>.from(map['features'] ?? []),
    );
  }

  static List<RestPoint> fromList(dynamic value) {
    if (value == null || value is! List) return [];
    return value
        .map((item) => RestPoint.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
