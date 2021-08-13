import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  final String fullName;
  final String username;
  final String imageUrl;
  final String email;
  final String userId;
  final String phoneNumber;
  final String subCounty;
  final String nationalId;
  final bool isVerified;
  final bool isAdmin;
  final String office;

  UserModel(
      {this.email,
      this.fullName,
      this.office,
      this.imageUrl,
      this.userId,
      this.username,
      this.isVerified,
      this.isAdmin,
      this.nationalId,
      this.phoneNumber,
      this.subCounty});
}

class UsersProvider with ChangeNotifier {
  UserModel user;

  void getUser(UserModel userModel) {
    user = userModel;
    notifyListeners();
  }
}
