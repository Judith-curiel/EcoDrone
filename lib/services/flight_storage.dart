import 'package:shared_preferences/shared_preferences.dart';

class FlightStorage {
  static const _prefix = 'flight_progress_';

  static Future<int> loadCollectedCount(String flightId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_prefix$flightId') ?? 0;
  }

  static Future<void> saveCollectedCount(String flightId, int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_prefix$flightId', count);
  }

  static Future<Map<String, int>> loadAllCollectedCounts(
    List<String> flightIds,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final result = <String, int>{};
    for (final id in flightIds) {
      result[id] = prefs.getInt('$_prefix$id') ?? 0;
    }
    return result;
  }
}
