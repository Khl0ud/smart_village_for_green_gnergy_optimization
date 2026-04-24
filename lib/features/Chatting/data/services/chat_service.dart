import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api_constants.dart';

class ChatService {
  final http.Client client;

  ChatService({http.Client? client}) : client = client ?? http.Client();

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
      // المعرف غالباً يكون في حقل 'nameid' أو 'sub' حسب إعدادات السيرفر
      return data['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ?? data['nameid'] ?? data['sub'];
    } catch (e) {
      print("Error decoding token: $e");
      return null;
    }
  }


  // جلب المحادثات مع الحفظ المحلي للسرعة
  Future<List<dynamic>> getConversations() async {
    final url = ApiConstants.chatConversationsEndpoint;
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
        final data = jsonDecode(response.body);
        await _saveConversationsLocally(data);
        return data;
      }
      return await getCachedConversations();
    } catch (e) {
      return await getCachedConversations();
    }
  }

  Future<void> _saveConversationsLocally(List<dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_conversations', jsonEncode(data));
  }

  Future<List<dynamic>> getCachedConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('cached_conversations');
    if (cached != null) {
      return jsonDecode(cached);
    }
    return [];
  }

  // جلب كل المستخدمين لبدء شات جديد
  Future<List<dynamic>> getUsers() async {
    final url = ApiConstants.chatUsersEndpoint;
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

  // جلب تاريخ المحادثة مع مستخدم معين
  Future<List<dynamic>> getChatHistory(String userId) async {
    final url = "${ApiConstants.chatHistoryEndpoint}/$userId";
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

  // إرسال رسالة جديدة
  Future<bool> sendMessage(String receiverId, String message) async {
    final url = ApiConstants.chatSendEndpoint;
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
          "receiverId": receiverId,
          "message": message,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // تمييز المحادثة كمقروءة
  Future<bool> markChatAsRead(String userId) async {
    final url = "${ApiConstants.chatMarkReadEndpoint}/$userId";
    final token = await _getToken();

    if (token == null) return false;

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
