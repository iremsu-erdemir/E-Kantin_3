import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/menu_model.dart';
import '../models/urun_model.dart';

class LocalMenuService {
  static const String _key = 'localMenus';

  static Future<List<MenuModel>> getMenus() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((e) => MenuModel.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> saveMenus(List<MenuModel> menus) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = menus.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<void> addMenu(MenuModel menu) async {
    final menus = await getMenus();
    menus.add(menu);
    await saveMenus(menus);
  }

  static Future<void> clearMenus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<void> deleteMenusByNames(List<String> names) async {
    final menus = await getMenus();
    final namesNormalized = names.map((e) => e.toLowerCase().trim()).toList();
    menus.removeWhere(
      (menu) => namesNormalized.contains(menu.name.toLowerCase().trim()),
    );
    await saveMenus(menus);
  }
}

// Sadece script olarak çalıştırmak için:
void main(List<String> args) async {
  // Komut satırından isimler alınabilir veya sabit isimler kullanılabilir
  await LocalMenuService.deleteMenusByNames([
    'Menü 18',
    'Doğal Sandviç',
    'Acı Lezzet',
    'Enfess',
  ]);
  print('Belirtilen menüler silindi.');
}
