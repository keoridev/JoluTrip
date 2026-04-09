import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingProvider extends ChangeNotifier {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Set<DateTime> _unavailableDates = {};
  final Set<DateTime> _loadingDates = {};

  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;
  Set<DateTime> get unavailableDates => _unavailableDates;
  Set<DateTime> get loadingDates => _loadingDates;

  void init() {
    _loadBookedDates();
  }

  void _loadBookedDates() {
    _loadingDates.addAll([
      DateTime(2026, 4, 10),
      DateTime(2026, 4, 11),
      DateTime(2026, 4, 15),
      DateTime(2026, 4, 20),
      DateTime(2026, 4, 21),
      DateTime(2026, 4, 22),
    ]);
    notifyListeners();
  }

  bool isDateAvailable(DateTime date) {
    return !_loadingDates.any((bookedDate) => isSameDay(bookedDate, date));
  }

  bool isDateInPast(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.isBefore(today);
  }

  void selectDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void markDateAsBooked(DateTime date) {
    _unavailableDates.add(date);
    notifyListeners();
  }

  void disposeProvider() {
    _focusedDay = DateTime.now();
    _selectedDay = null;
    _unavailableDates.clear();
    _loadingDates.clear();
  }
}
