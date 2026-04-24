import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api_constants.dart';

class ParkingService {
  final http.Client client;

  ParkingService({http.Client? client}) : client = client ?? http.Client();

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

  // جلب حجوزاتي
  Future<List<dynamic>> getMyBookings() async {
    final url = ApiConstants.parkingMyBookings;
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
      if (response.statusCode == 200) return jsonDecode(response.body);
      return [];
    } catch (e) {
      return [];
    }
  }

  // حجز باركينج جديد
  Future<bool> reserveParking({
    required String deviceId,
    required String plateNumber,
    required String startTime,
    required String endTime,
  }) async {
    final url = ApiConstants.parkingReserve;
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
          "deviceId": int.tryParse(deviceId) ?? 0,
          "plateNumber": plateNumber,
          "startTime": startTime,
          "endTime": endTime,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // جلب بيانات لوحة التحكم (الرصيد والحالة)
  Future<Map<String, dynamic>?> getDashboard(int zoneId) async {
    final url = "${ApiConstants.parkingDashboard}/$zoneId";
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

  // البحث عن مكاني سيارتي
  Future<Map<String, dynamic>?> findMyCar(String deviceId) async {
    final url = "${ApiConstants.parkingFindMyCar}/$deviceId";
    final token = await _getToken();
    if (token == null) return null;

    try {
      final response = await client.post(
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

  // شحن المحفظة
  Future<bool> addFunds(double amount) async {
    final url = ApiConstants.parkingWalletAddFunds;
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
        body: jsonEncode(amount), // السيرفر قد يتوقع الرقم مباشرة أو كائن
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
