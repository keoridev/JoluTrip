import 'dart:async';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/data/models/guides_model.dart';
import 'package:jolu_trip/data/repositories/guides_repository.dart';
import 'package:jolu_trip/data/repositories/location.repository.dart';

class LocationGuidesService {
  final GuidesRepository _guidesRepository = GuidesRepository();

  Future<List<GuidesModel>> getGuidesForLocation(LocationModel location) async {
    return await _guidesRepository.getGuidesByIds(location.availableGuides);
  }

  Stream<List<GuidesModel>> getGuidesStreamForLocation(LocationModel location) {
    return _guidesRepository.getGuidesStreamByIds(location.availableGuides);
  }

  Future<Map<String, dynamic>> getLocationWithGuides(String locationId) async {
    final locationRepo = LocationRepository();

    final location = await locationRepo.getLocationById(locationId);
    if (location == null) return {};

    final guides = await getGuidesForLocation(location);

    return {
      'locations': location,
      'guides': guides,
    };
  }

  // Получить поток: локация + её гиды (для экрана деталей)
  Stream<Map<String, dynamic>> getLocationWithGuidesStream(String locationId) {
    final locationRepo = LocationRepository();

    return locationRepo
        .getLocationById(locationId)
        .asStream()
        .asyncExpand((location) {
      if (location == null) return Stream.value({});
      return getGuidesStreamForLocation(location).map((guides) {
        return {
          'locations': location,
          'guides': guides,
        };
      });
    });
  }
}
