class FavoriteMenu {
  final String name;
  final bool isCeyrek;
  final bool isTam;
  final String ekmekTipi;
  final String ekmekTuru;
  final List<String> secilenIcerikler;
  final String imagePath;
  final double price;

  FavoriteMenu({
    required this.name,
    required this.isCeyrek,
    required this.isTam,
    required this.ekmekTipi,
    required this.ekmekTuru,
    required this.secilenIcerikler,
    required this.imagePath,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'isCeyrek': isCeyrek,
    'isTam': isTam,
    'ekmekTipi': ekmekTipi,
    'ekmekTuru': ekmekTuru,
    'secilenIcerikler': secilenIcerikler,
    'imagePath': imagePath,
    'price': price,
  };

  factory FavoriteMenu.fromJson(Map<String, dynamic> json) => FavoriteMenu(
    name: json['name'],
    isCeyrek: json['isCeyrek'],
    isTam: json['isTam'],
    ekmekTipi: json['ekmekTipi'],
    ekmekTuru: json['ekmekTuru'],
    secilenIcerikler: List<String>.from(json['secilenIcerikler'] ?? []),
    imagePath: json['imagePath'],
    price: (json['price'] is int)
        ? (json['price'] as int).toDouble()
        : json['price'],
  );
}
