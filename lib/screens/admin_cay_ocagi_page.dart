import 'package:flutter/material.dart';
import '../screens/admin_cay_alacak_detay_page.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import '../services/local_storage_service.dart';
import '../models/borc.dart';

class AdminCayOcagiPage extends StatefulWidget {
  const AdminCayOcagiPage({Key? key}) : super(key: key);

  @override
  State<AdminCayOcagiPage> createState() => AdminCayOcagiPageState();
}

class AdminCayOcagiPageState extends State<AdminCayOcagiPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Personel arama ve seçim için
  List<User> tumKullanicilar = [];
  List<User> filtreliKullanicilar = [];
  User? seciliKullanici;
  final TextEditingController aramaController = TextEditingController();
  bool aramaOdak = false;

  // Ürünler ve adetler
  final List<Map<String, dynamic>> urunler = [
    {'isim': 'Küçük Çay', 'fiyat': 85.5, 'adet': 0},
    {'isim': 'Büyük Çay', 'fiyat': 85.5, 'adet': 0},
    {'isim': 'Saklıköy', 'fiyat': 85.5, 'adet': 0},
    {'isim': 'Küçük Su', 'fiyat': 85.5, 'adet': 0},
  ];

  Map<String, double> kullaniciToplamBorc = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _kullanicilariYukle();
    aramaController.addListener(_aramaYap);
    _borclariYukle();
  }

  void _kullanicilariYukle() {
    tumKullanicilar = UserService().getAllUsers();
    filtreliKullanicilar = List.from(tumKullanicilar);
    setState(() {});
  }

  void _aramaYap() {
    final query = aramaController.text.toLowerCase();
    if (query.isEmpty) {
      filtreliKullanicilar = List.from(tumKullanicilar);
    } else {
      filtreliKullanicilar = tumKullanicilar
          .where((u) => (u.name ?? '').toLowerCase().contains(query))
          .toList();
    }
    setState(() {});
  }

  void _kullaniciSec(User user) {
    seciliKullanici = user;
    aramaController.clear();
    aramaOdak = false;
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  void _kullaniciIptal() {
    seciliKullanici = null;
    setState(() {});
  }

  void _adetArtir(int index) {
    urunler[index]['adet']++;
    setState(() {});
  }

  void _adetAzalt(int index) {
    if (urunler[index]['adet'] > 0) {
      urunler[index]['adet']--;
      setState(() {});
    }
  }

  double get toplamTutar {
    double toplam = 0;
    for (var u in urunler) {
      if (u['adet'] > 0) {
        toplam += (u['fiyat'] as double) * (u['adet'] as int);
      }
    }
    return toplam;
  }

  bool get _borcEklenebilir {
    if (seciliKullanici == null) return false;
    return urunler.any((u) => u['adet'] > 0);
  }

  void _borcEkle() async {
    if (!_borcEklenebilir) return;
    final toplam = toplamTutar;
    final username = seciliKullanici!.username;
    final name = seciliKullanici!.name ?? seciliKullanici!.username;
    final onay = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Text(
                'Borç eklemek istiyor musunuz?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.close, color: Colors.red),
                    label: const Text(
                      'Hayır',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.check, color: Colors.green),
                    label: const Text(
                      'Evet',
                      style: TextStyle(color: Colors.green),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (onay == true) {
      final now = DateTime.now();
      final tarih =
          '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      for (var urun in urunler) {
        if (urun['adet'] > 0) {
          final borc = Borc(
            id: UniqueKey().toString(),
            urun: urun['isim'],
            tutar: (urun['fiyat'] as double) * (urun['adet'] as int),
            tarih: tarih,
            count: urun['adet'],
          );
          await LocalStorageService.addDebt(username, borc);
        }
      }
      // Seçimleri sıfırla
      setState(() {
        for (var u in urunler) {
          u['adet'] = 0;
        }
        seciliKullanici = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Borç başarıyla eklendi.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _borclariYukle() async {
    final users = UserService().getAllUsers();
    Map<String, double> borcMap = {};
    for (var user in users) {
      final borclar = await LocalStorageService.getUserDebts(user.username);
      double toplam = 0;
      for (var b in borclar) {
        toplam += b.tutar;
      }
      borcMap[user.username] = toplam;
    }
    setState(() {
      kullaniciToplamBorc = borcMap;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _borclariYukle();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Çay Ocağı',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black38,
              indicatorColor: Colors.red,
              indicatorWeight: 2.5,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
              tabs: const [
                Tab(text: 'Borç Ekle'),
                Tab(text: 'Borçlular'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildBorcEkleTab(), _buildBorclularTab()],
      ),
      bottomNavigationBar: _AdminBottomNavBar(),
    );
  }

  Widget _buildBorcEkleTab() {
    // Personel arama ve seçim UI
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: aramaController,
                onTap: () {
                  setState(() {
                    aramaOdak = true;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Personel Seç',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFBDBDBD),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (aramaOdak &&
                  seciliKullanici == null &&
                  filtreliKullanicilar.isNotEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.25,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtreliKullanicilar.length,
                      itemBuilder: (context, index) {
                        final user = filtreliKullanicilar[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                              user.image ?? 'assets/images/person.png',
                            ),
                          ),
                          title: Text(user.name ?? user.username),
                          subtitle: Text(user.role ?? ''),
                          onTap: () => _kullaniciSec(user),
                        );
                      },
                    ),
                  ),
                ),
              if (seciliKullanici != null)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          seciliKullanici!.image ?? 'assets/images/person.png',
                        ),
                        radius: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(seciliKullanici!.name ?? seciliKullanici!.username),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _kullaniciIptal,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            itemCount: urunler.length,
            itemBuilder: (context, index) {
              final urun = urunler[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            urun['isim'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₺${(urun['fiyat'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    urun['adet'] == 0
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                urunler[index]['adet'] = 1;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF3D3D),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Ekle'),
                          )
                        : Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Color(0xFFFF3D3D),
                                ),
                                onPressed: () => _adetAzalt(index),
                              ),
                              Text(
                                urun['adet'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Color(0xFFFF3D3D),
                                ),
                                onPressed: () => _adetArtir(index),
                              ),
                            ],
                          ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₺${toplamTutar.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                onPressed: _borcEklenebilir ? _borcEkle : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3D3D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  elevation: 0,
                ),
                child: const Text('Borç Ekle'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _borcUrunItem(String urun, String fiyat) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  urun,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fiyat,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Color(0xFFFF3D3D),
                ),
                onPressed: () {},
              ),
              const Text(
                '1',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFFFF3D3D),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Future<int> borcluKullaniciSayisi() async {
    final users = UserService().getAllUsers();
    int count = 0;
    for (var user in users) {
      final borclar = await LocalStorageService.getUserDebts(user.username);
      double toplam = 0;
      for (var b in borclar) {
        toplam += b.tutar;
      }
      if (toplam > 0) count++;
    }
    return count;
  }

  static Future<double> toplamCayOcagiBorcu() async {
    final users = UserService().getAllUsers();
    double toplam = 0;
    for (var user in users) {
      final borclar = await LocalStorageService.getUserDebts(user.username);
      for (var b in borclar) {
        toplam += b.tutar;
      }
    }
    return toplam;
  }

  static Future<double> toplamCayOcagiSiparisTutari() async {
    final users = UserService().getAllUsers();
    double toplam = 0;
    final cayOcagiUrunleri = [
      'Küçük Çay',
      'Büyük Çay',
      'Saklıköy',
      'Küçük Su',
      'Nescafe',
      'Türk Kahvesi',
      'Sade Soda',
      'Probis',
      'Limonlu Soda',
      'Sütlü Nescafe',
    ];
    for (var user in users) {
      final siparisler = await LocalStorageService.getUserOrders(user.username);
      for (var s in siparisler) {
        if (cayOcagiUrunleri.any((u) => s.urun.contains(u))) {
          toplam += s.tutar;
        }
      }
    }
    return toplam;
  }

  Widget _buildBorclularTab() {
    final users = UserService().getAllUsers();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      children: users
          .where((user) => (kullaniciToplamBorc[user.username] ?? 0.0) > 0)
          .map((user) {
            final toplam = kullaniciToplamBorc[user.username] ?? 0.0;
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => AdminCayAlacakDetayPage(
                          username: user.username,
                          name: user.name ?? user.username,
                        ),
                      ),
                    )
                    .then((_) => _borclariYukle());
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      user.name ?? user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '₺${toplam.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
          .toList(),
    );
  }

  String _usernameFromName(String name) {
    // İsimden username üret (küçük harf, boşlukları kaldır)
    final map = {
      'Cengiz Demir': 'cengiz',
      'Turgut Özcan': 'turgut',
      'Taner Mutlu': 'taner',
      'Esma Nur Kayhan': 'esma',
      'Erkan Öztürk': 'erkan',
    };
    return map[name] ?? name.toLowerCase().replaceAll(' ', '');
  }
}

class _AdminBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const selectedColor = Color(0xFFFF3D3D);
    const unselectedColor = Color(0xFFBDBDBD);
    final currentIndex = 0; // Ana Sayfa aktif
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 8, top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.search_outlined,
            label: 'Ana Sayfa',
            selected: currentIndex == 0,
          ),
          _NavBarItem(
            icon: Icons.favorite_border,
            label: 'Favorilerim',
            selected: currentIndex == 1,
          ),
          _NavBarItem(
            icon: Icons.shopping_cart_outlined,
            label: 'Sepetim',
            selected: currentIndex == 2,
          ),
          _NavBarItem(
            icon: Icons.person_outline,
            label: 'Siparişlerim',
            selected: currentIndex == 3,
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected ? const Color(0xFFFF3D3D) : const Color(0xFFBDBDBD),
            size: 30,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: selected
                  ? const Color(0xFFFF3D3D)
                  : const Color(0xFFBDBDBD),
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          selected
              ? Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              : const SizedBox(height: 4),
        ],
      ),
    );
  }
}
