import 'package:flutter/material.dart';
import 'home_page.dart';

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
                                      Navigator.of(context).pop();
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
            const Text(
              'Ekmek Seçimi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
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
                const Text('+₺5,50', style: TextStyle(color: Colors.black54)),
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
                  Checkbox(
                    value: icerikSecili[i],
                    onChanged: icerikEnabled[i]
                        ? (val) {
                            setState(() {
                              icerikSecili[i] = val!;
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
      bottomNavigationBar: EKBottomNavBar(
        selectedIndex: 0,
        icons: bottomIcons,
        onTap: (index) {},
      ),
    );
  }
}
