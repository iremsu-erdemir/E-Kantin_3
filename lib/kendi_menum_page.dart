import 'package:e_kantin/favorilerim.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'models/favorite_menu.dart';
import 'cart.dart';
import 'models/cart.dart';
import 'providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartSingleton {
  static final CartSingleton _instance = CartSingleton._internal();
  factory CartSingleton() => _instance;
  CartSingleton._internal();
  final List<CartItem> items = [];
}

class KendiMenumPage extends StatefulWidget {
  const KendiMenumPage({Key? key}) : super(key: key);

  @override
  State<KendiMenumPage> createState() => _KendiMenumPageState();
}

class _KendiMenumPageState extends State<KendiMenumPage> {
  bool isCeyrek = true;
  bool isTam = false;
  String ekmekTipi = 'Tost';
  String ekmekTuru = 'Normal';
  List<String> icerikler = [
    'Az Kaşar Peynir',
    'Tam Kaşar Peynir',
    'Az Çeçil Peynir',
    'Tam Beyaz Peynir',
  ];
  List<bool> icerikSecili = [true, false, false, false];
  List<bool> icerikEnabled = [true, true, true, false];
  List<String> icerikFiyat = ['+₺5,50', '+₺5,50', '+₺5,50', 'Tükendi'];

  double get totalPrice => 85.5;
  int _selectedIndex = 0;
  List<FavoriteMenu> favoriListesi = [];
  // İçindekiler için seçili indexi tutan bir değişken ekle
  int? seciliIcerikIndex = 0;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Kendi Menü',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 19,
            // textAlign: TextAlign.left, // Gerekirse eklenebilir
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.redAccent,
              size: 28,
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.3),
                builder: (context) {
                  final TextEditingController _favController =
                      TextEditingController();
                  return Center(
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 320,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 28,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Favorilere Eklemek\nİster misiniz ?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextField(
                              controller: _favController,
                              decoration: InputDecoration(
                                hintText: 'İsim Yazınız...',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Colors.red,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.close, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text(
                                          "Hayır",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Colors.green,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (_favController.text.trim().isEmpty)
                                        return;
                                      final yeniFavori = FavoriteMenu(
                                        name: _favController.text.trim(),
                                        isCeyrek: isCeyrek,
                                        isTam: isTam,
                                        ekmekTipi: ekmekTipi,
                                        ekmekTuru: ekmekTuru,
                                        secilenIcerikler:
                                            seciliIcerikIndex != null
                                            ? [icerikler[seciliIcerikIndex!]]
                                            : [],
                                        imagePath: ekmekTipi == 'Tost'
                                            ? 'assets/images/tost.png'
                                            : 'assets/images/sandwich.png',
                                      );
                                      setState(() {
                                        favoriListesi.add(yeniFavori);
                                      });
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            'Favorilere başarıyla eklendi!',
                                          ),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          duration: const Duration(
                                            milliseconds: 900,
                                          ), // Süreyi kısalttık
                                        ),
                                      );
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check, color: Colors.green),
                                        SizedBox(width: 8),
                                        Text(
                                          "Evet",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Ekmek Seçimi için radio butonlar:
            const Text(
              'Ekmek Seçimi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Radio<String>(
                  value: 'Çeyrek',
                  groupValue: isCeyrek ? 'Çeyrek' : 'Tam',
                  onChanged: (val) {
                    setState(() {
                      isCeyrek = val == 'Çeyrek';
                      isTam = val == 'Tam';
                    });
                  },
                  activeColor: Colors.redAccent,
                ),
                const Text('Çeyrek Ekmek'),
                const Spacer(),
                const Text('+₺5,50', style: TextStyle(color: Colors.black54)),
              ],
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'Tam',
                  groupValue: isCeyrek ? 'Çeyrek' : 'Tam',
                  onChanged: (val) {
                    setState(() {
                      isCeyrek = val == 'Çeyrek';
                      isTam = val == 'Tam';
                    });
                  },
                  activeColor: Colors.redAccent,
                ),
                const Text('Tam Ekmek'),
                const Spacer(),
                const Text('+₺11,00', style: TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Radio<String>(
                  value: 'Tost',
                  groupValue: ekmekTipi,
                  onChanged: (val) {
                    setState(() {
                      ekmekTipi = val!;
                    });
                  },
                  activeColor: Colors.redAccent,
                ),
                const Text('Tost'),
                const SizedBox(width: 24),
                Radio<String>(
                  value: 'Sandviç',
                  groupValue: ekmekTipi,
                  onChanged: (val) {
                    setState(() {
                      ekmekTipi = val!;
                    });
                  },
                  activeColor: Colors.redAccent,
                ),
                const Text('Sandviç'),
              ],
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'Normal',
                  groupValue: ekmekTuru,
                  onChanged: (val) {
                    setState(() {
                      ekmekTuru = val!;
                    });
                  },
                  activeColor: Colors.redAccent,
                ),
                const Text('Normal'),
                const SizedBox(width: 24),
                Radio<String>(
                  value: 'Kepekli',
                  groupValue: ekmekTuru,
                  onChanged: (val) {
                    setState(() {
                      ekmekTuru = val!;
                    });
                  },
                  activeColor: Colors.redAccent,
                ),
                const Text('Kepekli'),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'İçindekiler',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...List.generate(icerikler.length, (i) {
              return Row(
                children: [
                  Radio<int>(
                    value: i,
                    groupValue: seciliIcerikIndex,
                    onChanged: icerikEnabled[i]
                        ? (val) {
                            setState(() {
                              seciliIcerikIndex = val;
                            });
                          }
                        : null,
                    activeColor: Colors.redAccent,
                  ),
                  Text(
                    icerikler[i],
                    style: TextStyle(
                      color: icerikEnabled[i] ? Colors.black : Colors.black38,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    icerikFiyat[i],
                    style: TextStyle(
                      color: icerikEnabled[i]
                          ? (icerikFiyat[i] == 'Tükendi'
                                ? Colors.red
                                : Colors.black54)
                          : Colors.black26,
                      fontWeight: icerikFiyat[i] == 'Tükendi'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
            const Spacer(),
            Row(
              children: [
                Text(
                  '₺${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () async {
                      String? menuName = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController();
                          return AlertDialog(
                            title: Text('Menü İsmi Girin'),
                            content: TextField(
                              controller: controller,
                              decoration: InputDecoration(hintText: 'Menü adı'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('İptal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (controller.text.trim().isNotEmpty) {
                                    Navigator.pop(
                                      context,
                                      controller.text.trim(),
                                    );
                                  }
                                },
                                child: Text('Ekle'),
                              ),
                            ],
                          );
                        },
                      );
                      if (menuName == null || menuName.isEmpty) return;

                      final cartProvider = Provider.of<CartProvider>(
                        context,
                        listen: false,
                      );
                      final newItem = CartItem(
                        id: menuName,
                        name: menuName,
                        imagePath: ekmekTipi == 'Tost'
                            ? 'assets/images/tost.png'
                            : 'assets/images/sandwichmenu.png',
                        price: totalPrice,
                        quantity: 1,
                      );
                      cartProvider.addOrUpdate(newItem);

                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => CartPage()));
                    },
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
                    ),
                    child: const Text('Sepete Ekle'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: EKBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FavorilerimPage(favoriler: favoriListesi),
              ),
            );
          }
        },
        icons: bottomIcons,
      ),
    );
  }
}
