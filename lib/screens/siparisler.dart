import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../components/ek_bottom_nav_bar.dart';
import 'payment.dart';
import 'home_page.dart';
import '../models/user.dart';

class SiparislerPage extends StatefulWidget {
  const SiparislerPage({Key? key}) : super(key: key);
  @override
  State<SiparislerPage> createState() => _SiparislerPageState();
}

class _SiparislerPageState extends State<SiparislerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> siparisler = [];
  List<Map<String, dynamic>> borclar = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      loadAll();
    });
    loadAll();
  }

  Future<List<Map<String, dynamic>>> loadList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  Future<void> saveList(String key, List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(list));
  }

  Future<void> loadAll() async {
    siparisler = await loadList('siparisler');
    borclar = await loadList('borclar');
    setState(() {});
  }

  Future<void> ekleSiparis(Map<String, dynamic> siparis) async {
    siparisler.add(siparis);
    await saveList('siparisler', siparisler);
    setState(() {});
  }

  Future<void> siparisiTamamla(int index) async {
    siparisler[index]['durum'] = 'pasif';
    await saveList('siparisler', siparisler);
    setState(() {});
  }

  Future<void> ekleBorc(Map<String, dynamic> borc) async {
    borclar.add(borc);
    await saveList('borclar', borclar);
    setState(() {});
  }

  Future<void> borcOde(List<int> seciliIndexler) async {
    seciliIndexler.reversed.forEach((i) => borclar.removeAt(i));
    await saveList('borclar', borclar);
    setState(() {});
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
        highlightIndex: 2,
        parentContext: context,
      ),
    );
  }

  Widget _siparisListesi(String durum) {
    final filtreli = siparisler.where((s) => s['durum'] == durum).toList();
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
                    s['img'] ?? 'assets/images/sandwich.png',
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
                                  s['urun'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '₺${s['tutar'] ?? ''}',
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
                                s['siparisNo'] ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                s['tarih'] ?? '',
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
                              onPressed: () =>
                                  siparisiTamamla(siparisler.indexOf(s)),
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
    if (borclar.isEmpty) {
      return const Center(
        child: Text(
          'Borç yok',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }
    List<int> seciliIndexler = [];
    return StatefulBuilder(
      builder: (context, setStateSB) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: borclar.length,
                separatorBuilder: (context, index) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final b = borclar[index];
                  return Row(
                    children: [
                      Checkbox(
                        value: seciliIndexler.contains(index),
                        onChanged: (val) {
                          setStateSB(() {
                            if (val == true) {
                              seciliIndexler.add(index);
                            } else {
                              seciliIndexler.remove(index);
                            }
                          });
                        },
                        activeColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Expanded(
                        child: Text(
                          b['urun'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        '+₺${b['tutar'] ?? ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₺${borclar.fold(0.0, (sum, b) => sum + (b['tutar'] as num)).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                ElevatedButton(
                  onPressed: seciliIndexler.isNotEmpty
                      ? () async {
                          await borcOde(seciliIndexler);
                          setStateSB(() => seciliIndexler.clear());
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Ödeme Yap'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _bildirimler() {
    // Bildirimler için örnek veri
    final bildirimler = [
      {
        'baslik': 'Çay Ocağı Siparişi',
        'tarih': '11/03/2024 11:53',
        'icerik':
            'Hesabınız üzerinden #4456 numaralı çay siparişi sisteme girdi.',
      },
      {
        'baslik': 'Kantin Siparişi',
        'tarih': '11/03/2024 11:53',
        'icerik': 'Hesabınız üzerinden #4455 numaralı ürün siparişi alındı.',
      },
      {
        'baslik': 'Çay Ocağı Siparişi',
        'tarih': '11/03/2024 11:53',
        'icerik':
            'Hesabınız üzerinden #4452 numaralı çay siparişi sisteme girdi.',
      },
      {
        'baslik': 'Kantin Siparişi',
        'tarih': '11/03/2024 11:53',
        'icerik': 'Hesabınız üzerinden #4451 numaralı ürün siparişi alındı.',
      },
      {
        'baslik': 'Kantin Siparişi',
        'tarih': '11/03/2024 11:53',
        'icerik': 'Hesabınız üzerinden #4450 numaralı ürün siparişi alındı.',
      },
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bildirimler.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final b = bildirimler[index];
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
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            title: Text(
              b['baslik']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b['icerik']!, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 4),
                Text(
                  b['tarih']!,
                  style: const TextStyle(fontSize: 13, color: Colors.black45),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
