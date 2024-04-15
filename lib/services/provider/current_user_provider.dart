import 'package:flutter/foundation.dart';
import 'package:quizletapp/models/user.dart';

class CurrentUserProvider extends ChangeNotifier {
  UserModel? _currentUser = null;

  UserModel? get currentUser => _currentUser;

  set setCurrentUser (UserModel newCurrentUser) {
    _currentUser = newCurrentUser;
    notifyListeners();
  }

  bool get isNotEmpty => _currentUser != null;
}