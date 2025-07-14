class TeaDebtItem {
  final String title;
  final double price;
  bool isSelected;

  TeaDebtItem({
    required this.title,
    required this.price,
    this.isSelected = false,
  });

  TeaDebtItem copyWith({String? title, double? price, bool? isSelected}) {
    return TeaDebtItem(
      title: title ?? this.title,
      price: price ?? this.price,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'price': price,
    'isSelected': isSelected,
  };

  factory TeaDebtItem.fromJson(Map<String, dynamic> json) => TeaDebtItem(
    title: json['title'],
    price: (json['price'] as num).toDouble(),
    isSelected: json['isSelected'] ?? false,
  );
}
