import 'package:flutter/material.dart';
import '../services/local_menu_service.dart';
import '../services/sandwich_service.dart';
import '../services/tost_service.dart';
import 'dart:io';
import 'menu_olustur_page.dart';
import 'menu_urun_duzenle_page.dart';
import '../models/menu_model.dart';
import '../models/urun_model.dart';

class AdminMenuDuzenlePage extends StatefulWidget {
  @override
  _AdminMenuDuzenlePageState createState() => _AdminMenuDuzenlePageState();
}

class _AdminMenuDuzenlePageState extends State<AdminMenuDuzenlePage> {
  @override
  void initState() {
    super.initState();
    // Otomatik menü silme kodu kaldırıldı
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Menü Düzenle',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: false,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          LocalMenuService.getMenus(),
          SandwichService().fetchSandwiches(),
          TostService().fetchTostlar(),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final localMenus = snapshot.data![0] as List<MenuModel>;
          final sandwiches = snapshot.data![1];
          final tostlar = snapshot.data![2];
          final allMenus = [
            ...localMenus.reversed.map(
              (menu) => {
                'image': menu.imagePath,
                'title': menu.name,
                'desc': menu.urunler.map((u) => u.name).join(', '),
                'price': menu.urunler.isNotEmpty ? menu.urunler[0].price : '',
                'stock': menu.urunler.isNotEmpty
                    ? menu.urunler[0].stoktaVar
                    : true,
                'isLocal': true,
                'urunler': menu.urunler,
              },
            ),
            ...sandwiches.map(
              (item) => {
                'image': item.image,
                'title': item.title,
                'desc': item.desc,
                'price': item.price,
                'stock': item.stock,
                'isLocal': false,
              },
            ),
            ...tostlar.map(
              (item) => {
                'image': item.image,
                'title': item.title,
                'desc': item.desc,
                'price': item.price,
                'stock': item.stock,
                'isLocal': false,
              },
            ),
          ];
          if (allMenus.isEmpty) {
            return Center(
              child: Text(
                "Hiç menü yok.Yeni Menü Ekle ile menü ekleyin.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            itemCount: allMenus.length,
            itemBuilder: (context, index) {
              final menu = allMenus[index];
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child:
                                    menu['image'].toString().startsWith(
                                      'assets/',
                                    )
                                    ? Image.asset(
                                        menu['image'].toString(),
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(menu['image'].toString()),
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 2),
                                    Text(
                                      menu['price'].toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(0xFF2AD2C9),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      menu['title'].toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      menu['desc'].toString(),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 12.0,
                            left: 12.0,
                            bottom: 12.0,
                            top: 4.0,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (menu['isLocal'] == true) {
                                  final localMenu = localMenus.firstWhere(
                                    (m) => m.name == menu['title'],
                                  );
                                  if (localMenu != null) {
                                    final urunler = localMenu.urunler
                                        .map(
                                          (icerik) => {
                                            'name': icerik.name,
                                            'price':
                                                double.tryParse(
                                                  icerik.price
                                                      .replaceAll('₺', '')
                                                      .replaceAll(',', '.'),
                                                ) ??
                                                0.0,
                                            'stoktaVar': icerik.stoktaVar,
                                          },
                                        )
                                        .toList();
                                    final result = await Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MenuUrunDuzenlePage(
                                                  menuName: localMenu.name,
                                                  urunler: urunler,
                                                ),
                                          ),
                                        );
                                    if (result == true) setState(() {});
                                  }
                                } else {
                                  // Servis menüleri için desc'yi ürün listesi olarak kullan
                                  final desc = menu['desc']?.toString() ?? '';
                                  final urunAdlari = desc
                                      .split(',')
                                      .map((e) => e.trim())
                                      .where((e) => e.isNotEmpty)
                                      .toList();
                                  final urunler = urunAdlari
                                      .map(
                                        (icerik) => {
                                          'name': icerik,
                                          'price':
                                              double.tryParse(
                                                menu['price']
                                                    .toString()
                                                    .replaceAll('₺', '')
                                                    .replaceAll(',', '.'),
                                              ) ??
                                              0.0,
                                          'stoktaVar': menu['stock'] ?? true,
                                        },
                                      )
                                      .toList();
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MenuUrunDuzenlePage(
                                        menuName: menu['title'].toString(),
                                        urunler: urunler,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF3D3D),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Düzenle',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await LocalMenuService.deleteMenusByNames([
                          menu['title'],
                        ]);
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${menu['title']} silindi'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.all(16),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MenuOlusturPage()),
              );
              if (result == true) {
                setState(() {
                  // Bu sayfa yeniden build edilecek ve yeni menüler yüklenecek
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3D3D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Text(
              '+ Yeni Menü Ekle',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
