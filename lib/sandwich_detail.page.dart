import 'package:flutter/material.dart';
import 'home_page.dart';
import 'favorilerim.dart';
import 'cart.dart';
import 'models/cart.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

class CartSingleton {
  static final CartSingleton _instance = CartSingleton._internal();
  factory CartSingleton() => _instance;
  CartSingleton._internal();
  final List<CartItem> items = [];
}

class SandwichDetailPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String desc;
  final String price;
  const SandwichDetailPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.desc,
    required this.price,
  }) : super(key: key);

  @override
  State<SandwichDetailPage> createState() => _SandwichDetailPageState();
}

class _SandwichDetailPageState extends State<SandwichDetailPage> {
  bool isCeyrek = true;
  bool isTam = false;
  String ekmekTipi = 'Normal';

  double get totalPrice => 85.5 + (isCeyrek ? 5.5 : 0.0);

  void _showFavoriteDialog() {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 320,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
                    'Favorilere Eklemek\nİster misiniz ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'İsim Yazınız....',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.close, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Hayır',
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            final String isim = _controller.text.trim();
                            if (isim.isEmpty) return;
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FavorilerimPage(
                                  favoriler: [],
                                ), // örnek olarak boş liste
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                'Evet',
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
  }

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
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 19,
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
            onPressed: _showFavoriteDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.asset(widget.imagePath, fit: BoxFit.cover),
              ),
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.28)),
              ),
              Positioned(
                left: 16,
                bottom: 18,
                right: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.desc,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: 18,
                child: Text(
                  widget.price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ekmek Seçimi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: isCeyrek,
                        onChanged: (val) {
                          setState(() {
                            isCeyrek = val!;
                            if (isCeyrek) isTam = false;
                          });
                        },
                        activeColor: Colors.redAccent,
                      ),
                      const Text('Çeyrek Ekmek'),
                      const Spacer(),
                      Text(
                        '+₺5,50',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isTam,
                        onChanged: (val) {
                          setState(() {
                            isTam = val!;
                            if (isTam) isCeyrek = false;
                          });
                        },
                        activeColor: Colors.redAccent,
                      ),
                      const Text('Tam Ekmek'),
                      const Spacer(),
                      const Text(
                        '+₺0,00',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Normal',
                        groupValue: ekmekTipi,
                        onChanged: (val) {
                          setState(() {
                            ekmekTipi = val!;
                          });
                        },
                        activeColor: Colors.redAccent,
                      ),
                      const Text('Normal'),
                      const SizedBox(width: 24),
                      Radio<String>(
                        value: 'Kepekli',
                        groupValue: ekmekTipi,
                        onChanged: (val) {
                          setState(() {
                            ekmekTipi = val!;
                          });
                        },
                        activeColor: Colors.redAccent,
                      ),
                      const Text('Kepekli'),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        widget.price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            final cartProvider = Provider.of<CartProvider>(
                              context,
                              listen: false,
                            );
                            final newItem = CartItem(
                              id: widget.title,
                              name: widget.title,
                              imagePath: widget.imagePath,
                              price:
                                  double.tryParse(
                                    widget.price
                                        .replaceAll('₺', '')
                                        .replaceAll(',', '.'),
                                  ) ??
                                  0,
                              quantity: 1,
                            );
                            cartProvider.addOrUpdate(newItem);
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => CartPage()),
                            );
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
        ],
      ),
      bottomNavigationBar: EKBottomNavBar(
        selectedIndex: 0,
        icons: bottomIcons,
        onTap: (index) {},
      ),
    );
  }
}
