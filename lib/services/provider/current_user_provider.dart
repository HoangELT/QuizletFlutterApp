import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:quizletapp/models/user.dart';
import 'package:quizletapp/services/firebase_auth.dart';
import 'package:quizletapp/services/models_services/user_service.dart';

class CurrentUserProvider extends ChangeNotifier {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  UserService userService = UserService();
  UserModel? _currentUser = null;

  UserModel? get currentUser => _currentUser;

  set setCurrentUser(UserModel? newCurrentUser) {
    _currentUser = newCurrentUser;
    notifyListeners();
  }

  Future<void> initCurrentUse() async {
    if (firebaseAuthService.getCurrentUser() == null) {
      _currentUser = null;
      notifyListeners();
      return;
    }
    _currentUser = await userService
        .getUserByUid(firebaseAuthService.getCurrentUser()!.uid);
    notifyListeners();
  }

  bool get isNotEmpty => _currentUser != null;
}
