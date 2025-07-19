import 'package:flutter/material.dart';

class UrunDuzenlePage extends StatefulWidget {
  final String urunAdi;
  final String fiyat;
  final bool stoktaVar;
  const UrunDuzenlePage({
    Key? key,
    required this.urunAdi,
    required this.fiyat,
    required this.stoktaVar,
  }) : super(key: key);

  @override
  State<UrunDuzenlePage> createState() => _UrunDuzenlePageState();
}

class _UrunDuzenlePageState extends State<UrunDuzenlePage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  bool _stoktaVar = true;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.urunAdi);
    _priceController = TextEditingController(text: widget.fiyat);
    _stoktaVar = widget.stoktaVar;
  }

  void _showSaveDialog() {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ürün Adı',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _nameController.text,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _priceController.text,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Kaydetmek İstiyor musunuz?',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF3D3D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.close, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Hayır',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() => _editing = false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2AD2C9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check, color: Colors.white),
                            SizedBox(width: 4),
                            Text('Evet', style: TextStyle(color: Colors.white)),
                          ],
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
          'Ürün Düzenle',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Ürün Adı',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Spacer(),
                const Text(
                  'Fiyat',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _nameController,
                    enabled: _editing,
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
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _priceController,
                    enabled: _editing,
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
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Stok Durumu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Spacer(),
                Switch(
                  value: _stoktaVar,
                  onChanged: _editing
                      ? (val) => setState(() => _stoktaVar = val)
                      : null,
                  activeColor: const Color(0xFF2AD2C9),
                  inactiveThumbColor: const Color(0xFFFF3D3D),
                ),
                Text(
                  _stoktaVar ? 'Stokta Var' : 'Stokta Yok',
                  style: TextStyle(
                    color: _stoktaVar ? Color(0xFF2AD2C9) : Color(0xFFFF3D3D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: !_editing
                        ? () => setState(() => _editing = true)
                        : _showSaveDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _editing
                          ? const Color(0xFF2AD2C9)
                          : const Color(0xFFFF3D3D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _editing ? 'Kaydet' : 'Düzenle',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3D3D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '+ Yeni Ürün Ekle',
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
