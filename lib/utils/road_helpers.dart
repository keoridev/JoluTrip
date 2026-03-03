import 'package:flutter/material.dart';

class RoadHelpers {
  static IconData getRoadNoteIcon(String note) {
    final lowerNote = note.toLowerCase();
    if (lowerNote.contains('грав') ||
        lowerNote.contains('грунт') ||
        lowerNote.contains('дорог')) {
      return Icons.terrain_outlined;
    } else if (lowerNote.contains('мост')) {
      return Icons.location_city_outlined;
    } else if (lowerNote.contains('тупик') ||
        lowerNote.contains('проезд') ||
        lowerNote.contains('поворот')) {
      return Icons.turn_left_outlined;
    } else if (lowerNote.contains('парк') || lowerNote.contains('стоянк')) {
      return Icons.local_parking_outlined;
    } else if (lowerNote.contains('вниман') || lowerNote.contains('опасн')) {
      return Icons.warning_amber_outlined;
    } else if (lowerNote.contains('вода') ||
        lowerNote.contains('река') ||
        lowerNote.contains('брод')) {
      return Icons.water_outlined;
    } else if (lowerNote.contains('лес')) {
      return Icons.park_outlined;
    } else {
      return Icons.arrow_forward_outlined;
    }
  }
}
