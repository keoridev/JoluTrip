import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';

class LocationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<LocationModel>> getLocations() {
    return _firestore.collection('locations').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) {
            final data = doc.data();

            return data.isNotEmpty &&
                data['video_url'] != null &&
                data['video_url'].toString().isNotEmpty;
          })
          .map((doc) {
            try {
              return LocationModel.fromFirestore(doc.id, doc.data());
            } catch (e) {
              debugPrint('⚠️ Пропускаем документ ${doc.id}: $e');
              return null;
            }
          })
          .whereType<LocationModel>()
          .toList();
    });
  }

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
