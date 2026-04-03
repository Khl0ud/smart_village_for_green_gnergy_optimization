import 'package:flutter/material.dart';
import '../api_service.dart';
import 'live_screen.dart';

class CamerasScreen extends StatefulWidget {
  @override
  _CamerasScreenState createState() => _CamerasScreenState();
}

class _CamerasScreenState extends State<CamerasScreen> {
  final ApiService api = ApiService();
  late Future<List<dynamic>> cameras;

  @override
  void initState() {
    super.initState();
    // نداء الـ API لجلب الـ 4 كاميرات من الداتابيز
    cameras = api.getCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Village Surveillance'),
        centerTitle: true,
        elevation: 2,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: cameras,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.green));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;

            // استخدام GridView لعرض الـ 4 كاميرات بشكل احترافي
            return GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // كاميرتين في كل صف
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1, // تناسب حجم المربع
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final cam = data[index];
                return GestureDetector(
                  onTap: () {
                    // الانتقال لصفحة البث المباشر مع تمرير الرابط والاسم
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveScreen(
                          url: cam['streamUrl'],
                          cameraName: cam['name'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // أيقونة تعبيرية للكاميرا
                        Icon(Icons.videocam, size: 40, color: Colors.blueGrey),
                        SizedBox(height: 10),
                        Text(
                          cam['name'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          cam['location'],
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Tap to View Live",
                            style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: Text('No cameras found'));
        },
      ),
    );
  }
}