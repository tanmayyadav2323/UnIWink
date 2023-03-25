import 'dart:developer';

import 'package:buddy_go/models/user_model.dart';
import 'package:flutter/cupertino.dart';

import '../config/session_helper.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
      id: '',
      phone: '',
      token: '',
      imageUrl: '',
      gender: '',
      des: '',
      winks: []);

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    SessionHelper.id = _user.id;
    SessionHelper.phone = _user.phone;
    SessionHelper.imageUrl = _user.imageUrl;
    SessionHelper.gender = _user.gender;
    SessionHelper.des = _user.des;
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  User getUser() {
    return _user;
  }
}
