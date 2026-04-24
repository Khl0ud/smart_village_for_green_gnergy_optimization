import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_constants.dart';

class WasteService {
  final http.Client client;

  WasteService({http.Client? client}) : client = client ?? http.Client();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // جلب إحصائيات النفايات وتفاصيل السلات بناءً على رقم المنطقة
  Future<Map<String, dynamic>?> getWasteDashboard(int zoneId) async {
    final url = "${ApiConstants.wasteDashboard}/$zoneId";
    final token = await _getToken();
    if (token == null) return null;

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // جدولة طلب تجميع النفايات
  Future<bool> schedulePickup({
    required int binId,
    required String scheduledDateTime,
  }) async {
    final url = ApiConstants.wasteSchedulePickup;
    final token = await _getToken();
    if (token == null) return false;

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "binId": binId,
          "scheduledDateTime": scheduledDateTime,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
