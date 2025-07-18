import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:e_kantin/components/custom_bottom_nav_bar.dart';
import 'admin_siparis.dart';
import 'admin_home_page.dart';
import '../models/user.dart';
import '../services/local_storage_service.dart';
import 'admin_cay_ocagi_page.dart';

class OzetSayfa extends StatefulWidget {
  const OzetSayfa({Key? key}) : super(key: key);

  @override
  State<OzetSayfa> createState() => _OzetSayfaState();
}

class _OzetSayfaState extends State<OzetSayfa> {
  int bekleyenSiparis = 0;
  int bitenSiparis = 0;
  double cayOcagiAlacagi = 0.0;
  int borcluListesi = 0;
  double totalKartGeliri = 19679.50;
  double toplamKantinGeliri = 0;
  double toplamGelir = 0.0;

  String selectedLokasyon = "Merkez Kantin";
  String selectedTarih = "Bugün";

  List<FlSpot> spots = [
    FlSpot(0, 3),
    FlSpot(1, 2),
    FlSpot(2, 5),
    FlSpot(3, 3.1),
    FlSpot(4, 4),
    FlSpot(5, 3),
    FlSpot(6, 4.5),
  ];

  @override
  void initState() {
    super.initState();
    _loadSiparisSayilari();
    _loadKantinGeliri();
    _loadBorcluListesi();
    _loadCayOcagiAlacagi();
    _loadToplamGelir();
  }

  Future<void> _loadSiparisSayilari() async {
    int aktif = 0;
    int pasif = 0;
    final usernames = await LocalStorageService.getAllUsernames();
    for (final username in usernames) {
      final orders = await LocalStorageService.getUserOrders(username);
      for (final s in orders) {
        if (s.durum == 'aktif') {
          aktif++;
        } else {
          pasif++;
        }
      }
    }
    setState(() {
      bekleyenSiparis = aktif;
      bitenSiparis = pasif;
    });
  }

  Future<void> _loadKantinGeliri() async {
    double toplam = 0;
    final usernames = await LocalStorageService.getAllUsernames();
    for (final username in usernames) {
      final orders = await LocalStorageService.getUserOrders(username);
      for (final s in orders) {
        if (s.durum == 'pasif') {
          toplam += s.tutar;
        }
      }
    }
    setState(() {
      toplamKantinGeliri = toplam;
    });
  }

  Future<void> _loadBorcluListesi() async {
    final count = await AdminCayOcagiPageState.borcluKullaniciSayisi();
    setState(() {
      borcluListesi = count;
    });
  }

  Future<void> _loadCayOcagiAlacagi() async {
    final borc = await AdminCayOcagiPageState.toplamCayOcagiBorcu();
    setState(() {
      cayOcagiAlacagi = borc;
    });
  }

  Future<void> _loadToplamGelir() async {
    final cayOcagiSiparis =
        await AdminCayOcagiPageState.toplamCayOcagiSiparisTutari();
    final cayOcagiBorc = await AdminCayOcagiPageState.toplamCayOcagiBorcu();
    setState(() {
      toplamGelir = toplamKantinGeliri + (cayOcagiSiparis - cayOcagiBorc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Geri butonu
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AdminHomePage(user: UserSingleton().user!),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Özet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Üst başlık ve sağda tarih dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Merkez Kantin",
                      style: TextStyle(
                        color: Color(0xFFFF3D3D),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                    Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFE0E0E0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedTarih,
                          items: const [
                            DropdownMenuItem(
                              value: "Bugün",
                              child: Text("Bugün"),
                            ),
                            DropdownMenuItem(value: "Dün", child: Text("Dün")),
                            DropdownMenuItem(
                              value: "Bu Hafta",
                              child: Text("Bu Hafta"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedTarih = value;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                            size: 20,
                          ),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Sayılar tablosu (Grid)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 1.4,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminSiparis(),
                            settings: RouteSettings(arguments: 0),
                          ),
                        );
                      },
                      child: _buildStatCard(
                        '$bekleyenSiparis',
                        'BEKLEYEN\nSİPARİŞ',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminSiparis(),
                            settings: RouteSettings(arguments: 1),
                          ),
                        );
                      },
                      child: _buildStatCard('$bitenSiparis', 'BİTEN SİPARİŞ'),
                    ),
                    _buildStatCard(
                      '₺${cayOcagiAlacagi.toStringAsFixed(2)}',
                      'ÇAY OCAĞI\nALACAĞI',
                    ),
                    _buildStatCard('$borcluListesi', 'BORÇLU LİSTESİ'),
                  ],
                ),
                const SizedBox(height: 18),
                // Toplam Kart Geliri Kartı ve Grafik
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Kart Geliri',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₺${totalKartGeliri.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 120,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              int spotIndex = 3; // Ortadaki spot
                              final spot = spots[spotIndex];
                              double chartWidth = constraints.maxWidth;
                              double chartHeight = 80;
                              double yMax = 10;
                              double yMin = 0;
                              double xPos =
                                  (spot.x / (spots.length - 1)) * chartWidth;
                              double yPos =
                                  (1 - (spot.y - yMin) / (yMax - yMin)) *
                                      chartHeight +
                                  10;
                              double balonWidth = 56;
                              double balonHeight = 28;
                              double balonLeft = xPos - balonWidth / 2;
                              if (balonLeft < 0) balonLeft = 0;
                              if (balonLeft + balonWidth > chartWidth)
                                balonLeft = chartWidth - balonWidth;

                              // Balonun ve dot'un konumları:
                              double balonTop = yPos - balonHeight - 16;
                              double dotTop = yPos;

                              // Çizgi yüksekliği:
                              double lineHeight =
                                  dotTop - (balonTop + balonHeight);

                              return Stack(
                                children: [
                                  LineChart(
                                    LineChartData(
                                      gridData: const FlGridData(show: false),
                                      titlesData: FlTitlesData(
                                        leftTitles: const AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        rightTitles: const AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        topTitles: const AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 30,
                                            getTitlesWidget: (value, meta) {
                                              const style = TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              );
                                              Widget text;
                                              switch (value.toInt()) {
                                                case 0:
                                                  text = Text(
                                                    '10AM',
                                                    style: style,
                                                  );
                                                  break;
                                                case 1:
                                                  text = Text(
                                                    '11AM',
                                                    style: style,
                                                  );
                                                  break;
                                                case 2:
                                                  text = Text(
                                                    '12PM',
                                                    style: style,
                                                  );
                                                  break;
                                                case 3:
                                                  text = Text(
                                                    '01PM',
                                                    style: style,
                                                  );
                                                  break;
                                                case 4:
                                                  text = Text(
                                                    '02PM',
                                                    style: style,
                                                  );
                                                  break;
                                                case 5:
                                                  text = Text(
                                                    '03PM',
                                                    style: style,
                                                  );
                                                  break;
                                                case 6:
                                                  text = Text(
                                                    '04PM',
                                                    style: style,
                                                  );
                                                  break;
                                                default:
                                                  text = const Text(
                                                    '',
                                                    style: style,
                                                  );
                                                  break;
                                              }
                                              return SideTitleWidget(
                                                axisSide: meta.axisSide,
                                                child: text,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: spots,
                                          isCurved: true,
                                          barWidth: 3,
                                          color: Colors.orange,
                                          dotData: const FlDotData(show: false),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color: Colors.orange.withOpacity(
                                              0.18,
                                            ),
                                          ),
                                        ),
                                      ],
                                      minX: 0,
                                      maxX: (spots.length - 1).toDouble(),
                                      minY: 0,
                                      maxY: 10,
                                      lineTouchData: LineTouchData(
                                        enabled: false,
                                      ),
                                    ),
                                  ),
                                  // Çizgi: balonun altından dot'un üstüne
                                  Positioned(
                                    left: xPos - 1,
                                    top: balonTop + balonHeight,
                                    child: Container(
                                      width: 2,
                                      height: lineHeight > 0 ? lineHeight : 0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Beyaz dot
                                  Positioned(
                                    left: xPos - 8,
                                    top: yPos,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.orange,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Balon
                                  Positioned(
                                    left: balonLeft,
                                    top: balonTop,
                                    child: Container(
                                      width: balonWidth,
                                      height: balonHeight,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '₺${spot.y.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // Menü Düzenle ve Ürün Düzenle butonları
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB300),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Menü\nDüzenle',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2AD2C9),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Ürün\nDüzenle',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // Alt navigation bar
      bottomNavigationBar: _AdminBottomNavBar(),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        height: 112, // Yüksekliği artırdım
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22, // 2pt küçültüldü (24 -> 22)
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ), // 2pt küçültüldü (13 -> 11)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const selectedColor = Color(0xFFFF3D3D);
    const unselectedColor = Color(0xFFBDBDBD);
    const indicatorColor = Colors.black;
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
            selected: true,
          ),
          _NavBarItem(
            icon: Icons.favorite_border,
            label: 'Favorilerim',
            selected: false,
          ),
          _NavBarItem(
            icon: Icons.notifications_none_outlined,
            label: 'Sepetim',
            selected: false,
          ),
          _NavBarItem(
            icon: Icons.person_outline,
            label: 'Siparişlerim',
            selected: false,
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
