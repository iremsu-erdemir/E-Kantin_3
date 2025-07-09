import 'package:flutter/material.dart';
import 'home_page.dart';

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
                          onPressed: () {},
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
