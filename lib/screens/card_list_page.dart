import 'package:flutter/material.dart';
import '../components/ek_bottom_nav_bar.dart';

class OdemeKartiYonetimPage extends StatelessWidget {
  const OdemeKartiYonetimPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Renkler
    const Color kRed = Color(0xFFFF3D3D);
    const Color kGradientStart = Color(0xFF7B2FF2);
    const Color kGradientEnd = Color(0xFFf357a8);

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
          'Ayarlar',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kart
              Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [kGradientStart, kGradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Çip ve desen
                    Positioned(
                      left: 24,
                      top: 24,
                      child: Container(
                        width: 32,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.credit_card,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 24,
                      top: 24,
                      child: Row(
                        children: List.generate(
                          4,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Kart Bilgileri
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '•••• 4244',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Cengiz Demir',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Kart Sahibinin Adı Soyadı
              const _LabelField(
                label: 'Kart Sahibinin Adı Soyadı',
                labelEn: '',
                hint: 'Cengiz Demir',
                initialValue: 'Cengiz Demir',
                readOnly: true,
              ),
              SizedBox(height: 14),
              // Card Number
              const _LabelField(
                label: 'Card Number',
                labelEn: '',
                hint: '5400 **** **** 4244',
                initialValue: '5400 **** **** 4244',
                readOnly: true,
              ),
              SizedBox(height: 14),
              // Expiry Date
              const _LabelField(
                label: 'Expiry Date',
                labelEn: '',
                hint: '02/2028',
                initialValue: '02/2028',
                readOnly: true,
              ),
              SizedBox(height: 14),
              // CVC
              const _LabelField(
                label: 'CVC',
                labelEn: '',
                hint: '***',
                initialValue: '***',
                readOnly: true,
                isCvc: true,
              ),
              const SizedBox(height: 28),
              // Butonlar
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Kart Ekle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Düzenle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
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

class _LabelField extends StatelessWidget {
  final String label;
  final String labelEn;
  final String hint;
  final String initialValue;
  final bool readOnly;
  final bool isCvc;
  const _LabelField({
    required this.label,
    required this.labelEn,
    required this.hint,
    required this.initialValue,
    this.readOnly = true,
    this.isCvc = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          readOnly: readOnly,
          controller: TextEditingController(text: initialValue),
          obscureText: isCvc,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF0F0F0)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
