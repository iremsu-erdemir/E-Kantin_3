import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/local_storage_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoaded = false;

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  Future<void> loadNotifications(String username) async {
    debugPrint('NotificationProvider: loadNotifications çağrıldı ($username)');
    _notifications = await LocalStorageService.getUserNotifications(username);
    _isLoaded = true;
    debugPrint('NotificationProvider: notifyListeners (bildirimler yüklendi)');
    notifyListeners();
  }

  Future<void> addNotification(
    String username,
    NotificationModel notification,
  ) async {
    debugPrint(
      'NotificationProvider: addNotification çağrıldı: ${notification.title}',
    );
    await LocalStorageService.addNotification(username, notification);
    await loadNotifications(username);
  }

  void clear() {
    _notifications = [];
    notifyListeners();
  }
}
