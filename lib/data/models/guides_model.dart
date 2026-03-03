class GuidesModel {
  final String name;
  final String avatarUrl;
  final String car;
  final String carPhoto;
  final int priceService;
  final int whatsapp;
  final double rating;
  final String helloVideo;

  GuidesModel(
      {required this.name,
      required this.avatarUrl,
      required this.car,
      required this.carPhoto,
      required this.priceService,
      required this.whatsapp,
      required this.rating,
      required this.helloVideo});

  factory GuidesModel.fromFirestore(String docId, Map<String, dynamic> data) {
    String asString(dynamic v, String defaultValue) {
      if (v == null) return defaultValue;
      return v.toString().isEmpty ? defaultValue : v.toString();
    }

    int asInt(dynamic v, int defaultValue) {
      if (v == null) return defaultValue;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? defaultValue;
      return defaultValue;
    }

    double asDouble(dynamic v, double defaultValue) {
      if (v == null) return defaultValue;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? defaultValue;
      return defaultValue;
    }

    return GuidesModel(
        name: asString(data['name'], 'Без имени'),
        avatarUrl:
            asString(data['avatar_url'], 'assets/images/default-user.jpg'),
        car: asString(data['car_name'], 'не указано'),
        carPhoto: asString(data['car_url'], ''),
        priceService: asInt(data['price_service'], 0),
        whatsapp: asInt(data['whatsapp'], 0),
        rating: asDouble(data['rating'], 0.0),
        helloVideo: asString(data['hello_video'], 'Гид не загружал видео '));
  }
}
