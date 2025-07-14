import 'package:flutter/material.dart';
import '../models/borc.dart';
import '../services/local_storage_service.dart';

class DebtProvider extends ChangeNotifier {
  List<Borc> _debts = [];
  bool _isLoading = false;

  List<Borc> get debts => _debts;
  bool get isLoading => _isLoading;

  Future<void> loadDebts(String username) async {
    debugPrint('DebtProvider: loadDebts çağrıldı ($username)');
    await Future.delayed(Duration.zero);
    _isLoading = true;
    debugPrint('DebtProvider: notifyListeners (isLoading true)');
    notifyListeners();
    _debts = await LocalStorageService.getUserDebts(username);
    debugPrint(
      'DebtProvider: borçlar yüklendi: ${_debts.map((b) => b.urun).toList()}',
    );
    _isLoading = false;
    debugPrint('DebtProvider: notifyListeners (isLoading false)');
    notifyListeners();
  }

  Future<void> payDebts(String username, List<String> debtIds) async {
    debugPrint('DebtProvider: payDebts çağrıldı, silinecek borçlar: $debtIds');
    await LocalStorageService.payDebt(username, debtIds);
    await loadDebts(username);
  }

  Future<void> addDebt(String username, Borc borc) async {
    debugPrint('DebtProvider: addDebt çağrıldı: ${borc.urun}');
    await LocalStorageService.addDebt(username, borc);
    await loadDebts(username);
  }

  double get totalDebt => _debts.fold(0.0, (sum, b) => sum + b.tutar);

  double selectedTotal(List<String> selectedIds) => _debts
      .where((b) => selectedIds.contains(b.id))
      .fold(0.0, (sum, b) => sum + b.tutar);

  void clear() {
    _debts = [];
    notifyListeners();
  }
}
