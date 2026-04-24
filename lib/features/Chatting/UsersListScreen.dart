import 'package:flutter/material.dart';
import 'package:smart_village_for_green_gnergy_optimization/core/theme/app_colors.dart';
import 'ChatScreen.dart';
import 'data/services/chat_service.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final ChatService _chatService = ChatService();
  bool _isLoading = true;
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final data = await _chatService.getUsers();
    if (mounted) {
      setState(() {
        _users = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text("Select User", style: TextStyle(color: AppColors.textLight)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon))
          : _users.isEmpty
              ? const Center(child: Text("No users found", style: TextStyle(color: AppColors.textGrey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    final name = user["fullName"] ?? user["userName"] ?? "Unknown";
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryNeon.withOpacity(0.1),
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : "?",
                            style: const TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(name, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
                        subtitle: Text(user["email"] ?? "", style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                chatName: name,
                                userId: user["id"].toString(),
                              ),
                            ),
                          );
                        },

                      ),
                    );
                  },
                ),
    );
  }
}
