import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';


import 'ChatScreen.dart';
import 'data/services/chat_service.dart';
import 'UsersListScreen.dart';

class NeighborsPage extends StatefulWidget {

  const NeighborsPage({super.key});

  @override
  _NeighborsPageState createState() => _NeighborsPageState();
}

class _NeighborsPageState extends State<NeighborsPage> {
  final ChatService _chatService = ChatService();
  bool _isLoading = true;
  List<dynamic> neighbors = [];
  List<dynamic> archivedNeighbors = [];
  String searchQuery = "";
  Timer? _pollingTimer;


  @override
  void initState() {
    super.initState();
    _loadInitialData();
    // بدء التحديث اللحظي للقائمة كل 5 ثواني
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) => _fetchConversations());
  }

  @override
  void dispose() {
    _pollingTimer?.cancel(); // إيقاف التحديث عند مغادرة الصفحة
    super.dispose();
  }


  Future<void> _loadInitialData() async {
    // عرض الكاش أولاً للسرعة
    final cached = await _chatService.getCachedConversations();
    if (cached.isNotEmpty && mounted) {
      setState(() {
        neighbors = cached;
        _isLoading = false;
      });
    }
    // ثم التحديث من السيرفر
    _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    print("Updating conversations list from server...");
    final data = await _chatService.getConversations();
    if (mounted) {
      setState(() {
        neighbors = data;
        _isLoading = false;
      });
    }
  }



  // دالة التعامل مع الأكشنز (حذف، أرشفة، تثبيت)
  void _handleAction(String action, dynamic chat) {

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
        .where((neighbor) => (neighbor["otherUserName"] ?? "").toString().toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // فرز المحادثات: المثبت أولاً ثم حسب الرسائل غير المقروءة
    filteredNeighbors.sort((a, b) {
      if ((a["pinned"] ?? false) && !(b["pinned"] ?? false)) return -1;
      if (!(a["pinned"] ?? false) && (b["pinned"] ?? false)) return 1;
      return (b["unreadCount"] ?? 0).compareTo(a["unreadCount"] ?? 0);
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
                  child: _isLoading && neighbors.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
                    : RefreshIndicator(
                        onRefresh: _fetchConversations,
                        color: AppColors.primaryNeon,
                        backgroundColor: AppColors.cardBg,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          children: [
                            if (archivedNeighbors.isNotEmpty) _buildArchivedSection(),
                            if (filteredNeighbors.isEmpty)
                              const Center(child: Padding(
                                padding: EdgeInsets.only(top: 100),
                                child: Text("No conversations found", style: TextStyle(color: AppColors.textGrey)),
                              ))
                            else
                              ...filteredNeighbors.map((neighbor) => _buildChatTile(neighbor)).toList(),
                            const SizedBox(height: 100), // مساحة للـ FAB
                          ],
                        ),
                      ),
                ),


              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UsersListScreen()),
          );
        },
        backgroundColor: AppColors.primaryNeon,
        child: const Icon(Icons.people_outline_rounded, color: AppColors.textDark),
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

  Widget _buildChatTile(dynamic neighbor, {bool isArchived = false}) {
    final name = neighbor["otherUserFullName"] ?? neighbor["otherUserName"] ?? neighbor["fullName"] ?? "User";

    final lastMsg = neighbor["lastMessage"] ?? "No messages yet";
    
    return GestureDetector(
      onLongPress: () => _showOptions(neighbor),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBg.withOpacity(neighbor["pinned"] == true ? 0.4 : 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: neighbor["pinned"] == true ? AppColors.primaryNeon.withOpacity(0.3) : AppColors.cardBorder),
        ),
        child: ListTile(
          leading: _buildAvatar(neighbor),
          title: Text(name, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
          trailing: _buildTrailing(neighbor, isArchived),
          onTap: () async {

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  chatName: name,
                  userId: (neighbor["otherUserId"] ?? neighbor["userId"] ?? "").toString(),
                ),

              ),
            );
            // تحديث القائمة عند العودة من الشات لرؤية آخر رسالة
            _fetchConversations();
          },

        ),
      ),
    );
  }


  Widget _buildAvatar(dynamic neighbor) {
    final name = neighbor["otherUserFullName"] ?? neighbor["otherUserName"] ?? neighbor["fullName"] ?? "User";

    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primaryNeon.withOpacity(0.1),
          radius: 28,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : "?",
            style: const TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
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



  Widget _buildTrailing(dynamic neighbor, bool isArchived) {
    final timeStr = neighbor["lastMessageTime"] != null 
        ? neighbor["lastMessageTime"].toString().substring(11, 16) 
        : "";
    final unreadCount = neighbor["unreadCount"] ?? 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(timeStr, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        const SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (neighbor["pinned"] == true) const Icon(Icons.push_pin, size: 14, color: AppColors.primaryNeon),
            if (unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(left: 5),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: AppColors.primaryNeon, shape: BoxShape.circle),
                child: Text("$unreadCount", style: const TextStyle(color: AppColors.textDark, fontSize: 10, fontWeight: FontWeight.bold)),
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