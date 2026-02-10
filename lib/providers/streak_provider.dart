import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StreakProvider extends ChangeNotifier {
  static const String _boxName = 'streak_data';
  static const String _currentStreakKey = 'current_streak';
  static const String _longestStreakKey = 'longest_streak';
  static const String _lastPracticeDateKey = 'last_practice_date';
  static const String _totalPracticeDaysKey = 'total_practice_days';

  late Box _streakBox;

  int _currentStreak = 0;
  int _longestStreak = 0;
  int _totalPracticeDays = 0;
  String? _lastPracticeDate;
  bool _practicedToday = false;

  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  int get totalPracticeDays => _totalPracticeDays;
  bool get practicedToday => _practicedToday;

  String get motivationalMessage {
    if (_currentStreak == 0) {
      return 'Comece hoje sua sequência!';
    } else if (_currentStreak == 1) {
      return 'Ótimo começo! Continue amanhã!';
    } else if (_currentStreak < 4) {
      return 'Continue assim! 💪';
    } else if (_currentStreak < 7) {
      return 'Você está voando! 🚀';
    } else if (_currentStreak < 14) {
      return 'Uma semana incrível! 🌟';
    } else if (_currentStreak < 30) {
      return 'Impressionante! 🏆';
    } else {
      return 'Você é imparável! 👑';
    }
  }

  Future<void> loadStreak() async {
    _streakBox = await Hive.openBox(_boxName);

    _currentStreak = _streakBox.get(_currentStreakKey, defaultValue: 0);
    _longestStreak = _streakBox.get(_longestStreakKey, defaultValue: 0);
    _totalPracticeDays = _streakBox.get(_totalPracticeDaysKey, defaultValue: 0);
    _lastPracticeDate = _streakBox.get(_lastPracticeDateKey);

    // Check if streak was broken (missed a day)
    _checkStreakContinuity();

    notifyListeners();
  }

  void _checkStreakContinuity() {
    if (_lastPracticeDate == null) return;

    final today = _todayString();
    final lastDate = DateTime.parse(_lastPracticeDate!);
    final todayDate = DateTime.parse(today);
    final difference = todayDate.difference(lastDate).inDays;

    _practicedToday = difference == 0;

    // If more than 1 day has passed, streak is broken
    if (difference > 1) {
      _currentStreak = 0;
      _streakBox.put(_currentStreakKey, _currentStreak);
    }
  }

  Future<void> recordPractice() async {
    final today = _todayString();

    // Already practiced today, nothing to update
    if (_lastPracticeDate == today) return;

    if (_lastPracticeDate == null) {
      // First time ever
      _currentStreak = 1;
    } else {
      final lastDate = DateTime.parse(_lastPracticeDate!);
      final todayDate = DateTime.parse(today);
      final difference = todayDate.difference(lastDate).inDays;

      if (difference == 1) {
        // Consecutive day — extend streak!
        _currentStreak += 1;
      } else if (difference > 1) {
        // Missed a day — reset streak
        _currentStreak = 1;
      }
      // difference == 0 is already handled above
    }

    // Update longest streak
    if (_currentStreak > _longestStreak) {
      _longestStreak = _currentStreak;
    }

    _totalPracticeDays += 1;
    _lastPracticeDate = today;
    _practicedToday = true;

    // Persist
    await _streakBox.put(_currentStreakKey, _currentStreak);
    await _streakBox.put(_longestStreakKey, _longestStreak);
    await _streakBox.put(_totalPracticeDaysKey, _totalPracticeDays);
    await _streakBox.put(_lastPracticeDateKey, _lastPracticeDate);

    notifyListeners();
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
