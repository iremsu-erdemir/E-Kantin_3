import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_card.dart';

/// Kullanıcı kartlarını kalıcı olarak saklamak ve okumak için servis
class UserCardService {
  static const String _key = 'user_cards';

  /// Tüm kartları getirir
  static Future<List<UserCard>> getCards() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List decoded = json.decode(jsonString);
    return decoded.map((e) => UserCard.fromJson(e)).toList();
  }

  /// Yeni kart ekler ve kaydeder
  static Future<void> addCard(UserCard card) async {
    final cards = await getCards();
    cards.add(card);
    await _saveCards(cards);
  }

  /// Kartları günceller
  static Future<void> _saveCards(List<UserCard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(cards.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  /// Tüm kartları siler (test için)
  static Future<void> clearCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// Kartı günceller (eski kartı bulup yenisiyle değiştirir)
  static Future<void> updateCard(UserCard oldCard, UserCard newCard) async {
    final cards = await getCards();
    final index = cards.indexWhere(
      (c) =>
          c.cardNumber == oldCard.cardNumber &&
          c.expiryDate == oldCard.expiryDate &&
          c.cardHolder == oldCard.cardHolder,
    );
    if (index != -1) {
      cards[index] = newCard;
      await _saveCards(cards);
    }
  }
}
