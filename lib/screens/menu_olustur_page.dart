import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/local_menu_service.dart';

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

  void _malzemeSec(int index) {
    setState(() {
      // Kaşar peynir kontrolü (index 0 ve 1)
      if (index == 0 || index == 1) {
        // Diğer kaşar peyniri seçimini kaldır
        _malzemeSecili[1 - index] = false;
      }
      // Çeçil peynir kontrolü (index 2 ve 3)
      else if (index == 2 || index == 3) {
        // Diğer çeçil peyniri seçimini kaldır
        _malzemeSecili[5 - index] = false;
      }
      // Seçilen malzemeyi toggle et
      _malzemeSecili[index] = !_malzemeSecili[index];
    });
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera ile çek'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (picked != null) {
                    setState(() {
                      _image = File(picked.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeriden seç'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (picked != null) {
                    setState(() {
                      _image = File(picked.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fotoğraf yükle alanı
                  _image == null
                      ? GestureDetector(
                          onTap: _pickImage,
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Color(0xFFE0E0E0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 32,
                                      color: Colors.grey[400],
                                    ),
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFE0E0E0),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.add,
                                            size: 14,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Resim Ekle',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _image!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 22,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(width: 24),
                  // Menü adı, fiyat ve aktif/pasif kutuları tek bir sütunda
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
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
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      controller: _menuNameController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                      ),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
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
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      controller: _priceController,
                                      enabled: _aktif,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                      ),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _aktif,
                                    onChanged: (val) =>
                                        setState(() => _aktif = true),
                                    activeColor: const Color(0xFFFF3D3D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  const Text(
                                    'Aktif',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(width: 80),
                                  Checkbox(
                                    value: !_aktif,
                                    onChanged: (val) =>
                                        setState(() => _aktif = false),
                                    activeColor: const Color(0xFFFF3D3D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  const Text(
                                    'Pasif',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                        onChanged: (val) => _malzemeSec(i),
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final seciliIcerikler = <String>[];
                    for (int i = 0; i < _malzemeler.length; i++) {
                      if (_malzemeSecili[i])
                        seciliIcerikler.add(_malzemeler[i]);
                    }
                    final menu = MenuModel(
                      name: _menuNameController.text,
                      price: _priceController.text,
                      desc: seciliIcerikler.join(', '),
                      imagePath:
                          _image?.path ?? 'assets/images/sandwichMenu.png',
                      ekmekTipi: _ekmekTipi,
                      icerikler: seciliIcerikler,
                      aktif: _aktif,
                    );
                    await LocalMenuService.addMenu(menu);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Başarı ile kaydedilmiştir'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context, true);
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
        unselectedItemColor: Colors.grey,
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
            icon: Icon(Icons.person_outline),
            label: 'Siparişlerim',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
