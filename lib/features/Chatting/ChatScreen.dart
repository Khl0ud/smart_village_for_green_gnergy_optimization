import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';

class ChatPage extends StatefulWidget {
  final String chatName;

  const ChatPage({super.key, required this.chatName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> messages = [
    {"text": "Hello!", "isMe": false, "time": "10:30 AM"},
    {"text": "Hi, how are you?", "isMe": true, "time": "10:31 AM"},
    {"text": "I’m good, thanks!", "isMe": false, "time": "10:32 AM"},
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      messages.add({"text": _controller.text.trim(), "isMe": true, "time": "Now"});
      _controller.clear();
    });
    // التمرير التلقائي لآخر رسالة
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // استخدام الخلفية الموحدة
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textLight, size: 20),
          onPressed: () => Navigator.pop(context), // العودة للشاشة السابقة
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=5"),
              radius: 18,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chatName, style: const TextStyle(fontSize: 16, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                const Text("online", style: TextStyle(fontSize: 11, color: AppColors.primaryNeon)), // حالة الأونلاين بالنيون
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.mainGradient, // التدرج الرسمي
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(15),
                itemCount: messages.length,
                itemBuilder: (context, index) => _buildMessageBubble(messages[index]),
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    bool isMe = msg["isMe"];
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          // نيون للرسائل الخاصة وشفافية للرسائل المستلمة
          color: isMe ? AppColors.primaryNeon.withValues(alpha: 0.2) : AppColors.cardBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(20),
          ),
          border: Border.all(color: isMe ? AppColors.primaryNeon.withValues(alpha: 0.3) : AppColors.cardBorder),
        ),
        child: Text(msg["text"], style: const TextStyle(color: AppColors.textLight, fontSize: 15)),
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2)),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryNeon), onPressed: () {}),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColors.cardBg.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: AppColors.textLight),
                  decoration: const InputDecoration(hintText: "Type a message...", hintStyle: TextStyle(color: AppColors.textGrey), border: InputBorder.none),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.primaryNeon,
              child: IconButton(icon: const Icon(Icons.send_rounded, color: AppColors.textDark, size: 20), onPressed: _sendMessage),
            ),
          ],
        ),
      ),
    );
  }
}