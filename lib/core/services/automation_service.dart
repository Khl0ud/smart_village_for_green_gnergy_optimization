import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_constants.dart';

class AutomationService {
  final http.Client client;

  AutomationService({http.Client? client}) : client = client ?? http.Client();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // جلب إعدادات الأتمتة لمنطقة معينة
  Future<Map<String, dynamic>?> getAutomationSettings(String zoneId) async {
    final url = "${ApiConstants.automationBase}/$zoneId";
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

  // تحديث إعدادات الزراعة (الري)
  Future<bool> updateFarmingSettings(String zoneId, bool isAutoMode, double moistureThreshold) async {
    final url = "${ApiConstants.automationUpdateFarmingSettings}/$zoneId";
    final token = await _getToken();
    if (token == null) return false;

    try {
      final response = await client.put(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "isAutoMode": isAutoMode,
          "moistureThreshold": moistureThreshold
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // تحديث حالة زرار حماية الغاز
  Future<bool> toggleGasProtection(String zoneId, bool isEnabled) async {
    final url = "${ApiConstants.automationToggleGasProtection}/$zoneId";
    final token = await _getToken();
    if (token == null) return false;

    try {
      final response = await client.put(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(isEnabled),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

