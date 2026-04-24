import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api_constants.dart';

class WasteService {
  final http.Client client;

  WasteService({http.Client? client}) : client = client ?? http.Client();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // فك تشفير التوكن لمعرفة الـ ID الخاص بالمستخدم الحالي
  Future<String?> getCurrentUserId() async {
    final token = await _getToken();
    if (token == null) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final Map<String, dynamic> data = jsonDecode(payload);
      return data['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ?? data['nameid'] ?? data['sub'];
    } catch (e) {
      return null;
    }
  }

  // جلب بيانات لوحة التحكم (مستوى الامتلاء والصناديق)
  Future<Map<String, dynamic>?> getDashboard(int zoneId) async {
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
      if (response.statusCode == 200) return jsonDecode(response.body);
      return null;
    } catch (e) {
      return null;
    }
  }

  // جدولة جمع النفايات
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
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
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
