import 'package:flutter/material.dart';
import '../models/siparis.dart';
import '../services/local_storage_service.dart';
import 'admin_home_page.dart';

class AdminSiparis extends StatefulWidget {
  final int initialTab;
  const AdminSiparis({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<AdminSiparis> createState() => _AdminSiparisState();
}

class _AdminSiparisState extends State<AdminSiparis>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Siparis> aktifSiparisler = [];
  List<Siparis> pasifSiparisler = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    int initialTab = widget.initialTab;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialTab,
    );
    _loadAllOrders();
  }

  Future<void> _loadAllOrders() async {
    setState(() => loading = true);
    List<Siparis> aktif = [];
    List<Siparis> pasif = [];
    final usernames = await LocalStorageService.getAllUsernames();
    for (final username in usernames) {
      final orders = await LocalStorageService.getUserOrders(username);
      for (final s in orders) {
        if (s.durum == 'aktif') {
          aktif.add(s);
        } else {
          pasif.add(s);
        }
      }
    }
    // Siparişleri tarihe göre azalan sırala (en yeni en üstte)
    aktif.sort((a, b) => b.kayitTarihi.compareTo(a.kayitTarihi));
    pasif.sort((a, b) => b.kayitTarihi.compareTo(a.kayitTarihi));
    setState(() {
      aktifSiparisler = aktif;
      pasifSiparisler = pasif;
      loading = false;
    });
  }

  Future<void> _siparisiTamamla(Siparis siparis) async {
    // İlgili kullanıcının siparişini pasif yap
    final usernames = await LocalStorageService.getAllUsernames();
    for (final username in usernames) {
      final orders = await LocalStorageService.getUserOrders(username);
      for (final s in orders) {
        if (s.id == siparis.id) {
          await LocalStorageService.markAsDelivered(username, s.id);
          break;
        }
      }
    }
    await _loadAllOrders();
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
          'Siparişler',
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
                Tab(text: 'Bekleyen'),
                Tab(text: 'Tamamlanan'),
              ],
            ),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSiparisList(aktifSiparisler, aktif: true),
                _buildSiparisList(pasifSiparisler, aktif: false),
              ],
            ),
      bottomNavigationBar: _AdminBottomNavBar(),
    );
  }

  Widget _buildSiparisList(List<Siparis> siparisler, {required bool aktif}) {
    if (siparisler.isEmpty) {
      return const Center(
        child: Text(
          'Sipariş yok',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      itemCount: siparisler.length,
      itemBuilder: (context, index) {
        final s = siparisler[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    s.img,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  s.urun,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F3F3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '#${s.siparisNo}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF3D3D),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₺${s.tutar}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            s.tarih,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFBDBDBD),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (aktif)
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () => _siparisiTamamla(s),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF3D3D),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text('Bitir'),
                              ),
                            ),
                        ],
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
}

class _AdminBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const selectedColor = Color(0xFFFF3D3D);
    const unselectedColor = Color(0xFFBDBDBD);
    const indicatorColor = Colors.black;
    final currentIndex = 3; // Siparişlerim aktif
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
            icon: Icons.notifications_none_outlined,
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
