import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_village_for_green_gnergy_optimization/core/api_constants.dart';

class CameraApiService {
  final String baseUrl = '${ApiConstants.baseUrl}/Surveillance';

  // رابط الصور أو الفيديوهات المسجلة (Static Files)
  final String mediaBaseUrl = ApiConstants.mediaBaseUrl;


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