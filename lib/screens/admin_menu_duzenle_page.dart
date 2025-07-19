import 'package:flutter/material.dart';
import '../services/local_menu_service.dart';
import '../services/sandwich_service.dart';
import '../services/tost_service.dart';
import 'dart:io';
import 'menu_olustur_page.dart';

class AdminMenuDuzenlePage extends StatefulWidget {
  @override
  _AdminMenuDuzenlePageState createState() => _AdminMenuDuzenlePageState();
}

class _AdminMenuDuzenlePageState extends State<AdminMenuDuzenlePage> {
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
                'desc': menu.desc,
                'price': menu.price,
                'stock': menu.aktif,
                'isLocal': true,
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
              return Container(
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: menu['image'].toString().startsWith('assets/')
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
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, top: 18.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Düzenle sayfasına git
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
                  ],
                ),
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
