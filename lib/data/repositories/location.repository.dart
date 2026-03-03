import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';

class LocationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Получить все локации
  Stream<List<LocationModel>> getLocations() {
    return _firestore.collection('locations').snapshots().map((snapshot) =>
        snapshot
            .docs
            .map((doc) => LocationModel.fromFirestore(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Получить одну локацию по ID
  Future<LocationModel?> getLocationById(String locationId) async {
    try {
      final doc =
          await _firestore.collection('locations').doc(locationId).get();
      if (doc.exists) {
        return LocationModel.fromFirestore(
            doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Ошибка получения локации: $e');
      return null;
    }
  }
}
