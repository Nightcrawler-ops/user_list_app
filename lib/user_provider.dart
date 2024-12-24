import 'package:flutter/material.dart';
import 'user_service.dart';
import 'user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  List<User> _users = [];
  bool _loading = false;
  String _errorMessage = '';

  List<User> get users => _users;
  bool get loading => _loading;
  String get errorMessage => _errorMessage;

  Future<void> fetchUsers() async {
    _loading = true;
    notifyListeners();

    try {
      _users = await _userService.fetchUsers();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load users';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
