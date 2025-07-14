import 'package:flutter/material.dart';
import '../models/tea_debt_item.dart';

class TeaHouseDebtProvider extends ChangeNotifier {
  List<TeaDebtItem> _items = [
    TeaDebtItem(title: 'Küçük Çay', price: 5.5),
    TeaDebtItem(title: 'Büyük Çay', price: 5.5),
    TeaDebtItem(title: 'Türk Kahvesi', price: 5.5),
    TeaDebtItem(title: 'Nescafe', price: 5.5),
    TeaDebtItem(title: 'Sakızlı', price: 5.5),
    TeaDebtItem(title: 'Sade Soda', price: 5.5),
    TeaDebtItem(title: 'Probis', price: 5.5),
  ];

  List<TeaDebtItem> get items => _items;

  void toggleItemSelection(int index) {
    _items[index].isSelected = !_items[index].isSelected;
    notifyListeners();
  }

  double get totalDebt =>
      _items.where((e) => e.isSelected).fold(0.0, (sum, e) => sum + e.price);

  double get remainingDebt =>
      _items.where((e) => !e.isSelected).fold(0.0, (sum, e) => sum + e.price);

  void clearSelectedItems() {
    for (var item in _items) {
      item.isSelected = false;
    }
    notifyListeners();
  }

  void removeSelectedItems() {
    final removed = _items.where((e) => e.isSelected).toList();
    if (removed.isNotEmpty) {
      print('Silinen borçlar:');
      for (var item in removed) {
        print(' - ${item.title} (₺${item.price})');
      }
      print(
        'Toplam silinen borç: ₺${removed.fold(0.0, (sum, e) => sum + e.price)}',
      );
    } else {
      print('Hiç borç seçilmedi, silme işlemi yapılmadı.');
    }
    _items.removeWhere((e) => e.isSelected);
    notifyListeners();
  }

  // Gelecekte buraya API'den veri çekme fonksiyonu eklenebilir
}
