import 'irrigation_models.dart';

class IrrigationService {
  static final List<IrrigationLog> _logs = [];
  
  // حفظ سجل الري
  static void logIrrigation(IrrigationLog log) {
    _logs.add(log);
  }
  
  // الحصول على السجلات
  static List<IrrigationLog> getLogs() => List.from(_logs);
  
  // حساب Eco Score
  static double calculateEcoScore() {
    if (_logs.isEmpty) return 0.0;
    
    // حساب متوسط مدة الري
    final avgDuration = _logs.map((l) => l.duration.inMinutes).reduce((a, b) => a + b) / _logs.length;
    
    // الري التقليدي يستخدم 30 دقيقة في المتوسط
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
    
    // فحص درجة الحرارة
    checks['temperature'] = temperature >= 15 && temperature <= 35;
    if (!checks['temperature']!) {
      warnings.add('Temperature out of optimal range');
    }
    
    // فحص الرطوبة
    checks['moisture'] = currentMoisture < 60;
    if (!checks['moisture']!) {
      warnings.add('Soil moisture already sufficient');
    }
    
    // فحص المطر
    checks['rain'] = !isRaining;
    if (!checks['rain']!) {
      warnings.add('Rain detected - irrigation not needed');
    }
    
    // فحص مستوى المياه
    checks['waterLevel'] = waterLevel > 20;
    if (!checks['waterLevel']!) {
      warnings.add('Water level too low');
    }
    
    // فحص آخر مرة ري
    if (lastIrrigation != null) {
      final hoursSinceLastIrrigation = DateTime.now().difference(lastIrrigation).inHours;
      checks['timing'] = hoursSinceLastIrrigation >= 12;
      if (!checks['timing']!) {
        warnings.add('Last irrigation was ${hoursSinceLastIrrigation}h ago');
      }
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
    if (isRaining) {
      return 'Rain detected. Skip irrigation to save water.';
    }
    
    if (moisture > 70) {
      return 'Soil moisture is high. No irrigation needed.';
    }
    
    if (moisture < 40) {
      if (hour >= 6 && hour <= 10) {
        return 'Critical moisture level! Irrigate now (optimal time).';
      } else {
        return 'Critical moisture! Consider immediate irrigation.';
      }
    }
    
    if (temperature > 30) {
      return 'High temperature detected. Consider evening irrigation.';
    }
    
    if (hour >= 6 && hour <= 10) {
      return 'Optimal time for irrigation. Moisture level acceptable.';
    }
    
    return 'Monitor soil moisture. Next irrigation recommended in morning.';
  }
}
