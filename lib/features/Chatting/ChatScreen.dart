import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';


import 'data/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String chatName;
  final String userId;

  const ChatPage({super.key, required this.chatName, required this.userId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  bool _isLoading = true;
  List<dynamic> messages = [];
  Timer? _pollingTimer;
  String? currentUserId;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();



  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    currentUserId = await _chatService.getCurrentUserId();
    print("My User ID: $currentUserId");
    await _fetchHistory();
    // بدء التحديث اللحظي كل 3 ثواني
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) => _fetchHistory());
  }


  @override
  void dispose() {
    _pollingTimer?.cancel(); // إيقاف التحديث عند الخروج من الصفحة
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchHistory() async {
    print("Fetching chat history for user: ${widget.userId}...");
    final data = await _chatService.getChatHistory(widget.userId);
    if (mounted) {
      if (data.length != messages.length) {
        print("New messages received! Count: ${data.length}");
        setState(() {
          messages = data;
          _isLoading = false;
        });
        _scrollToBottom();
      }
      // تمييز الرسائل كمقروءة
      _chatService.markChatAsRead(widget.userId);
    }
  }



  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }


  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // إضافة الرسالة محلياً فوراً لتجربة مستخدم سريعة
    setState(() {
      messages.add({
        "message": text,
        "isMe": true,
        "isRead": false, // حالة القراءة المبدئية (صح واحدة)
        "timestamp": DateTime.now().toString(),
      });
      _controller.clear();
    });

    
    _scrollToBottom();

    // إرسال الرسالة للسيرفر
    print("Sending message to ${widget.userId}: $text");
    final success = await _chatService.sendMessage(widget.userId, text);
    
    if (success) {
      print("Message sent successfully!");
      _fetchHistory();
    } else {
      print("Failed to send message!");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send message")),
        );
      }
    }
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
            CircleAvatar(
              backgroundColor: AppColors.primaryNeon.withOpacity(0.1),
              radius: 18,
              child: Text(
                widget.chatName.isNotEmpty ? widget.chatName[0].toUpperCase() : "?",
                style: const TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),

            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chatName, style: const TextStyle(fontSize: 16, color: AppColors.textLight, fontWeight: FontWeight.bold)),
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
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
                : ListView.builder(
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

  Widget _buildMessageBubble(dynamic msg) {
    // تحديد صاحب الرسالة بمقارنة الـ ID الخاص بك مع الـ senderId الخاص بالرسالة
    bool isMe = (msg["senderId"] != null && currentUserId != null) 
        ? msg["senderId"].toString() == currentUserId 
        : (msg["isMe"] ?? msg["isSender"] ?? false);
    
    String text = msg["message"] ?? msg["text"] ?? "";
    bool isRead = msg["isRead"] ?? false;


    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryNeon.withValues(alpha: 0.2) : AppColors.cardBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(20),
          ),
          border: Border.all(color: isMe ? AppColors.primaryNeon.withValues(alpha: 0.3) : AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(text, style: const TextStyle(color: AppColors.textLight, fontSize: 15)),
            if (isMe) ...[
              const SizedBox(height: 4),
              Icon(
                isRead ? Icons.done_all_rounded : Icons.check_rounded, 
                size: 14, 
                color: isRead ? AppColors.primaryNeon : AppColors.textGrey
              ),
            ]
          ],
        ),
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