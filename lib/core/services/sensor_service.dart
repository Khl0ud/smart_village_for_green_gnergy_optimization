import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_constants.dart';

class SensorService {
  final http.Client client;

  SensorService({http.Client? client}) : client = client ?? http.Client();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // جلب آخر قراءة لكل الحساسات في المنطقة
  Future<List<dynamic>> getLatestReadings(int zoneId) async {
    final url = "${ApiConstants.sensorsLatest}/$zoneId";
    final token = await _getToken();
    if (token == null) return [];

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
      return [];
    } catch (e) {
      return [];
    }
  }

  // جلب تاريخ قراءات حساس معين للرسم البياني
  Future<List<dynamic>> getSensorHistory(int deviceId, {int hours = 24}) async {
    final url = "${ApiConstants.sensorsHistory}/$deviceId?hours=$hours";
    final token = await _getToken();
    if (token == null) return [];

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
      return [];
    } catch (e) {
      return [];
    }
  }

  // إرسال قراءة جديدة (يحاكي عمل ESP32)
  Future<bool> recordReading({
    required int deviceId,
    required int type,
    required double value,
  }) async {
    final url = ApiConstants.sensorsRecord;
    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "deviceId": deviceId,
          "type": type,
          "value": value,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
