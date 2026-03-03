class Coordinates {
  final double latitude;
  final double longitude;
  final String label;

  Coordinates({
    required this.latitude,
    required this.longitude,
    required this.label,
  });

  factory Coordinates.fromList(List? list) {
    if (list == null || list.length < 2) {
      return Coordinates(
        latitude: 0.0,
        longitude: 0.0,
        label: '',
      );
    }
    return Coordinates(
      latitude: (list[0] as num).toDouble(),
      longitude: (list[1] as num).toDouble(),
      label: list.length > 2 ? list[2].toString() : '',
    );
  }
}
