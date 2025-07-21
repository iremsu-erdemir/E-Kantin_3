import 'package:flutter/material.dart';
import '../components/ek_bottom_nav_bar.dart';
import 'payment.dart';
import 'home_page.dart';
import '../models/user.dart';

class SepetimPage extends StatefulWidget {
  final Map<String, String>? yeniSiparis;
  const SepetimPage({Key? key, this.yeniSiparis}) : super(key: key);

  @override
  State<SepetimPage> createState() => _SepetimPageState();
}

class _SepetimPageState extends State<SepetimPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool showBorcDialog = false;
  double kalanBorcDialog = 0.0;

  // Siparişler için state
  List<Map<String, String>> aktifSiparisler = [];
  List<Map<String, String>> teslimEdilenSiparisler = [];

  // Çay ocağı borcu için state
  List<Map<String, dynamic>> cayBorclari = [
    {'isim': 'Küçük Çay', 'tutar': 5.5, 'selected': false},
    {'isim': 'Büyük Çay', 'tutar': 5.5, 'selected': false},
    {'isim': 'Türk Kahvesi', 'tutar': 5.5, 'selected': false},
    {'isim': 'Nescafe', 'tutar': 5.5, 'selected': false},
    {'isim': 'Sakızlı', 'tutar': 5.5, 'selected': false},
    {'isim': 'Sade Soda', 'tutar': 5.5, 'selected': false},
    {'isim': 'Probis', 'tutar': 5.5, 'selected': false},
  ];

  double get toplamSeciliCayBorcu => cayBorclari
      .where((b) => b['selected'] == true)
      .fold(0.0, (sum, b) => sum + (b['tutar'] as double));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Sadece SuccessPaymentPage'den gelen yeniSiparis varsa ekle
    if (widget.yeniSiparis != null &&
        widget.yeniSiparis!['title'] != 'Çay Ocağı Borcu') {
      aktifSiparisler.add(widget.yeniSiparis!);
    }
  }

  void siparisiTeslimEt(int index) {
    setState(() {
      teslimEdilenSiparisler.add(aktifSiparisler[index]);
      aktifSiparisler.removeAt(index);
    });
  }

  void yeniSiparisEkle(Map<String, String> siparis) {
    setState(() {
      aktifSiparisler.add(siparis);
    });
  }

  void caySeciminiDegistir(int index, bool? value) {
    setState(() {
      cayBorclari[index]['selected'] = value ?? false;
    });
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
                Tab(text: 'Borçlarım'),
                Tab(text: 'Bildirimler'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _aktifSiparislerim(),
          _pasifSiparislerim(),
          _cayOcagiBorcu(),
          _bildirimler(),
        ],
      ),
      bottomNavigationBar: EKBottomNavBar(
        currentIndex: 2,
        parentContext: context,
      ),
    );
  }

  Widget _aktifSiparislerim() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: aktifSiparisler.length,
      itemBuilder: (context, index) {
        final s = aktifSiparisler[index];
        return Column(
          children: [
            _siparisCard(
              s['title']!,
              s['no']!,
              s['img']!,
              s['price']!,
              s['date']!,
              teslimButon: () => siparisiTeslimEt(index),
            ),
          ],
        );
      },
    );
  }

  Widget _pasifSiparislerim() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: teslimEdilenSiparisler.length,
      itemBuilder: (context, index) {
        final s = teslimEdilenSiparisler[index];
        return _siparisCard(
          s['title']!,
          s['no']!,
          s['img']!,
          s['price']!,
          s['date']!,
        );
      },
    );
  }

  Widget _cayOcagiBorcu() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Çay Ocağı Ürünleri',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: cayBorclari.length,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final b = cayBorclari[index];
                return Row(
                  children: [
                    Checkbox(
                      value: b['selected'],
                      onChanged: (val) => caySeciminiDegistir(index, val),
                      activeColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Expanded(
                      child: Text(
                        b['isim'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      '+₺${(b['tutar'] as double).toStringAsFixed(2)}',
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
                '₺${cayBorclari.fold(0.0, (sum, b) => sum + (b['tutar'] as double)).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              ElevatedButton(
                onPressed: toplamSeciliCayBorcu > 0
                    ? () async {
                        final toplamBorc = cayBorclari.fold(
                          0.0,
                          (sum, b) => sum + (b['tutar'] as double),
                        );
                        final kalanBorc = toplamBorc - toplamSeciliCayBorcu;
                        final seciliIndexler = cayBorclari
                            .asMap()
                            .entries
                            .where((e) => e.value['selected'] == true)
                            .map((e) => e.key)
                            .toList();
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(
                              totalPrice: toplamSeciliCayBorcu,
                              isCayOcagiBorcu: true,
                              kalanBorc: kalanBorc,
                            ),
                          ),
                        );
                        if (result == 'odeme_basarili') {
                          setState(() {
                            showBorcDialog = false;
                            kalanBorcDialog = kalanBorc;
                            // Seçili borçları sil
                            seciliIndexler.reversed.forEach(
                              (i) => cayBorclari.removeAt(i),
                            );
                          });
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
      ),
    );
  }

  Widget _bildirimler() {
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

  Widget _siparisCard(
    String title,
    String no,
    String img,
    String price,
    String date, {
    VoidCallback? teslimButon,
  }) {
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
              child: Image.asset(img, width: 56, height: 56, fit: BoxFit.cover),
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
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              price,
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
                            no,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (teslimButon != null)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                          onPressed: teslimButon,
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
  }
}
