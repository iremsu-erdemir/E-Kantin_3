import 'package:e_kantin/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../components/ek_bottom_nav_bar.dart';
import 'payment.dart';
import 'home_page.dart';
import '../models/user.dart';
import '../models/siparis.dart';
import '../models/borc.dart';
import '../services/local_storage_service.dart';
import '../providers/notification_provider.dart';
import 'package:provider/provider.dart';
import '../providers/debt_provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart.dart';
import 'package:intl/intl.dart';

class SiparislerPage extends StatefulWidget {
  final int initialTab;
  const SiparislerPage({Key? key, this.initialTab = 0}) : super(key: key);
  @override
  State<SiparislerPage> createState() => _SiparislerPageState();
}

class _SiparislerPageState extends State<SiparislerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Siparis> siparisler = [];
  // List<Borc> borclar = []; // KALDIRILDI
  bool _firstLoad = true;
  List<String> seciliIdler = [];
  List<String> odenenBorcIdler = [];

  @override
  void initState() {
    super.initState();

    // clearPrefs(); // ekle

    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _tabController.addListener(() async {
      // Tab değişiminde Çay Ocağı Borcu sekmesine gelindiyse borçları güncelle
      if (_tabController.index == 2) {
        final username = _userKey ?? "anonim";
        await Provider.of<DebtProvider>(
          context,
          listen: false,
        ).loadDebts(username);
        setState(() {}); // Arayüzü yenile
      }
      if (_tabController.index == 3) {
        final username = _userKey ?? "anonim";
        await Provider.of<NotificationProvider>(
          context,
          listen: false,
        ).loadNotifications(username);
        setState(() {});
      }
      loadAll();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAll();
    });
  }

  Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('SharedPreferences temizlendi');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final username = _userKey ?? "anonim";
      Provider.of<DebtProvider>(context, listen: false).loadDebts(username);
    });
  }

  String? get _userKey {
    final user = UserSingleton().user;
    return user?.username;
  }

  Future<void> loadAll() async {
    final username = _userKey ?? "anonim";
    siparisler = await LocalStorageService.getUserOrders(username);

    // Eğer hiç borç yoksa örnek borçlar ekle (sadece SharedPreferences boşsa)
    final borclar = await LocalStorageService.getUserDebts(username);
    if (borclar.isEmpty) {
      await LocalStorageService.addDebt(
        username,
        Borc(
          id: '1',
          urun: 'Küçük Çay',
          tutar: 5.5,
          tarih: DateTime.now().toString(),
        ),
      );
      await LocalStorageService.addDebt(
        username,
        Borc(
          id: '2',
          urun: 'Büyük Çay',
          tutar: 7.0,
          tarih: DateTime.now().toString(),
        ),
      );
      await LocalStorageService.addDebt(
        username,
        Borc(
          id: '3',
          urun: 'Nescafe',
          tutar: 8.0,
          tarih: DateTime.now().toString(),
        ),
      );
      // Borçlar eklendikten sonra Provider'ı güncelle
      await Provider.of<DebtProvider>(
        context,
        listen: false,
      ).loadDebts(username);
    }

    print(
      'siparisler (sayısı):  [33m [1m [4m [7m [41m [30m [0m${siparisler.length}',
    );
    for (var s in siparisler) {
      print('Siparis: id=${s.id}, durum=${s.durum}, urun=${s.urun}');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Future<void> ekleSiparis(Siparis siparis) async {
    final username = _userKey ?? "anonim";
    siparis.kayitTarihi = DateTime.now().toIso8601String();
    // Burada durum ataması kritik:
    siparis.durum = 'aktif';
    await LocalStorageService.addOrder(username, siparis);
    // Bildirim ekle
    final now = DateTime.now();
    await Provider.of<NotificationProvider>(
      context,
      listen: false,
    ).addNotification(
      username,
      NotificationModel(
        title: 'Yeni Sipariş',
        content: 'Yeni bir sipariş oluşturuldu: ${siparis.urun}',
        date: now.toString(),
      ),
    );
    await loadAll();
  }

  Future<void> siparisiTamamla(String orderId) async {
    final username = _userKey ?? "anonim";
    await LocalStorageService.markAsDelivered(username, orderId);
    // Bildirim ekle
    final now = DateTime.now();
    // Çift bildirim olmaması için sadece NotificationProvider ile ekle
    await Provider.of<NotificationProvider>(
      context,
      listen: false,
    ).addNotification(
      username,
      NotificationModel(
        title: 'Sipariş Teslim Edildi',
        content: 'Bir sipariş teslim edildi.',
        date: now.toString(),
      ),
    );
    await loadAll();
  }

  Future<void> ekleBorc(Borc borc) async {
    final username = _userKey ?? "anonim";
    await Provider.of<DebtProvider>(
      context,
      listen: false,
    ).addDebt(username, borc);
    await loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Siparişlerim',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.redAccent,
              unselectedLabelColor: Colors.black38,
              indicatorColor: Colors.redAccent,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Aktif Sipariş'),
                Tab(text: 'Tamamlanan Sipariş'),
                Tab(text: 'Çay Ocağı Borcu'),
                Tab(text: 'Bildirimler'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _siparisListesi('aktif'),
          _siparisListesi('pasif'),
          _borcListesi(),
          _bildirimler(),
        ],
      ),
      bottomNavigationBar: EKBottomNavBar(
        currentIndex: 2,
        parentContext: context,
      ),
    );
  }

  Widget _siparisListesi(String durum) {
    final filtreli = siparisler.where((s) => s.durum == durum).toList();
    filtreli.sort(
      (a, b) => DateTime.parse(
        b.kayitTarihi,
      ).compareTo(DateTime.parse(a.kayitTarihi)),
    );
    if (filtreli.isEmpty) {
      return const Center(
        child: Text(
          'Sipariş yok',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtreli.length,
      itemBuilder: (context, index) {
        final s = filtreli[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    s.img,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.urun,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '₺${s.tutar}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                s.siparisNo,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                s.tarih,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (durum == 'aktif')
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ElevatedButton(
                              onPressed: () => siparisiTamamla(s.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 8,
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Teslim Edildi'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _borcListesi() {
    // Segmented Control için state
    int selectedTab = 0;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            // Segmented Control
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _toggleButton(
                    icon: Icons.receipt,
                    text: 'Borçlar',
                    index: 0,
                    selected: selectedTab,
                    onChanged: (i) => setState(() => selectedTab = i),
                  ),
                  _toggleButton(
                    icon: Icons.local_cafe,
                    text: 'Ürünler',
                    index: 1,
                    selected: selectedTab,
                    onChanged: (i) => setState(() => selectedTab = i),
                  ),
                ],
              ),
            ),
            // Animasyonlu geçiş
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: selectedTab == 0 ? _borclarTab() : _urunlerTab(context),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _toggleButton({
    required IconData icon,
    required String text,
    required int index,
    required int selected,
    required Function(int) onChanged,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected == index ? Colors.redAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected == index ? Colors.white : Colors.black54,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: selected == index ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Borçlar sekmesi (mevcut kod)
  Widget _borclarTab() {
    return Consumer<DebtProvider>(
      builder: (context, debtProvider, _) {
        final borclar = debtProvider.debts;
        if (borclar.isEmpty) {
          return const Center(
            child: Text(
              'Borç bulunamadı',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Çay Ocağı Borcu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                itemCount: borclar.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final b = borclar[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: seciliIdler.contains(b.id),
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                seciliIdler.add(b.id);
                              } else {
                                seciliIdler.remove(b.id);
                              }
                            });
                          },
                          activeColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Text(
                              b.count > 1 ? '${b.urun} x${b.count}' : b.urun,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            '+₺${b.tutar.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₺${borclar.where((b) => seciliIdler.contains(b.id)).fold(0.0, (sum, b) => sum + b.tutar).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: seciliIdler.isNotEmpty
                          ? () async {
                              // Ödeme ekranına yönlendir
                              final username = _userKey ?? "anonim";
                              final debtProvider = Provider.of<DebtProvider>(
                                context,
                                listen: false,
                              );
                              final selectedIds = List<String>.from(
                                seciliIdler,
                              );
                              final selectedDebts = debtProvider.debts
                                  .where((b) => selectedIds.contains(b.id))
                                  .toList();
                              double toplamBorc = debtProvider.debts.fold(
                                0,
                                (sum, item) => sum + item.tutar,
                              );
                              double seciliBorc = selectedDebts.fold(
                                0,
                                (sum, item) => sum + item.tutar,
                              );
                              double kalanBorc = toplamBorc - seciliBorc;
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                    totalPrice: seciliBorc,
                                    isCayOcagiBorcu: true,
                                    kalanBorc: kalanBorc,
                                  ),
                                ),
                              );
                              debugPrint(
                                'Ödeme sonrası kontrol: result = $result, seciliIdler = $seciliIdler',
                              );
                              if (result == 'odeme_basarili') {
                                debugPrint(
                                  'payDebts fonksiyonu çağrılıyor, selectedIds: $selectedIds',
                                );
                                await debtProvider.payDebts(
                                  username,
                                  selectedIds,
                                );
                                // Adetli ürün metni oluştur
                                final urunAdetMap = <String, int>{};
                                for (var b in selectedDebts) {
                                  urunAdetMap[b.urun] =
                                      (urunAdetMap[b.urun] ?? 0) +
                                      (b.count > 0 ? b.count : 1);
                                }
                                final urunlerMetni = urunAdetMap.entries
                                    .map((e) => '${e.value} adet ${e.key}')
                                    .join(', ');
                                final bildirimIcerik =
                                    'B Blok 7 nolu çay ocağından $urunlerMetni borcu ödendi.';
                                await Provider.of<NotificationProvider>(
                                  context,
                                  listen: false,
                                ).addNotification(
                                  username,
                                  NotificationModel(
                                    title: 'Çay Ocağı Siparişi',
                                    content: bildirimIcerik,
                                    date: DateTime.now().toString(),
                                  ),
                                );
                                setState(() {
                                  seciliIdler.clear();
                                });
                                await debtProvider.loadDebts(username);
                                setState(() {});
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Ödeme Yap'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Ürünler sekmesi (yeni kod)
  Widget _urunlerTab(BuildContext context) {
    // Sabit ürün listesi
    final urunler = [
      {'name': 'Küçük Çay', 'price': 5.5},
      {'name': 'Büyük Çay', 'price': 6.5},
      {'name': 'Türk Kahvesi', 'price': 15.0},
      {'name': 'Nescafe', 'price': 15.0},
      {'name': 'Saklıköy', 'price': 6.5},
      {'name': 'Sade Soda', 'price': 6.5},
      {'name': 'Probis', 'price': 6.5},
    ];
    final List<String> seciliUrunler = [];
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Çay Ocağı Ürünleri',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: urunler.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final urun = urunler[index];
                  final secili = seciliUrunler.contains(urun['name']);
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: secili,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                seciliUrunler.add(urun['name'] as String);
                              } else {
                                seciliUrunler.remove(urun['name'] as String);
                              }
                            });
                          },
                          activeColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Text(
                              urun['name'] as String,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            '+₺${(urun['price'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: seciliUrunler.isNotEmpty
                          ? () {
                              // Seçili ürünleri sepete ekle
                              final cartProvider = Provider.of<CartProvider>(
                                context,
                                listen: false,
                              );
                              for (var urun in urunler) {
                                if (seciliUrunler.contains(urun['name'])) {
                                  cartProvider.addOrUpdate(
                                    CartItem(
                                      id: urun['name'] as String,
                                      name: urun['name'] as String,
                                      imagePath: '',
                                      price: urun['price'] as double,
                                    ),
                                  );
                                }
                              }
                              // Sepet ödeme ekranına yönlendir
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                    totalPrice: seciliUrunler.fold(
                                      0.0,
                                      (sum, name) =>
                                          sum +
                                          (urunler.firstWhere(
                                                (u) => u['name'] == name,
                                              )['price']
                                              as double),
                                    ),
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Sepete Ekle'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _bildirimler() {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, _) {
        final notifications = notificationProvider.notifications;
        if (notifications.isEmpty) {
          return const Center(
            child: Text(
              'Bildirim yok',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final n = notifications.reversed.toList()[index];
            // Tarih ve saat formatı (örn: 2025-07-15 03:27:53)
            String formattedDate = n.date;
            if (n.date.contains('T')) {
              final dateTime = DateTime.tryParse(n.date);
              if (dateTime != null) {
                formattedDate =
                    '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
                    '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
              }
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          n.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    n.content,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(DateTime.parse(n.date)),
                    style: const TextStyle(fontSize: 13, color: Colors.black45),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
