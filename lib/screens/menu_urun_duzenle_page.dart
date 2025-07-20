import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/local_menu_service.dart';
import '../models/urun_model.dart';
import '../models/menu_model.dart';

class MenuUrunDuzenlePage extends StatefulWidget {
  final String menuName;
  final List<Map<String, dynamic>> urunler;
  const MenuUrunDuzenlePage({
    Key? key,
    required this.menuName,
    required this.urunler,
  }) : super(key: key);

  @override
  State<MenuUrunDuzenlePage> createState() => _MenuUrunDuzenlePageState();
}

class _MenuUrunDuzenlePageState extends State<MenuUrunDuzenlePage> {
  late List<TextEditingController> nameControllers;
  late List<TextEditingController> priceControllers;
  late List<bool> stoktaVarList;
  late List<bool> editingList;
  late List<UrunModel> urunler;

  @override
  void initState() {
    super.initState();
    urunler = widget.urunler
        .map(
          (u) => UrunModel(
            name: u['name'],
            price: u['price'].toString(),
            stoktaVar: u['stoktaVar'] ?? true,
          ),
        )
        .toList();
    nameControllers = urunler
        .map((u) => TextEditingController(text: u.name))
        .toList();
    priceControllers = urunler
        .map((u) => TextEditingController(text: u.price))
        .toList();
    stoktaVarList = urunler.map((u) => u.stoktaVar).toList();
    editingList = List.generate(urunler.length, (index) => false);
  }

  @override
  void dispose() {
    for (var c in nameControllers) {
      c.dispose();
    }
    for (var c in priceControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _saveToLocalStorage() async {
    final menus = await LocalMenuService.getMenus();
    final menuIndex = menus.indexWhere((m) => m.name == widget.menuName);
    if (menuIndex != -1) {
      final menu = menus[menuIndex];
      final newUrunler = <UrunModel>[];
      for (int i = 0; i < nameControllers.length; i++) {
        newUrunler.add(
          UrunModel(
            name: nameControllers[i].text.trim(),
            price: priceControllers[i].text.trim(),
            stoktaVar: stoktaVarList[i],
          ),
        );
      }
      menus[menuIndex] = menu.copyWith(urunler: newUrunler);
      await LocalMenuService.saveMenus(menus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ürün bilgileri başarı ile güncellendi'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  Widget _customCheckbox(
    bool value,
    ValueChanged<bool?> onChanged, {
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? () => onChanged(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: value ? const Color(0xFFFF7A00) : const Color(0xFFE0E0E0),
            width: 2,
          ),
        ),
        child: value
            ? Center(
                child: Icon(
                  Icons.check,
                  size: 18,
                  color: const Color(0xFFFF7A00),
                ),
              )
            : null,
      ),
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
        title: Text(
          widget.menuName,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: urunler.length,
        separatorBuilder: (context, i) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7FA),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ürün Adı',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF333333),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: nameControllers[index],
                            enabled: editingList[index],
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            readOnly: !editingList[index],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fiyatı',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF333333),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: priceControllers[index],
                            enabled: editingList[index],
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            readOnly: !editingList[index],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Stok Durumu',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _customCheckbox(stoktaVarList[index], (val) {
                      if (editingList[index]) {
                        setState(() {
                          stoktaVarList[index] = true;
                        });
                      }
                    }, enabled: editingList[index]),
                    const SizedBox(width: 8),
                    Text(
                      'Stokta Var',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 18),
                    _customCheckbox(!stoktaVarList[index], (val) {
                      if (editingList[index]) {
                        setState(() {
                          stoktaVarList[index] = false;
                        });
                      }
                    }, enabled: editingList[index]),
                    const SizedBox(width: 8),
                    Text(
                      'Stokta Yok',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 120,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: editingList[index]
                            ? () async {
                                setState(() {
                                  editingList[index] = false;
                                });
                                await _saveToLocalStorage();
                              }
                            : () {
                                setState(() {
                                  editingList[index] = true;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: editingList[index]
                              ? const Color(0xFF34C759)
                              : const Color(0xFFFF4B4B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                        ),
                        child: Text(
                          editingList[index] ? 'Kaydet' : 'Düzenle',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () async {
              String yeniUrunAdi = '';
              String yeniFiyat = '';
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ürün Adı',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF333333),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                              onChanged: (val) => yeniUrunAdi = val,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Fiyatı',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF333333),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                              onChanged: (val) => yeniFiyat = val,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Kaydetmek istiyor musunuz?',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Color(0xFFFF4B4B),
                                  ),
                                  label: Text(
                                    'Hayır',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFFFF4B4B),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                        color: Color(0xFFFF4B4B),
                                        width: 1.5,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop('evet');
                                  },
                                  icon: const Icon(
                                    Icons.check,
                                    color: Color(0xFF34C759),
                                  ),
                                  label: Text(
                                    'Evet',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF34C759),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                        color: Color(0xFF34C759),
                                        width: 1.5,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ).then((result) async {
                if (result == 'evet' &&
                    yeniUrunAdi.trim().isNotEmpty &&
                    yeniFiyat.trim().isNotEmpty) {
                  final menus = await LocalMenuService.getMenus();
                  final menuIndex = menus.indexWhere(
                    (m) => m.name == widget.menuName,
                  );
                  if (menuIndex != -1) {
                    final menu = menus[menuIndex];
                    final yeniUrunler = List<UrunModel>.from(menu.urunler)
                      ..add(
                        UrunModel(
                          name: yeniUrunAdi.trim(),
                          price: yeniFiyat.trim(),
                          stoktaVar: true,
                        ),
                      );
                    final newMenu = menu.copyWith(urunler: yeniUrunler);
                    menus[menuIndex] = newMenu;
                    await LocalMenuService.saveMenus(menus);
                    setState(() {
                      nameControllers.add(
                        TextEditingController(text: yeniUrunAdi.trim()),
                      );
                      priceControllers.add(
                        TextEditingController(text: yeniFiyat.trim()),
                      );
                      stoktaVarList.add(true);
                      editingList.add(false);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ürün başarı ile eklendi'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.all(16),
                      ),
                    );
                  }
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4B4B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Text(
              '+ Yeni Ürün Ekle',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
