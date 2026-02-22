import 'package:flutter/material.dart';
import 'dart:ui';
// استيراد ملف الألوان المركزي من مجلد core لضمان الربط المعماري
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class ChatPage extends StatefulWidget {
  final String chatName;

  const ChatPage({super.key, required this.chatName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // استخدام الألوان الموحدة من ملف AppColors المعتمد لمشروعك
  static const Color mainBg = AppColors.scaffoldBg;
  static const Color cardBg = AppColors.cardBg;
  static const Color primaryNeon = AppColors.primaryNeon;

  final List<Map<String, dynamic>> messages = [
    {"text": "Hello! How is the Smart Village project? 🌿", "isMe": false},
    {"text": "Hi! It's going great, just finished the Chat UI.", "isMe": true},
    {"text": "Awesome! The neon green theme looks cool. 🚀", "isMe": false},
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      messages.add({"text": _controller.text.trim(), "isMe": true});
      _controller.clear();
    });
    // التمرير التلقائي لآخر رسالة بأسلوب انسيابي
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBg,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // الخلفية المتدرجة الموحدة
          _buildBackgroundGradient(),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 120, 16, 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _buildChatBubble(msg["text"], msg["isMe"]);
                  },
                ),
              ),
              _buildMessageInput(),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: cardBg.withOpacity(0.5)),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: cardBg,
            backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/147/147144.png"),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.chatName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text("online now", style: TextStyle(fontSize: 10, color: primaryNeon, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.scaffoldBg, Color(0xFF1B2B23)],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          // فقاعات نيون للمرسل وزجاجية للمستلم
          color: isMe ? primaryNeon : cardBg.withOpacity(0.6),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(22),
            topRight: const Radius.circular(22),
            bottomLeft: Radius.circular(isMe ? 22 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 22),
          ),
          boxShadow: isMe ? [BoxShadow(color: primaryNeon.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))] : [],
          border: isMe ? null : Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? Colors.black : Colors.white,
            fontSize: 15,
            fontWeight: isMe ? FontWeight.w900 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: cardBg.withOpacity(0.6),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded, color: primaryNeon),
                  onPressed: () => _showAttachmentOptions(context),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Type something...",
                      hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: primaryNeon, shape: BoxShape.circle),
                    child: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _attachmentTile(Icons.insert_drive_file_rounded, "Send Document"),
              _attachmentTile(Icons.camera_alt_rounded, "Take Photo"),
              _attachmentTile(Icons.image_rounded, "From Gallery"),
              _attachmentTile(Icons.location_on_rounded, "Share Location"),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attachmentTile(IconData icon, String label) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: primaryNeon.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: primaryNeon, size: 20),
      ),
      title: Text(label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
      onTap: () => Navigator.pop(context),
    );
  }
}
