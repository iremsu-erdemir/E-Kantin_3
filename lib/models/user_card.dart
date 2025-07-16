/// Kullanıcıya ait kart bilgisini temsil eder. Sadece UI'de gösterilecek ve SharedPreferences'ta saklanacak alanlar içerir.
class UserCard {
  final String cardHolder;
  final String cardNumber; // Tam numara, sadece son 4 hane UI'de gösterilecek
  final String expiryDate; // MM/YY
  final String? cvc; // CVC sadece modelde, UI'da gösterilmez
  final String? cardName; // Kart kayıt adı

  UserCard({
    required this.cardHolder,
    required this.cardNumber,
    required this.expiryDate,
    this.cvc,
    this.cardName,
  });

  /// Son 4 haneyi döndürür (güvenlik için)
  String get maskedNumber =>
      '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';

  /// JSON'a çevir (SharedPreferences için)
  Map<String, dynamic> toJson() => {
    'cardHolder': cardHolder,
    'cardNumber': cardNumber,
    'expiryDate': expiryDate,
    if (cvc != null) 'cvc': cvc,
    if (cardName != null) 'cardName': cardName,
  };

  /// JSON'dan nesne oluştur
  factory UserCard.fromJson(Map<String, dynamic> json) => UserCard(
    cardHolder: json['cardHolder'],
    cardNumber: json['cardNumber'],
    expiryDate: json['expiryDate'],
    cvc: json['cvc'],
    cardName: json['cardName'],
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCard &&
          runtimeType == other.runtimeType &&
          cardHolder == other.cardHolder &&
          cardNumber == other.cardNumber &&
          expiryDate == other.expiryDate &&
          cardName == other.cardName;

  @override
  int get hashCode =>
      cardHolder.hashCode ^
      cardNumber.hashCode ^
      expiryDate.hashCode ^
      (cardName?.hashCode ?? 0);
}
