class Borc {
  String id;
  String urun;
  double tutar;
  String tarih;
  int count;

  Borc({
    required this.id,
    required this.urun,
    required this.tutar,
    required this.tarih,
    this.count = 1,
  });

  factory Borc.fromJson(Map<String, dynamic> json) => Borc(
    id: json['id'] ?? '',
    urun: json['urun'] ?? '',
    tutar: (json['tutar'] as num).toDouble(),
    tarih: json['tarih'] ?? '',
    count: json['count'] ?? 1,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'urun': urun,
    'tutar': tutar,
    'tarih': tarih,
    'count': count,
  };
}
