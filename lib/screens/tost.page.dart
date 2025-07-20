import 'package:flutter/material.dart';
import '../models/tost.dart';
import '../services/tost_service.dart';
import '../services/local_menu_service.dart';
import '../components/ek_bottom_nav_bar.dart';
import 'favorilerim.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'sandwich_detail.page.dart';
import '../models/menu_model.dart';

class TostPage extends StatelessWidget {
  const TostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> bottomIcons = [
      'home.png',
      'wishlist.png',
      'categories.png',
      'cart.png',
      'person.png',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tostlar',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          LocalMenuService.getMenus(),
          TostService().fetchTostlar(),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final localMenus = snapshot.data![0] as List<MenuModel>;
          final tostlar = snapshot.data![1] as List<Tost>;
          final allMenus = [
            ...localMenus
                .where((menu) => menu.ekmekTipi == 'Tost')
                .map(
                  (menu) => {
                    'image': menu.imagePath,
                    'title': menu.name,
                    'desc': menu.urunler.map((u) => u.name).join(', '),
                    'price': menu.urunler.isNotEmpty
                        ? menu.urunler[0].price
                        : '',
                    'stock': menu.aktif,
                    'isLocal': true,
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
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: allMenus.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
            itemBuilder: (context, index) {
              final item = allMenus[index];
              return GestureDetector(
                onTap: () async {
                  if (item['isLocal'] == true && !(item['stock'] as bool)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ürün tükendi'),
                        duration: Duration(milliseconds: 900),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (!(item['stock'] as bool)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ürün tükenmiştir'),
                        duration: Duration(milliseconds: 900),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (item['isLocal'] == true) {
                    // Menü düzenleme sayfası açılırsa ve ürün eklenirse güncelle
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SandwichDetailPage(
                          imagePath: item['image'].toString(),
                          title: item['title'].toString(),
                          desc: item['desc'].toString(),
                          price: item['price'].toString(),
                          stock: item['stock'] as bool,
                        ),
                      ),
                    );
                    if (result == true) (context as Element).markNeedsBuild();
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SandwichDetailPage(
                          imagePath: item['image'].toString(),
                          title: item['title'].toString(),
                          desc: item['desc'].toString(),
                          price: item['price'].toString(),
                          stock: item['stock'] as bool,
                        ),
                      ),
                    );
                  }
                },
                child: Opacity(
                  opacity: (item['stock'] as bool) ? 1.0 : 0.4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: item['image'].toString().startsWith('assets/')
                              ? Image.asset(
                                  item['image'].toString(),
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(item['image'].toString()),
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
                              Text(
                                item['title'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['desc'].toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    item['price'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  if (!(item['stock'] as bool))
                                    const Text(
                                      'Tükendi',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
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
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: EKBottomNavBar(
        currentIndex: 0,
        parentContext: context,
      ),
    );
  }
}
