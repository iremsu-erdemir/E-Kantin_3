import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/favorite_menu.dart';
import '../providers/favorite_provider.dart';

class MenuOlusturPage extends StatefulWidget {
  const MenuOlusturPage({Key? key}) : super(key: key);

  @override
  State<MenuOlusturPage> createState() => _MenuOlusturPageState();
}

class _MenuOlusturPageState extends State<MenuOlusturPage> {
  File? _image;
  final _menuNameController = TextEditingController(text: 'Menü 21');
  final _priceController = TextEditingController(text: '₺50,00');
  bool _aktif = true;
  String _ekmekTipi = 'Tost';
  List<String> _malzemeler = [
    'Az Kaşar Peynir',
    'Tam Kaşar Peynir',
    'Az Çeçil Peynir',
    'Tam Çeçil Peynir',
  ];
  List<bool> _malzemeSecili = [true, false, false, false];

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Menü Giriş',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/sandwichMenu.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MENÜ ADI',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _menuNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FİYAT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: _priceController,
                          enabled: _aktif,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _aktif,
                            onChanged: (val) => setState(() => _aktif = true),
                            activeColor: const Color(0xFFFF3D3D),
                          ),
                          const Text('Aktif', style: TextStyle(fontSize: 13)),
                          Checkbox(
                            value: !_aktif,
                            onChanged: (val) => setState(() => _aktif = false),
                            activeColor: Colors.grey,
                          ),
                          const Text('Pasif', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'İÇİNDEKİLER',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Radio<String>(
                    value: 'Tost',
                    groupValue: _ekmekTipi,
                    onChanged: (val) => setState(() => _ekmekTipi = val!),
                    activeColor: const Color(0xFFFF3D3D),
                  ),
                  const Text('Tost'),
                  const SizedBox(width: 16),
                  Radio<String>(
                    value: 'Sandviç',
                    groupValue: _ekmekTipi,
                    onChanged: (val) => setState(() => _ekmekTipi = val!),
                    activeColor: const Color(0xFFFF3D3D),
                  ),
                  const Text('Sandviç'),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _malzemeler.length,
                itemBuilder: (context, i) {
                  return Row(
                    children: [
                      Checkbox(
                        value: _malzemeSecili[i],
                        onChanged: (val) =>
                            setState(() => _malzemeSecili[i] = val!),
                        activeColor: const Color(0xFFFF3D3D),
                      ),
                      Expanded(
                        child: Text(
                          _malzemeler[i],
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const Text(
                        '+₺5,50',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Seçili malzemeleri al
                    final seciliIcerikler = <String>[];
                    for (int i = 0; i < _malzemeler.length; i++) {
                      if (_malzemeSecili[i])
                        seciliIcerikler.add(_malzemeler[i]);
                    }
                    // FavoriteMenu oluştur
                    final yeniMenu = FavoriteMenu(
                      name: _menuNameController.text,
                      isCeyrek: _ekmekTipi == 'Tost',
                      isTam: _ekmekTipi == 'Sandviç',
                      ekmekTipi: _ekmekTipi,
                      ekmekTuru: '', // Eğer ekmek türü seçiliyorsa buraya ekle
                      secilenIcerikler: seciliIcerikler,
                      imagePath: _image != null
                          ? _image!.path
                          : 'assets/images/sandwichMenu.png',
                      price:
                          double.tryParse(
                            _priceController.text
                                .replaceAll('₺', '')
                                .replaceAll(',', '.'),
                          ) ??
                          0.0,
                    );
                    Provider.of<FavoriteProvider>(
                      context,
                      listen: false,
                    ).addFavorite(yeniMenu);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3D3D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Kaydet',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF3D3D),
        unselectedItemColor: Colors.black38,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorilerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Sepetim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Siparişlerim',
          ),
        ],
        currentIndex: 0,
        onTap: (_) {},
      ),
    );
  }
}
