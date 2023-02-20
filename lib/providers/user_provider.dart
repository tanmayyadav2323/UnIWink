import 'package:buddy_go/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(id: '', phone: '', token: '', imageUrl: '');

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
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
