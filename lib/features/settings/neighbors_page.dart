import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class NeighborsPage extends StatefulWidget {
  const NeighborsPage({super.key});

  @override
  State<NeighborsPage> createState() => _NeighborsPageState();
}

class _NeighborsPageState extends State<NeighborsPage> {
  // استخدام الألوان الموحدة من ملف AppColors
  static const Color mainBg = AppColors.scaffoldBg;
  static const Color cardBg = AppColors.cardBg;
  static const Color primaryNeon = AppColors.primaryNeon;

  List<Map<String, dynamic>> neighbors = [
    {
      "name": "Rawan",
      "avatar": "https://cdn-icons-png.flaticon.com/512/147/147144.png",
      "lastMessage": "The solar panel status looks great!",
      "time": "10:30 AM",
      "unread": 2,
      "online": true,
      "pinned": false,
    },
    {
      "name": "Samaa",
      "avatar": "https://cdn-icons-png.flaticon.com/512/147/147144.png",
      "lastMessage": "Did you check the irrigation schedule?",
      "time": "09:15 AM",
      "unread": 0,
      "online": false,
      "pinned": true,
    },
  ];

  List<Map<String, dynamic>> archivedNeighbors = [];
  String searchQuery = "";

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
    final filteredNeighbors = neighbors
        .where((n) => n["name"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // ترتيب ذكي: المثبت أولاً ثم غير المقروء
    filteredNeighbors.sort((a, b) {
      if ((a["pinned"] ?? false) && !(b["pinned"] ?? false)) return -1;
      if (!(a["pinned"] ?? false) && (b["pinned"] ?? false)) return 1;
      return (b["unread"] ?? 0).compareTo(a["unread"] ?? 0);
    });

    return Scaffold(
      backgroundColor: mainBg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Community Chats",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // الخلفية المتدرجة الموحدة
          _buildBackgroundGradient(),
          
          SafeArea(
            child: Column(
              children: [
                _buildSearchBar(),
                if (archivedNeighbors.isNotEmpty) _buildArchivedTile(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredNeighbors.length,
                    itemBuilder: (context, index) {
                      final chat = filteredNeighbors[index];
                      return _buildChatTile(chat);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryNeon,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add_comment_rounded, color: Colors.black),
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.scaffoldBg, AppColors.cardBg],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              onChanged: (v) => setState(() => searchQuery = v),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search for neighbors...",
                hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: primaryNeon, size: 22),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatTile(Map<String, dynamic> chat) {
    return Dismissible(
      key: Key(chat["name"]),
      background: _buildSwipeBackground(Icons.archive_rounded, primaryNeon, Alignment.centerLeft),
      secondaryBackground: _buildSwipeBackground(Icons.delete_rounded, Colors.redAccent, Alignment.centerRight),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) _handleAction("archive", chat);
        else _handleAction("delete", chat);
      },
      child: GestureDetector(
        onLongPress: () => _showChatOptions(chat),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: cardBg.withOpacity(0.3),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: _buildAvatar(chat),
            title: Text(
              chat["name"],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                chat["lastMessage"],
                style: const TextStyle(color: Colors.white54, fontSize: 13),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: _buildTrailingInfo(chat),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(name: chat["name"])));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> chat) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: chat["pinned"] ? primaryNeon : Colors.transparent, width: 2),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: cardBg,
            backgroundImage: NetworkImage(chat["avatar"]),
          ),
        ),
        if (chat["online"] == true)
          Positioned(
            bottom: 2, right: 2,
            child: Container(
              width: 14, height: 14,
              decoration: BoxDecoration(
                color: primaryNeon,
                shape: BoxShape.circle,
                border: Border.all(color: mainBg, width: 2.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTrailingInfo(Map<String, dynamic> chat) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(chat["time"], style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (chat["pinned"]) const Icon(Icons.push_pin_rounded, size: 14, color: primaryNeon),
            if (chat["unread"] > 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: primaryNeon, borderRadius: BorderRadius.circular(10)),
                child: Text("${chat["unread"]}", style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwipeBackground(IconData icon, Color color, Alignment alignment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 12),
      alignment: alignment,
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(25)),
      child: Icon(icon, color: color),
    );
  }

  void _showChatOptions(Map<String, dynamic> chat) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOption(Icons.push_pin_rounded, chat["pinned"] ? "Unpin Chat" : "Pin Chat", primaryNeon, () => _handleAction("pin", chat)),
              _buildOption(Icons.archive_outlined, "Archive Chat", Colors.white, () => _handleAction("archive", chat)),
              _buildOption(Icons.delete_outline_rounded, "Delete Conversation", Colors.redAccent, () => _handleAction("delete", chat)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      onTap: () { Navigator.pop(context); onTap(); },
    );
  }

  Widget _buildArchivedTile() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          const Icon(Icons.archive_rounded, color: primaryNeon, size: 20),
          const SizedBox(width: 12),
          const Text("Archived Messages", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: cardBg, shape: BoxShape.circle),
            child: Text("${archivedNeighbors.length}", style: const TextStyle(color: primaryNeon, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
