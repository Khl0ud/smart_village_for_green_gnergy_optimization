import 'package:flutter/material.dart';
// استيراد ملف الألوان المركزي لضمان توحيد الهوية البصرية
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
// استيراد صفحة الشات التفصيلية
import 'ChatScreen.dart';

class NeighborsPage extends StatefulWidget {
  const NeighborsPage({super.key});

  @override
  _NeighborsPageState createState() => _NeighborsPageState();
}

class _NeighborsPageState extends State<NeighborsPage> {
  // قائمة الجيران النشطة
  List<Map<String, dynamic>> neighbors = [
    {
      "name": "Rawan",
      "avatar": "https://i.pravatar.cc/150?u=rawan",
      "lastMessage": "Hey, how are you?",
      "time": "10:30 AM",
      "unread": 2,
      "online": true,
      "pinned": false,
    },
    {
      "name": "Ahmed",
      "avatar": "https://i.pravatar.cc/150?u=ahmed",
      "lastMessage": "The smart pump is working fine!",
      "time": "10:30 AM",
      "unread": 1,
      "online": true,
      "pinned": false,
    },
  ];

  List<Map<String, dynamic>> archivedNeighbors = [];
  String searchQuery = "";

  // دالة التعامل مع الأكشنز (حذف، أرشفة، تثبيت)
  void _handleAction(String action, Map<String, dynamic> chat) {
    setState(() {
      if (action == "delete") {
        neighbors.remove(chat);
      } else if (action == "archive") {
        neighbors.remove(chat);
        archivedNeighbors.add(chat);
      } else if (action == "pin") {
        chat["pinned"] = !(chat["pinned"] ?? false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // تصفية القائمة بناءً على البحث
    final filteredNeighbors = neighbors
        .where((neighbor) => neighbor["name"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // فرز المحادثات: المثبت أولاً ثم حسب الرسائل غير المقروءة
    filteredNeighbors.sort((a, b) {
      if ((a["pinned"] ?? false) && !(b["pinned"] ?? false)) return -1;
      if (!(a["pinned"] ?? false) && (b["pinned"] ?? false)) return 1;
      return (b["unread"] ?? 0).compareTo(a["unread"] ?? 0);
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text("Neighbors Chat", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, color: AppColors.textLight), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          SafeArea(
            child: Column(
              children: [
                _buildSearchBar(),
                // استخدام ListView واحد لمنع الـ Overflow
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: [
                      if (archivedNeighbors.isNotEmpty) _buildArchivedSection(),
                      ...filteredNeighbors.map((neighbor) => _buildChatTile(neighbor)).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryNeon,
        child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.textDark),
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.mainGradient,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value),
        style: const TextStyle(color: AppColors.textLight),
        decoration: InputDecoration(
          hintText: "Search your neighbors...",
          hintStyle: const TextStyle(color: AppColors.textGrey),
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryNeon),
          filled: true,
          fillColor: AppColors.cardBg.withValues(alpha: 0.3),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildArchivedSection() {
    return ExpansionTile(
      title: const Text("Archived Chats", style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold)),
      iconColor: AppColors.primaryNeon,
      collapsedIconColor: AppColors.textGrey,
      children: archivedNeighbors.map((chat) => _buildChatTile(chat, isArchived: true)).toList(),
    );
  }

  Widget _buildChatTile(Map<String, dynamic> neighbor, {bool isArchived = false}) {
    return GestureDetector(
      onLongPress: () => _showOptions(neighbor),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: neighbor["pinned"] == true ? 0.4 : 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: neighbor["pinned"] == true ? AppColors.primaryNeon.withValues(alpha: 0.3) : AppColors.cardBorder),
        ),
        child: ListTile(
          leading: _buildAvatar(neighbor),
          title: Text(neighbor["name"], style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
          subtitle: Text(neighbor["lastMessage"], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textGrey)),
          trailing: _buildTrailing(neighbor, isArchived),
          onTap: () {
            // تفعيل الانتقال لصفحة الشات الملونة
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(chatName: neighbor["name"]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> neighbor) {
    return Stack(
      children: [
        CircleAvatar(backgroundImage: NetworkImage(neighbor["avatar"]), radius: 28),
        if (neighbor["online"] == true)
          Positioned(
            bottom: 2, right: 2,
            child: Container(
              width: 12, height: 12,
              decoration: BoxDecoration(color: AppColors.primaryNeon, shape: BoxShape.circle, border: Border.all(color: AppColors.scaffoldBg, width: 2)),
            ),
          ),
      ],
    );
  }

  Widget _buildTrailing(Map<String, dynamic> neighbor, bool isArchived) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(neighbor["time"], style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        const SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (neighbor["pinned"] == true) const Icon(Icons.push_pin, size: 14, color: AppColors.primaryNeon),
            if ((neighbor["unread"] ?? 0) > 0)
              Container(
                margin: const EdgeInsets.only(left: 5),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: AppColors.primaryNeon, shape: BoxShape.circle),
                child: Text("${neighbor["unread"]}", style: const TextStyle(color: AppColors.textDark, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            if (isArchived)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.unarchive, color: AppColors.primaryNeon, size: 20),
                onPressed: () => setState(() { archivedNeighbors.remove(neighbor); neighbors.add(neighbor); }),
              ),
          ],
        ),
      ],
    );
  }

  void _showOptions(Map<String, dynamic> neighbor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            _optionTile(Icons.push_pin, neighbor["pinned"] == true ? "Unpin Chat" : "Pin Chat", () => _handleAction("pin", neighbor)),
            _optionTile(Icons.archive, "Archive Chat", () => _handleAction("archive", neighbor)),
            _optionTile(Icons.delete, "Delete Chat", () => _handleAction("delete", neighbor), isDanger: true),
          ],
        ),
      ),
    );
  }

  Widget _optionTile(IconData icon, String title, VoidCallback tap, {bool isDanger = false}) {
    return ListTile(
      leading: Icon(icon, color: isDanger ? AppColors.danger : AppColors.primaryNeon),
      title: Text(title, style: TextStyle(color: isDanger ? AppColors.danger : AppColors.textLight)),
      onTap: () { Navigator.pop(context); tap(); },
    );
  }
}