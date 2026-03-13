import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:jolu_trip/data/models/guides_model.dart';

class GuidesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<GuidesModel?> getGuideById(String guideId) async {
    try {
      final doc = await _firestore.collection('guides').doc(guideId).get();

      if (doc.exists) {
        return GuidesModel.fromFirestore(
            doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Ошибка при получение гидов: $e');
      return null;
    }
  }

  Future<List<GuidesModel>> getGuidesByIds(List<String> guideIds) async {
    if (guideIds.isEmpty) return [];

    if (guideIds.length > 10) {
      final batches = [];
      for (var i = 0; i < guideIds.length; i += 10) {
        final end = (i + 10 < guideIds.length) ? i + 10 : guideIds.length;
        batches.add(guideIds.sublist(i, end));
      }

      final results =
          await Future.wait(batches.map((batch) => _getGuidesBatch(batch)));

      return results.expand((list) => list).toList();
    }

    try {
      final querySnapshot = await _firestore
          .collection('guides')
          .where(FieldPath.documentId, whereIn: guideIds)
          .get();

      return querySnapshot.docs
          .map((doc) => GuidesModel.fromFirestore(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Ошибка при получение гидов: $e');
      return [];
    }
  }

  Future<List<GuidesModel>> _getGuidesBatch(List<String> batchIds) async {
    try {
      final querySnapshot = await _firestore
          .collection('guides')
          .where(FieldPath.documentId, whereIn: batchIds)
          .get();

      return querySnapshot.docs
          .map((doc) => GuidesModel.fromFirestore(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Ошибка при получение гидов: $e');
      return [];
    }
  }

  Stream<List<GuidesModel>> getGuidesStreamByIds(List<String> guideIds) {
    if (guideIds.isEmpty) return Stream.value([]);

    return _firestore
        .collection('guides')
        .where(FieldPath.documentId, whereIn: guideIds)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GuidesModel.fromFirestore(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<GuidesModel>> getAllGuides() {
    return _firestore.collection('guides').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => GuidesModel.fromFirestore(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}
