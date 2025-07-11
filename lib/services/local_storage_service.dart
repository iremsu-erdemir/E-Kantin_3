import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/siparis.dart';
import '../models/borc.dart';

class LocalStorageService {
  static Future<List<Siparis>> getUserOrders(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('${username}_orders') ?? [];
    return data.map((e) => Siparis.fromJson(json.decode(e))).toList();
  }

  static Future<List<Borc>> getUserDebts(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('${username}_debts') ?? [];
    return data.map((e) => Borc.fromJson(json.decode(e))).toList();
  }

  static Future<void> addOrder(String username, Siparis siparis) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${username}_orders';
    final list = prefs.getStringList(key) ?? [];
    list.add(json.encode(siparis.toJson()));
    await prefs.setStringList(key, list);
  }

  static Future<void> markAsDelivered(String username, String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${username}_orders';
    final list = prefs.getStringList(key) ?? [];
    final orders = list.map((e) => Siparis.fromJson(json.decode(e))).toList();
    for (var s in orders) {
      if (s.id == orderId) {
        s.durum = 'pasif';
      }
    }
    final updated = orders.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(key, updated);
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

  static Future<void> addDebt(String username, Borc borc) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${username}_debts';
    final list = prefs.getStringList(key) ?? [];
    list.add(json.encode(borc.toJson()));
    await prefs.setStringList(key, list);
  }

  static Future<void> payDebt(String username, List<String> debtIds) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${username}_debts';
    final list = prefs.getStringList(key) ?? [];
    final debts = list.map((e) => Borc.fromJson(json.decode(e))).toList();
    debts.removeWhere((b) => debtIds.contains(b.id));
    final updated = debts.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(key, updated);
  }
}
