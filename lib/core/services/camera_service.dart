import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_constants.dart';

class CameraService {
  final http.Client client;

  CameraService({http.Client? client}) : client = client ?? http.Client();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // جلب جميع الكاميرات
  Future<List<dynamic>> getAllCameras() async {
    final url = ApiConstants.cameraBase;
    final token = await _getToken();
    if (token == null) return [];

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'accept': 'text/plain',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
      return [];
    } catch (e) {
      return [];
    }
  }

  // جلب كاميرا معينة حسب المعرف
  Future<Map<String, dynamic>?> getCameraById(String id) async {
    final url = "${ApiConstants.cameraBase}/$id";
    final token = await _getToken();
    if (token == null) return null;

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'accept': 'text/plain',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
      return null;
    } catch (e) {
      return null;
    }
  }

  // إضافة كاميرا جديدة
  Future<bool> addCamera(Map<String, dynamic> cameraData) async {
    final url = ApiConstants.cameraBase;
    final token = await _getToken();
    if (token == null) return false;

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'accept': 'text/plain',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(cameraData),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // مزامنة التسجيلات
  Future<bool> syncRecordings() async {
    final url = ApiConstants.cameraSyncRecordings;
    final token = await _getToken();
    if (token == null) return false;

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
        body: '', 
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // جلب تسجيلات كاميرا معينة
  Future<List<dynamic>> getRecordings(String cameraId) async {
    final url = "${ApiConstants.cameraBase}/Recordings/$cameraId";
    final token = await _getToken();
    if (token == null) return [];

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'accept': 'text/plain',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
      return [];
    } catch (e) {
      return [];
    }
  }
}
