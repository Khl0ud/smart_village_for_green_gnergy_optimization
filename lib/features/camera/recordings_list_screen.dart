import 'package:flutter/material.dart';
import 'api_service.dart'; // تأكدي أن الملف بنفس الاسم في مشروعك
import 'video_player_screen.dart';

class RecordingsListScreen extends StatefulWidget {
  final int cameraId;
  final String cameraName;

  const RecordingsListScreen({super.key, required this.cameraId, required this.cameraName});

  @override
  State<RecordingsListScreen> createState() => _RecordingsListScreenState();
}

class _RecordingsListScreenState extends State<RecordingsListScreen> {
  final CameraApiService api = CameraApiService();
  late Future<List<dynamic>> recordingsFuture;

  @override
  void initState() {
    super.initState();
    // طلب قائمة التسجيلات من الـ API للكاميرا المحددة
    recordingsFuture = api.getRecordings(widget.cameraId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سجلات: ${widget.cameraName}'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: recordingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ في تحميل البيانات: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد تسجيلات متاحة لهذه الكاميرا حالياً'));
          }

          final recordings = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: recordings.length,
            itemBuilder: (context, index) {
              final rec = recordings[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.video_library, color: Colors.blue),
                  title: Text('تسجيل رقم ${rec['id']}'),
                  subtitle: Text('وقت التسجيل: ${rec['recordedAt']}'),
                  trailing: const Icon(Icons.play_arrow, color: Colors.green),
                  onTap: () {
                    // الانتقال لصفحة المشغل لتشغيل الفيديو المختار
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(
                          url: rec['fullFileUrl'], // الرابط الكامل للفيديو
                          title: "عرض تسجيل ${widget.cameraName}",
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}