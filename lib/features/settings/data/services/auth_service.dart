import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api_constants.dart';
import '../models/auth_models.dart';

class AuthService {
  final http.Client client;

  AuthService({http.Client? client}) : client = client ?? http.Client();

  // دالة تسجيل الدخول - بتبعت البيانات للـ API وتستقبل الرد
  Future<AuthResponse> login(LoginRequest request) async {
    final url = ApiConstants.loginEndpoint;
    final body = jsonEncode(request.toJson());

    print('--- [AUTH REQUEST] ---');
    print('URL: $url');
    print('Body: $body');

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('--- [AUTH RESPONSE] ---');
      print('Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);
      final authResponse = AuthResponse.fromJson(data);

      // لو الدنيا تمام ومعانا توكن، بنسيفه عندنا
      if (authResponse.isAuthenticated && authResponse.token != null) {
        await _saveToken(authResponse.token!);
      }

      return authResponse;
    } catch (e) {
      print('--- [AUTH ERROR] ---');
      print('Error detail: $e');
      return AuthResponse(
        isAuthenticated: false,
        message: 'حصلت مشكلة في الاتصال: $e',
      );
    }
  }

  // دالة إنشاء حساب جديد - بتبعت البيانات وترجع الرد
  Future<AuthResponse> register(RegisterRequest request) async {
    final url = ApiConstants.registerEndpoint;
    final body = jsonEncode(request.toJson());

    print('--- [REGISTER REQUEST] ---');
    print('URL: $url');
    print('Body: $body');

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('--- [REGISTER RESPONSE] ---');
      print('Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);
      final authResponse = AuthResponse.fromJson(data);

      if (authResponse.isAuthenticated && authResponse.token != null) {
        await _saveToken(authResponse.token!);
      }

      return authResponse;
    } catch (e) {
      print('--- [REGISTER ERROR] ---');
      print('Error detail: $e');
      return AuthResponse(
        isAuthenticated: false,
        message: 'حصلت مشكلة في الاتصال: $e',
      );
    }
  }

  // بنسيف التوكن في الموبايل عشان يفضل معانا
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // بنجيب التوكن اللي متسيف
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // دالة جلب بيانات البروفايل
  Future<Map<String, dynamic>?> getProfile() async {
    final url = ApiConstants.profileEndpoint;
    final token = await getToken();

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
      print('Error fetching profile: $e');
      return null;
    }
  }

  // دالة تغيير كلمة المرور
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    final url = ApiConstants.changePasswordEndpoint;
    final token = await getToken();

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
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error changing password: $e');
      return false;
    }
  }

  // دالة تحديث بيانات البروفايل
  Future<bool> updateProfile(String fullName, String phoneNumber) async {
    final url = ApiConstants.updateProfileEndpoint;
    final token = await getToken();

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
          "fullName": fullName,
          "phoneNumber": phoneNumber,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // دالة جلب الإشعارات
  Future<List<dynamic>> getNotifications() async {
    final url = ApiConstants.notificationsEndpoint;
    final token = await getToken();

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
      print('Error fetching notifications: $e');
      return [];
    }
  }

  // دالة تمييز الإشعار كمقروء
  Future<bool> markNotificationAsRead(String notificationId) async {
    final url = "${ApiConstants.notificationsEndpoint}/$notificationId/read";
    final token = await getToken();

    if (token == null) return false;

    try {
      final response = await client.put(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  // دالة تمييز كل الإشعارات كمقروءة
  Future<bool> markAllNotificationsAsRead() async {
    final url = "${ApiConstants.notificationsEndpoint}/mark-all-read";
    final token = await getToken();

    if (token == null) return false;

    try {
      final response = await client.put(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return false;
    }
  }

  // بنمسح التوكن لما اليوزر يعمل خروج




  Future<void> logout() async {
    final url = ApiConstants.logoutEndpoint;
    final token = await getToken();

    if (token != null) {
      try {
        await client.post(
          Uri.parse(url),
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
          },
          body: '',
        );
      } catch (e) {
        print('Error calling logout on server: $e');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

}
