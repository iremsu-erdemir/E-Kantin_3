import 'package:flutter/material.dart';
import '../models/user_card.dart';
import '../services/user_card_service.dart';
import '../components/ek_bottom_nav_bar.dart';

class KartEklePage extends StatefulWidget {
  @override
  State<KartEklePage> createState() => _KartEklePageState();
}

class _KartEklePageState extends State<KartEklePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();
  final TextEditingController cardNameController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    expiryController.dispose();
    cvcController.dispose();
    cardNameController.dispose();
    super.dispose();
  }

  void _onExpiryChanged(String value) {
    // Otomatik '/' ekle
    if (value.length == 2 && !value.contains('/')) {
      expiryController.text = value + '/';
      expiryController.selection = TextSelection.fromPosition(
        TextPosition(offset: expiryController.text.length),
      );
    }
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
    });
    final newCard = UserCard(
      cardHolder: nameController.text.trim(),
      cardNumber: numberController.text.replaceAll(' ', '').trim(),
      expiryDate: expiryController.text.trim(),
      cvc: cvcController.text.trim(),
      cardName: cardNameController.text.trim(),
    );
    await UserCardService.addCard(newCard);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Kart Kaydet',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _InputLabel('KART SAHİBİNİN ADI SOYADI'),
                SizedBox(
                  height: 54,
                  child: TextFormField(
                    controller: nameController,
                    decoration: _inputDecoration(
                      'Adınız ve soyadınızı giriniz',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Zorunlu alan' : null,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                _InputLabel('KART NUMARASI'),
                SizedBox(
                  height: 54,
                  child: TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: _inputDecoration('5400  ____  ____  ____'),
                    validator: (v) => v == null || v.trim().length != 16
                        ? '16 haneli kart numarası girin'
                        : null,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InputLabel('GEÇERLİLİK TARİHİ'),
                          SizedBox(
                            height: 54,
                            child: TextFormField(
                              controller: expiryController,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              decoration: _inputDecoration('mm/yy'),
                              validator: (v) =>
                                  v == null ||
                                      !RegExp(
                                        r'^(0[1-9]|1[0-2])/\d{2,4}',
                                      ).hasMatch(v)
                                  ? 'mm/yy veya mm/yyyy'
                                  : null,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF222222),
                              ),
                              onChanged: _onExpiryChanged,
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
                          _InputLabel('CVC'),
                          SizedBox(
                            height: 54,
                            child: TextFormField(
                              controller: cvcController,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              decoration: _inputDecoration('***'),
                              validator: (v) =>
                                  v == null || v.trim().length != 3
                                  ? '3 haneli CVC'
                                  : null,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF222222),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _InputLabel('KART KAYIT ADI'),
                SizedBox(
                  height: 54,
                  child: TextFormField(
                    controller: cardNameController,
                    decoration: _inputDecoration('Nakit Kartım'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Zorunlu alan' : null,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _saveCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF3D3D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Kaydet'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: EKBottomNavBar(
        currentIndex: 4,
        parentContext: context,
      ),
    );
  }
}

class _InputLabel extends StatelessWidget {
  final String text;
  const _InputLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF222222), // Siyah
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: Color(0xFF222222), // Siyah
      fontWeight: FontWeight.w400,
      fontSize: 16,
    ),
    filled: true,
    fillColor: Color(0xFFF7F5FA),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    counterText: '',
  );
}
