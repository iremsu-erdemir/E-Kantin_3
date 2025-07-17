import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/siparis.dart';
import '../models/borc.dart';
import '../models/notification.dart';
import 'package:flutter/foundation.dart';

class LocalStorageService {
  // Kullanıcı adını kaydet (her sipariş eklendiğinde çağrılacak)
  static Future<void> addUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'all_usernames';
    final list = prefs.getStringList(key) ?? [];
    if (!list.contains(username)) {
      list.add(username);
      await prefs.setStringList(key, list);
    }
  }

  // Tüm kullanıcı adlarını getir
  static Future<List<String>> getAllUsernames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('all_usernames') ?? [];
  }

  // SİPARİŞLER
  static Future<List<Siparis>> getUserOrders(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('${username}_orders') ?? [];
    return data.map((e) => Siparis.fromJson(json.decode(e))).toList();
  }

  static Future<void> addOrder(String username, Siparis siparis) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${username}_orders';
    final list = prefs.getStringList(key) ?? [];
    list.add(json.encode(siparis.toJson()));
    await prefs.setStringList(key, list);
    // Kullanıcı adını da kaydet
    await addUsername(username);
  }

  static Future<void> markAsDelivered(String username, String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${username}_orders';
    final list = prefs.getStringList(key) ?? [];
    final orders = list.map((e) => Siparis.fromJson(json.decode(e))).toList();
    for (var s in orders) {
      if (s.id == orderId) {
        s.durum = 'pasif';
        s.tamamlanmaTarihi = _nowTurkishString();
      }
    }
    final updated = orders.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(key, updated);
  }

  static String _nowTurkishString() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  static Future<void> removeOrder(String username, String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${username}_orders';
    final list = prefs.getStringList(key) ?? [];
    final orders = list.map((e) => Siparis.fromJson(json.decode(e))).toList();
    orders.removeWhere((s) => s.id == orderId);
    final updated = orders.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(key, updated);
  }

  // BORÇLAR
  static Future<List<Borc>> getUserDebts(String username) async {
    debugPrint('LocalStorageService: getUserDebts çağrıldı ($username)');
    final prefs = await SharedPreferences.getInstance();
    final key = '${username}_debts';
    final data = prefs.getStringList(key) ?? [];
    debugPrint('LocalStorageService: borçlar okundu: $data');
    return data.map((e) => Borc.fromJson(json.decode(e))).toList();
  }

  static Future<void> addDebt(String username, Borc borc) async {
    debugPrint(
      'LocalStorageService: addDebt çağrıldı ($username, ${borc.urun})',
    );
    final prefs = await SharedPreferences.getInstance();
    final key = '${username}_debts';
    final list = prefs.getStringList(key) ?? [];
    list.add(json.encode(borc.toJson()));
    await prefs.setStringList(key, list);
    debugPrint('LocalStorageService: borç eklendi, yeni liste: $list');
  }

  static Future<void> payDebt(String username, List<String> debtIds) async {
    debugPrint('LocalStorageService: payDebt çağrıldı ($username, $debtIds)');
    final prefs = await SharedPreferences.getInstance();
    final key = '${username}_debts';
    final list = prefs.getStringList(key) ?? [];
    final updatedList = list
        .map((e) => Borc.fromJson(json.decode(e)))
        .where((borc) => !debtIds.contains(borc.id))
        .map((b) => json.encode(b.toJson()))
        .toList();
    await prefs.setStringList(key, updatedList);
    debugPrint(
      'LocalStorageService: borçlar silindi, yeni liste: $updatedList',
    );
  }

  // BİLDİRİMLER
  static Future<List<NotificationModel>> getUserNotifications(
    String username,
  ) async {
    debugPrint(
      'LocalStorageService: getUserNotifications çağrıldı ($username)',
    );
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('${username}_notifications') ?? [];
    debugPrint('LocalStorageService: bildirimler okundu: $data');
    return data.map((e) => NotificationModel.fromJson(json.decode(e))).toList();
  }

  static Future<void> addNotification(
    String username,
    NotificationModel notification,
  ) async {
    debugPrint(
      'LocalStorageService: addNotification çağrıldı ($username, ${notification.title})',
    );
    final prefs = await SharedPreferences.getInstance();
    final key = '${username}_notifications';
    final list = prefs.getStringList(key) ?? [];
    list.add(json.encode(notification.toJson()));
    await prefs.setStringList(key, list);
    debugPrint('LocalStorageService: bildirim eklendi, yeni liste: $list');
  }
}
