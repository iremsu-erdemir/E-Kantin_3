import 'urun_model.dart';

class MenuModel {
  final String name;
  final String imagePath;
  final String ekmekTipi;
  final List<UrunModel> urunler;
  final bool aktif;

  MenuModel({
    required this.name,
    required this.imagePath,
    required this.ekmekTipi,
    required this.urunler,
    required this.aktif,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'imagePath': imagePath,
    'ekmekTipi': ekmekTipi,
    'urunler': urunler.map((u) => u.toJson()).toList(),
    'aktif': aktif,
  };

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
    name: json['name'] ?? '',
    imagePath: json['imagePath'] ?? 'assets/images/sandwichMenu.png',
    ekmekTipi: json['ekmekTipi'] ?? '',
    urunler: (json['urunler'] as List<dynamic>? ?? [])
        .map((e) => UrunModel.fromJson(e))
        .toList(),
    aktif: json['aktif'] ?? true,
  );

  MenuModel copyWith({
    String? name,
    String? imagePath,
    String? ekmekTipi,
    List<UrunModel>? urunler,
    bool? aktif,
  }) {
    return MenuModel(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      ekmekTipi: ekmekTipi ?? this.ekmekTipi,
      urunler: urunler ?? this.urunler,
      aktif: aktif ?? this.aktif,
    );
  }
}
