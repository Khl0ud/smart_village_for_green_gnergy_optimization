import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/api_constants.dart';
import 'irrigation_models.dart';

class IrrigationService {
  static final List<IrrigationLog> _logs = [];

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // الحصول على السجلات (حالياً محلية، ولكن يمكن توسيعها لتجلب من السيرفر إذا وجد EndPoint)
  static List<IrrigationLog> getLogs() => List.from(_logs);

  static void logIrrigation(IrrigationLog log) {
    _logs.add(log);
  }

  // جلب إعدادات الزراعة التلقائية من السيرفر
  static Future<Map<String, dynamic>?> getFarmingSettings() async {
    final token = await _getToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.automationBase}/FarmingSettings'),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error fetching farming settings: $e');
    }
    return null;
  }

  // تحديث إعدادات الزراعة في السيرفر
  static Future<bool> updateFarmingSettings({
    required bool autoIrrigation,
    required double minMoisture,
    required double maxMoisture,
    required String irrigationStartTime,
    required String irrigationEndTime,
  }) async {
    final token = await _getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.automationUpdateFarmingSettings),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'autoIrrigation': autoIrrigation,
          'minMoisture': minMoisture,
          'maxMoisture': maxMoisture,
          'irrigationStartTime': irrigationStartTime,
          'irrigationEndTime': irrigationEndTime,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating farming settings: $e');
      return false;
    }
  }

  // حساب Eco Score بناءً على البيانات
  static double calculateEcoScore() {
    if (_logs.isEmpty) return 85.0; // قيمة افتراضية جيدة للبدء
    
    final avgDuration = _logs.map((l) => l.duration.inMinutes).reduce((a, b) => a + b) / _logs.length;
    final traditionalDuration = 30.0;
    final savings = ((traditionalDuration - avgDuration) / traditionalDuration * 100).clamp(0.0, 100.0);
    
    return savings.toDouble();
  }

  // فحص ما قبل الري
  static Map<String, dynamic> preIrrigationCheck({
    required double temperature,
    required double currentMoisture,
    required bool isRaining,
    required int waterLevel,
    required DateTime? lastIrrigation,
  }) {
    final checks = <String, bool>{};
    final warnings = <String>[];
    
    checks['temperature'] = temperature >= 15 && temperature <= 40;
    if (!checks['temperature']!) warnings.add('Temperature is extremely high or low');
    
    checks['moisture'] = currentMoisture < 80;
    if (!checks['moisture']!) warnings.add('Soil is already very wet');
    
    checks['rain'] = !isRaining;
    if (!checks['rain']!) warnings.add('Rain detected - irrigation paused');
    
    checks['waterLevel'] = waterLevel > 15;
    if (!checks['waterLevel']!) warnings.add('Water tank level is very low');
    
    if (lastIrrigation != null) {
      final minsSinceLast = DateTime.now().difference(lastIrrigation).inMinutes;
      checks['timing'] = minsSinceLast >= 30; // السماح بالري كل 30 دقيقة للاختبار
      if (!checks['timing']!) warnings.add('Last irrigation was only $minsSinceLast mins ago');
    } else {
      checks['timing'] = true;
    }
    
    final allPassed = checks.values.every((v) => v);
    
    return {
      'passed': allPassed,
      'checks': checks,
      'warnings': warnings,
    };
  }

  // توصيات AI
  static String getAIRecommendation({
    required double moisture,
    required double temperature,
    required int hour,
    required bool isRaining,
  }) {
    if (isRaining) return 'Rain detected. System in water-saving mode.';
    if (moisture > 75) return 'Soil moisture is optimal. No action needed.';
    if (moisture < 35) return 'Soil is dry! Starting irrigation is highly recommended.';
    if (temperature > 35) return 'High temperature. Evaporation is fast, monitor moisture.';
    
    return 'Conditions are stable. Next scheduled check in 1 hour.';
  }
}
