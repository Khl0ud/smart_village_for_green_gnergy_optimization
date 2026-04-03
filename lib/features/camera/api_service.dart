import 'dart:convert';
import 'package:http/http.dart' as http;

class CameraApiService {
  // 1. استبدلي 192.168.1.10 بـ IP جهازك الحقيقي (اكتبيه في الـ CMD عبر ipconfig)
  // 2. بورت الـ API في الـ .NET غالباً يكون 5000 أو 5123 (تأكدي منه)
  static const String serverIp = '192.168.1.10';
  final String baseUrl = 'http://$serverIp:5000/api/Surveillance';

  // رابط الصور أو الفيديوهات المسجلة (Static Files)
  final String mediaBaseUrl = 'http://$serverIp:5000/recordings';

  // جلب الكاميرات الأربعة
  Future<List<dynamic>> getCameras() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cameras'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load cameras: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }

  // جلب تسجيلات كاميرا معينة
  Future<List<dynamic>> getRecordings(int cameraId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recordings/$cameraId'));
      if (response.statusCode == 200) {
        List<dynamic> recordings = jsonDecode(response.body);

        // تعديل الـ URL لكل فيديو عشان يكون رابط كامل يقدر الـ Player يشغله
        return recordings.map((rec) {
          rec['fullFileUrl'] = '$mediaBaseUrl/cam$cameraId/${rec['fileUrl']}';
          return rec;
        }).toList();
      } else {
        throw Exception('Failed to load recordings');
      }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }
}