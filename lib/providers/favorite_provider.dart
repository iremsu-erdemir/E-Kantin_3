import 'package:flutter/material.dart';
import '../models/favorite_menu.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<FavoriteMenu> _favorites = [];

  List<FavoriteMenu> get favorites => List.unmodifiable(_favorites);

  void addFavorite(FavoriteMenu menu) {
    if (!_favorites.any((f) => f.name == menu.name)) {
      _favorites.add(menu);
      notifyListeners();
    }
  }

  void removeFavorite(FavoriteMenu menu) {
    _favorites.removeWhere((f) => f.name == menu.name);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
