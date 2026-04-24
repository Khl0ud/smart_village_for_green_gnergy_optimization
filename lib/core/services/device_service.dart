import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_constants.dart';

class DeviceService {
  final http.Client client;

  DeviceService({http.Client? client}) : client = client ?? http.Client();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // جلب كل أجهزة منطقة معينة
  Future<List<dynamic>> getDevicesByZone(int zoneId) async {
    final token = await _getToken();
    if (token == null) return [];
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.devicesByZone}/$zoneId'),
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
      return [];
    } catch (e) {
      return [];
    }
  }

  // التحكم بجهاز واحد (ON/OFF)
  Future<bool> controlDevice(int deviceId, String command) async {
    final token = await _getToken();
    if (token == null) return false;
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.devicesControl),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'deviceId': deviceId, 'command': command}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // التحكم بمجموعة أجهزة من نفس النوع دفعة واحدة
  Future<bool> controlBulk(int zoneId, String deviceType, String command) async {
    final token = await _getToken();
    if (token == null) return false;
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.devicesControlBulk),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'zoneId': zoneId,
          'deviceType': deviceType,
          'command': command,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
