import 'package:flutter/material.dart';
import '../components/ek_bottom_nav_bar.dart';
import '../models/user.dart';
import 'home_page.dart';
import 'admin_home_page.dart';
import '../models/user_card.dart';
import '../services/user_card_service.dart';
import 'card_list_page.dart';
import 'ozet_sayfa.dart';
import 'admin_siparis.dart';
import 'admin_cay_ocagi_page.dart';
import 'menu_olustur_page.dart';
import 'admin_menu_duzenle_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = UserSingleton().user;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            if (user?.role?.contains('Şube Müdürü') == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminHomePage(user: user!),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage(user: user!)),
              );
            }
          },
        ),
        title: const Text(
          'Ayarlar',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Kullanıcı Bilgisi
            Column(
              children: [
                // Kullanıcı resmi
                if (user?.image != null && user!.image!.isNotEmpty)
                  (user!.image!.startsWith('http')
                      ? CircleAvatar(
                          radius: 44,
                          backgroundImage: NetworkImage(user!.image!),
                        )
                      : CircleAvatar(
                          radius: 44,
                          backgroundImage: AssetImage(user!.image!),
                        ))
                else
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: Color(0xFFE0D7F8),
                    child: Icon(Icons.person, size: 48, color: Colors.white),
                  ),
                const SizedBox(height: 12),
                Text(
                  user?.name ?? 'Kullanıcı Adı',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.role ?? 'Kullanıcı Rolü',
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Ayarlar başlığı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: const Text(
                'Ayarlar',
                style: TextStyle(
                  color: Color(0xFFFF3D3D),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            _SettingsTile(
              icon: Icons.credit_card,
              title: 'Kayıtlı Kartlarım',
              onTap: () async {
                final cards = await UserCardService.getCards();
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OdemeKartiYonetimPage(),
                    ),
                  );
                }
              },
            ),
            // Yönetim başlığı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: const Text(
                'Yönetim',
                style: TextStyle(
                  color: Color(0xFFFF3D3D),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            _SettingsTile(
              icon: Icons.show_chart,
              title: 'Özet Sayfa',
              onTap: () {
                if (user?.username == 'turgay') {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => OzetSayfa()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Bunlara erişme yetkiniz yok, sadece yönetici erişebilir.',
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
            _SettingsTile(
              icon: Icons.receipt_long,
              title: 'Siparişler',
              onTap: () {
                if (user?.username == 'turgay') {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => AdminSiparis()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Bunlara erişme yetkiniz yok, sadece yönetici erişebilir.',
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
            _SettingsTile(
              icon: Icons.coffee,
              title: 'Çay Ocakları',
              onTap: () {
                if (user?.username == 'turgay') {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AdminCayOcagiPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Bunlara erişme yetkiniz yok, sadece yönetici erişebilir.',
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
            _SettingsTile(
              icon: Icons.add_box,
              title: 'Menü Ekle',
              onTap: () {
                if (user?.username == 'turgay') {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => MenuOlusturPage()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Bunlara erişme yetkiniz yok, sadece yönetici erişebilir.',
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
            _SettingsTile(
              icon: Icons.add_circle_outline,
              title: 'Ürün Ekle',
              onTap: () {
                if (user?.username == 'turgay') {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AdminMenuDuzenlePage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Bunlara erişme yetkiniz yok, sadece yönetici erişebilir.',
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: EKBottomNavBar(
        currentIndex: 4,
        parentContext: context,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black38),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      shape: const Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
    );
  }
}
