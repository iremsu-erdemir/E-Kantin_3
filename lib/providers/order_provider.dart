import 'package:flutter/material.dart';
import '../models/siparis.dart';
import '../services/local_storage_service.dart';

class OrderProvider extends ChangeNotifier {
  List<Siparis> _orders = [];
  bool _isLoading = false;

  List<Siparis> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> loadOrders(String username) async {
    _isLoading = true;
    notifyListeners();
    _orders = await LocalStorageService.getUserOrders(username);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addOrder(String username, Siparis siparis) async {
    await LocalStorageService.addOrder(username, siparis);
    await loadOrders(username);
  }

  Future<void> markAsDelivered(String username, String orderId) async {
    await LocalStorageService.markAsDelivered(username, orderId);
    await loadOrders(username);
  }

  List<Siparis> filtered(String durum) =>
      _orders.where((s) => s.durum == durum).toList();

  void clear() {
    _orders = [];
    notifyListeners();
  }
}
