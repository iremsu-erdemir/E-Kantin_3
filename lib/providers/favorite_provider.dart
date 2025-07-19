import 'package:flutter/material.dart';
import '../models/favorite_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteProvider extends ChangeNotifier {
  final List<FavoriteMenu> _favorites = [];

  FavoriteProvider() {
    _loadFavorites();
  }

  List<FavoriteMenu> get favorites => List.unmodifiable(_favorites);

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _favorites.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('favoriteMenus', jsonList);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('favoriteMenus') ?? [];
    _favorites.clear();
    _favorites.addAll(
      jsonList.map((e) => FavoriteMenu.fromJson(jsonDecode(e))),
    );
    notifyListeners();
  }

  void addFavorite(FavoriteMenu menu) {
    if (!_favorites.any((f) => f.name == menu.name)) {
      _favorites.add(menu);
      _saveFavorites();
      notifyListeners();
    }
  }

  void removeFavorite(FavoriteMenu menu) {
    _favorites.removeWhere((f) => f.name == menu.name);
    _saveFavorites();
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    _saveFavorites();
    notifyListeners();
  }
}
