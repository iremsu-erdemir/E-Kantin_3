import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MenuModel {
  final String name;
  final String price;
  final String desc;
  final String imagePath;
  final String ekmekTipi;
  final List<String> icerikler;
  final bool aktif;

  MenuModel({
    required this.name,
    required this.price,
    required this.desc,
    required this.imagePath,
    required this.ekmekTipi,
    required this.icerikler,
    required this.aktif,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'desc': desc,
    'imagePath': imagePath,
    'ekmekTipi': ekmekTipi,
    'icerikler': icerikler,
    'aktif': aktif,
  };

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
    name: json['name'],
    price: json['price'],
    desc: json['desc'],
    imagePath: json['imagePath'],
    ekmekTipi: json['ekmekTipi'],
    icerikler: List<String>.from(json['icerikler'] ?? []),
    aktif: json['aktif'] ?? true,
  );
}

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
}
