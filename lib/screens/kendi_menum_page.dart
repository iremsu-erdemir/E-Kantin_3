import 'package:e_kantin/screens/favorilerim.dart';
import 'package:flutter/material.dart';
import '../components/ek_bottom_nav_bar.dart';
import '../models/favorite_menu.dart';
import 'cart.dart';
import '../models/cart.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../models/user.dart';

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

  double get totalPrice {
    double base = 0.0;
    // Seçili içeriklerin fiyatlarını topla
    if (seciliIcerikIndex != null && icerikEnabled[seciliIcerikIndex!]) {
      final fiyatStr = icerikFiyat[seciliIcerikIndex!]
          .replaceAll('₺', '')
          .replaceAll('+', '')
          .replaceAll(',', '.')
          .replaceAll('Tükendi', '')
          .trim();
      final fiyat = double.tryParse(fiyatStr) ?? 0.0;
      base += fiyat;
    }
    // Eğer başka sabit ek ücretler varsa buraya eklenebilir
    return base;
  }

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
                useSafeArea: true,
                barrierLabel: '',
                builder: (context) {
                  final TextEditingController _favController =
                      TextEditingController();
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Text(
                      "Favorilere Eklemek\nİster misiniz ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    content: TextField(
                      controller: _favController,
                      decoration: const InputDecoration(
                        hintText: 'İsim Yazınız...',
                        hintStyle: TextStyle(color: Colors.black26),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Hayır',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_favController.text.trim().isNotEmpty) {
                            final yeniFavori = FavoriteMenu(
                              name: _favController.text.trim(),
                              isCeyrek: isCeyrek,
                              isTam: isTam,
                              ekmekTipi: ekmekTipi,
                              ekmekTuru: ekmekTuru,
                              secilenIcerikler: seciliIcerikIndex != null
                                  ? [icerikler[seciliIcerikIndex!]]
                                  : [],
                              imagePath: ekmekTipi == 'Tost'
                                  ? 'assets/images/tost.png'
                                  : 'assets/images/sandwich.png',
                              price: totalPrice,
                            );
                            Provider.of<FavoriteProvider>(
                              context,
                              listen: false,
                            ).addFavorite(yeniFavori);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Favorilere başarıyla eklendi!'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Evet',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  const Text(
                    '+₺11,00',
                    style: TextStyle(color: Colors.black54),
                  ),
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
              // Spacer yerine sabit SizedBox kullan
              const SizedBox(height: 24),
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
                        // Kullanıcı login kontrolü
                        if (UserSingleton().user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Lütfen giriş yapmadan önce bu işlemi gerçekleştiremezsiniz.',
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        }
                        // Stok kontrolü (örnek: seçili içerik tükenmişse)
                        if (seciliIcerikIndex != null &&
                            icerikFiyat[seciliIcerikIndex!] == 'Tükendi') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Bu ürün stokta kalmamıştır.'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        }
                        String? menuName = await showDialog<String>(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            final controller = TextEditingController();
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text('Menü İsmi Girin'),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  hintText: 'Menü adı',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('İptal'),
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
                                  child: const Text('Ekle'),
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
                              : 'assets/images/sandwichMenu.png',
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
      ),
      bottomNavigationBar: EKBottomNavBar(
        currentIndex: 0, // KendiMenumPage için uygun index
        parentContext: context,
      ),
    );
  }
}
