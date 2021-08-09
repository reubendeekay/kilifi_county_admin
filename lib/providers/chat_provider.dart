import 'package:flutter/foundation.dart';

class ChatModel {
  final String userId;
  final String imageUrl;
  final String fullName;
  final String username;
  final String nationalId;
  final String phonenumber;
  final bool isVerified;
  final String email;
  final String subCounty;

  ChatModel(
      {this.userId,
      this.imageUrl,
      this.fullName,
      this.username,
      this.nationalId,
      this.phonenumber,
      this.isVerified,
      this.email,
      this.subCounty});
}

class ChatProvider with ChangeNotifier {
  ChatModel chat;

  void getChat(ChatModel userChat) {
    chat = userChat;
    notifyListeners();
  }
}
