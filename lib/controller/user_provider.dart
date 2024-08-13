import 'package:flutter/foundation.dart';
import 'package:instagram/auth/auth_methods.dart';
import 'package:instagram/modal/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;
  UserModel? get getUser => _userModel!;

  Future<void> refreshUser({String? userUid}) async {
    UserModel user = await AuthMethods().getUserDetails(userUid);
    _userModel = user;
    notifyListeners();
  }
}
