class ApiConstants {
  // 💡 غيري هذه القيمة فقط:
  // true = يشتغل على السيرفر المحلي (الكمبيوتر بتاعك)
  // false = يشتغل على الاستضافة الأونلاين (runasp.net)
  static const bool useLocal =false;

// 🏠 إعدادات السيرفر المحلي (Local)
  static const String localIp = '192.168.1.58'; // تأكدي من أن الـ IP لم يتغير
  static const String localBaseUrl = 'http://$localIp:5248/api'; // 💡 تم التعديل هنا إلى 5248
  static const String localMediaUrl = 'http://$localIp:5248/recordings'; // هذا البورت صحيح
  static const String localLiveUrl = 'http://$localIp:8888';

  // 🌐 إعدادات الاستضافة الأونلاين (Hosted)
  static const String hostedDomain = 'smartvillageapi.runasp.net';
  static const String hostedBaseUrl = 'http://$hostedDomain/api';
  static const String hostedMediaUrl = 'http://$hostedDomain/recordings';
  static const String hostedLiveUrl = 'http://$hostedDomain:8888';
  // 🚀 الإعدادات النشطة (تتغير تلقائياً بناءً على useLocal)
  static const String baseUrl = useLocal ? localBaseUrl : hostedBaseUrl;
  static const String mediaBaseUrl = useLocal ? localMediaUrl : hostedMediaUrl;
  static const String liveStreamBaseUrl = useLocal ? localLiveUrl : hostedLiveUrl;
  
  static const String loginEndpoint = '$baseUrl/Auth/login';
  static const String registerEndpoint = '$baseUrl/Auth/register';
  static const String profileEndpoint = '$baseUrl/Auth/profile';
  static const String changePasswordEndpoint = '$baseUrl/Auth/change-password';
  static const String logoutEndpoint = '$baseUrl/Auth/logout';
  static const String updateProfileEndpoint = '$baseUrl/Auth/update-profile';
  static const String notificationsEndpoint = '$baseUrl/Notifications';
  static const String chatConversationsEndpoint = '$baseUrl/Chat/conversations';
  static const String chatUsersEndpoint = '$baseUrl/Chat/users';
  static const String chatHistoryEndpoint = '$baseUrl/Chat/history';
  static const String chatSendEndpoint = '$baseUrl/Chat/send';
  static const String chatMarkReadEndpoint = '$baseUrl/Chat/mark-as-read';

  // Parking Endpoints
  static const String parkingMyBookings = '$baseUrl/Parking/MyBookings';
  static const String parkingReserve = '$baseUrl/Parking/Reserve';
  static const String parkingDashboard = '$baseUrl/Parking/Dashboard';
  static const String parkingFindMyCar = '$baseUrl/Parking/FindMyCar';
  static const String parkingWalletAddFunds = '$baseUrl/Parking/Wallet/AddFunds';

  // Waste Management Endpoints
  static const String wasteDashboard = '$baseUrl/Waste/Dashboard';
  static const String wasteSchedulePickup = '$baseUrl/Waste/SchedulePickup';

  // Sensor Endpoints
  static const String sensorsRecord = '$baseUrl/Sensors/Record';
  static const String sensorsLatest = '$baseUrl/Sensors/Latest';
  static const String sensorsHistory = '$baseUrl/Sensors/History';

  // Device Endpoints
  static const String devicesByZone = '$baseUrl/Devices/ByZone';
  static const String devicesControl = '$baseUrl/Devices/Control';
  static const String devicesAutoRegister = '$baseUrl/Devices/AutoRegister';
  static const String devicesControlBulk = '$baseUrl/Devices/ControlBulk';

  // Camera Endpoints
  static const String cameraBase = '$baseUrl/Camera';
  static const String cameraSyncRecordings = '$baseUrl/Camera/sync-recordings';

  // Automation Endpoints
  static const String automationBase = '$baseUrl/Automation';
  static const String automationUpdateFarmingSettings = '$baseUrl/Automation/UpdateFarmingSettings';
  static const String automationToggleGasProtection = '$baseUrl/Automation/ToggleGasProtection';

}




















