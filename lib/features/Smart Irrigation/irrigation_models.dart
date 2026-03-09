// نموذج بيانات الزون
class IrrigationZone {
  final String id;
  final String name;
  final double soilMoisture;
  final bool valveOpen;
  final DateTime? lastIrrigation;
  
  IrrigationZone({
    required this.id,
    required this.name,
    required this.soilMoisture,
    required this.valveOpen,
    this.lastIrrigation,
  });
}

// نموذج نوع النبات
class PlantType {
  final String name;
  final String icon;
  final double optimalMoisture;
  final double optimalTemp;
  final String bestTime;
  final int weeklyFrequency;
  final String season;
  
  PlantType({
    required this.name,
    required this.icon,
    required this.optimalMoisture,
    required this.optimalTemp,
    required this.bestTime,
    required this.weeklyFrequency,
    required this.season,
  });
}

// نموذج سجل الري
class IrrigationLog {
  final DateTime timestamp;
  final String zoneId;
  final Duration duration;
  final double tempBefore;
  final double moistureBefore;
  final double moistureAfter;
  final bool isManual;
  
  IrrigationLog({
    required this.timestamp,
    required this.zoneId,
    required this.duration,
    required this.tempBefore,
    required this.moistureBefore,
    required this.moistureAfter,
    required this.isManual,
  });
}

// أنواع النباتات المتاحة
class PlantDatabase {
  static final List<PlantType> plants = [
    // خضروات
    PlantType(
      name: 'Tomato',
      icon: '🍅',
      optimalMoisture: 65.0,
      optimalTemp: 24.0,
      bestTime: 'Early Morning',
      weeklyFrequency: 4,
      season: 'Spring/Summer',
    ),
    PlantType(
      name: 'Lettuce',
      icon: '🥬',
      optimalMoisture: 70.0,
      optimalTemp: 18.0,
      bestTime: 'Morning',
      weeklyFrequency: 5,
      season: 'Spring/Fall',
    ),
    PlantType(
      name: 'Cucumber',
      icon: '🥒',
      optimalMoisture: 68.0,
      optimalTemp: 22.0,
      bestTime: 'Early Morning',
      weeklyFrequency: 4,
      season: 'Summer',
    ),
    PlantType(
      name: 'Pepper',
      icon: '🌶️',
      optimalMoisture: 60.0,
      optimalTemp: 26.0,
      bestTime: 'Morning',
      weeklyFrequency: 3,
      season: 'Summer',
    ),
    
    // أعشاب
    PlantType(
      name: 'Herbs',
      icon: '🌿',
      optimalMoisture: 55.0,
      optimalTemp: 20.0,
      bestTime: 'Morning',
      weeklyFrequency: 3,
      season: 'All Year',
    ),
    
    // ورود وزهور
    PlantType(
      name: 'Roses',
      icon: '🌹',
      optimalMoisture: 60.0,
      optimalTemp: 22.0,
      bestTime: 'Early Morning',
      weeklyFrequency: 4,
      season: 'Spring/Summer',
    ),
    PlantType(
      name: 'Sunflower',
      icon: '🌻',
      optimalMoisture: 58.0,
      optimalTemp: 25.0,
      bestTime: 'Morning',
      weeklyFrequency: 3,
      season: 'Summer',
    ),
    PlantType(
      name: 'Tulips',
      icon: '🌷',
      optimalMoisture: 62.0,
      optimalTemp: 18.0,
      bestTime: 'Morning',
      weeklyFrequency: 3,
      season: 'Spring',
    ),
    PlantType(
      name: 'Hibiscus',
      icon: '🌺',
      optimalMoisture: 65.0,
      optimalTemp: 26.0,
      bestTime: 'Morning',
      weeklyFrequency: 4,
      season: 'Summer',
    ),
    
    // نجيلة
    PlantType(
      name: 'Grass Lawn',
      icon: '🌱',
      optimalMoisture: 55.0,
      optimalTemp: 20.0,
      bestTime: 'Early Morning',
      weeklyFrequency: 5,
      season: 'All Year',
    ),
    
    // أشجار فاكهة
    PlantType(
      name: 'Orange Tree',
      icon: '🍊',
      optimalMoisture: 50.0,
      optimalTemp: 24.0,
      bestTime: 'Morning',
      weeklyFrequency: 2,
      season: 'All Year',
    ),
    PlantType(
      name: 'Lemon Tree',
      icon: '🍋',
      optimalMoisture: 50.0,
      optimalTemp: 23.0,
      bestTime: 'Morning',
      weeklyFrequency: 2,
      season: 'All Year',
    ),
    PlantType(
      name: 'Apple Tree',
      icon: '🍎',
      optimalMoisture: 48.0,
      optimalTemp: 20.0,
      bestTime: 'Morning',
      weeklyFrequency: 2,
      season: 'Spring/Fall',
    ),
    PlantType(
      name: 'Olive Tree',
      icon: '🫒',
      optimalMoisture: 40.0,
      optimalTemp: 25.0,
      bestTime: 'Morning',
      weeklyFrequency: 1,
      season: 'All Year',
    ),
    
    // أشجار زينة
    PlantType(
      name: 'Palm Tree',
      icon: '🌴',
      optimalMoisture: 45.0,
      optimalTemp: 28.0,
      bestTime: 'Morning',
      weeklyFrequency: 2,
      season: 'All Year',
    ),
    PlantType(
      name: 'Pine Tree',
      icon: '🌲',
      optimalMoisture: 42.0,
      optimalTemp: 18.0,
      bestTime: 'Morning',
      weeklyFrequency: 2,
      season: 'All Year',
    ),
    PlantType(
      name: 'Deciduous Tree',
      icon: '🌳',
      optimalMoisture: 45.0,
      optimalTemp: 20.0,
      bestTime: 'Morning',
      weeklyFrequency: 2,
      season: 'Spring/Fall',
    ),
    
    // نباتات صبار
    PlantType(
      name: 'Cactus',
      icon: '🌵',
      optimalMoisture: 30.0,
      optimalTemp: 28.0,
      bestTime: 'Morning',
      weeklyFrequency: 1,
      season: 'All Year',
    ),
  ];
}

