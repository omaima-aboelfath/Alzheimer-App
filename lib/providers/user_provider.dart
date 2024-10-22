import 'package:flutter/material.dart';
import 'package:graduation_app/model/user_data.dart';

class UserProvider extends ChangeNotifier {
  MyUser? currentUser;

  // if i change the current account, update the current user
  void updateUser(MyUser newUser) {
    currentUser = newUser;
    notifyListeners();
  }
}
