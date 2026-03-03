import 'package:jolu_trip/data/models/coordinates.model.dart';

class LocationModel {
  final String id;
  final String name;
  final String description;
  final String videoUrl;
  final int price;
  final String carType;
  final int travelTime;
  final String difficult;
  final bool hasSignal;
  final int entryFee;
  final String category;
  final String thumbnailUrl;
  final List<String> availableGuides;
  final String longDescription;
  final List<String> gearList;
  final List<String> roadNotes;
  final Coordinates coordinates;
  final String peculiarity;

  LocationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.price,
    required this.carType,
    required this.travelTime,
    required this.difficult,
    required this.hasSignal,
    required this.category,
    required this.thumbnailUrl,
    required this.entryFee,
    required this.availableGuides,
    required this.longDescription,
    required this.gearList,
    required this.roadNotes,
    required this.coordinates,
    required this.peculiarity,
  });

  factory LocationModel.fromFirestore(String docId, Map<String, dynamic> data) {
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

    bool toBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is String) return v.toLowerCase() == 'true';
      return true;
    }

    List<String> parseAvailableGuides(dynamic value) {
      if (value == null) return [];
      if (value is String) {
        if (value.trim().isEmpty || value.toLowerCase() == 'нет гидов')
          return [];

        return value
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }

      if (value is List) {
        return List<String>.from(
            value.whereType<String>().where((e) => e.isNotEmpty));
      }

      return [];
    }

    String validateUrl(String url) {
      if (url.isEmpty) return '';

      if(!url.startsWith('http://') && !url.startsWith('https://')) {
        return '';
      }

      return url;
    }

    return LocationModel(
      id: docId,
      name: asString(data['name'], 'Без названия'),
      description: asString(data['description'], 'Без описания'),
      videoUrl: asString(data['video_url'], ''),
      price: asInt(data['price_per_car'], 8000),
      entryFee: asInt(data['entry_fee'], 0),
      carType: asString(data['car_type_required'], '4x4'),
      travelTime: asInt(data['travel_time'], 0),
      difficult: asString(data['difficulty'], 'нормально'),
      hasSignal: toBool(data['has_signal']),
      category: asString(data['category'], 'гора'),
      thumbnailUrl: asString(data['thumbnail_url'], ''),
      availableGuides: parseAvailableGuides(data['available_guides']),
      longDescription: asString(data['long_description'], ''),
      gearList: List<String>.from(data['gear_list'] ?? []),
      roadNotes: List<String>.from(data['road_notes'] ?? []),
      coordinates: Coordinates.fromList(data['coordinates'] ?? []),
      peculiarity: asString(data['peculiarity'], ''),
    );
  }
}
