class Siparis {
  String id;
  String urun;
  double tutar;
  String durum; // 'aktif' veya 'pasif'
  String img;
  String siparisNo;
  String tarih;
  String kayitTarihi;

  Siparis({
    required this.id,
    required this.urun,
    required this.tutar,
    required this.durum,
    required this.img,
    required this.siparisNo,
    required this.tarih,
    required this.kayitTarihi,
  });

  factory Siparis.fromJson(Map<String, dynamic> json) => Siparis(
    id: json['id'] ?? '',
    urun: json['urun'] ?? '',
    tutar: (json['tutar'] as num).toDouble(),
    durum: json['durum'] ?? 'aktif',
    img: json['img'] ?? '',
    siparisNo: json['siparisNo'] ?? '',
    tarih: json['tarih'] ?? '',
    kayitTarihi: json['kayitTarihi'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'urun': urun,
    'tutar': tutar,
    'durum': durum,
    'img': img,
    'siparisNo': siparisNo,
    'tarih': tarih,
    'kayitTarihi': kayitTarihi,
  };
}
