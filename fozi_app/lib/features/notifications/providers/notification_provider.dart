import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {

  final List<String> _notifications = [];

  List<String> get notifications => _notifications;

  int get count => _notifications.length;

  void addNotification(String message) {
    _notifications.insert(0, message); // newest on top
    notifyListeners();
  }

  void removeNotification(int index) {
    _notifications.removeAt(index);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
