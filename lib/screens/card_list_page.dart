import 'package:flutter/material.dart';
import '../components/ek_bottom_nav_bar.dart';
import '../models/user_card.dart';
import '../services/user_card_service.dart';

class OdemeKartiYonetimPage extends StatefulWidget {
  const OdemeKartiYonetimPage({Key? key}) : super(key: key);

  @override
  State<OdemeKartiYonetimPage> createState() => _OdemeKartiYonetimPageState();
}

class _OdemeKartiYonetimPageState extends State<OdemeKartiYonetimPage> {
  List<UserCard> userCards = [];
  bool isLoading = true;
  int selectedCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserCards();
  }

  Future<void> _loadUserCards() async {
    userCards = await UserCardService.getCards();
    setState(() {
      isLoading = false;
      selectedCardIndex = 0;
    });
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userCards.isEmpty
          ? const Center(child: Text('Kayıtlı kart bulunamadı'))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 160,
                    child: PageView.builder(
                      controller: PageController(
                        viewportFraction: 0.88,
                        initialPage: selectedCardIndex,
                      ),
                      itemCount: userCards.length,
                      onPageChanged: (index) {
                        setState(() {
                          selectedCardIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final card = userCards[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.symmetric(
                            horizontal: index == selectedCardIndex ? 0 : 8,
                            vertical: 8,
                          ),
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
                              Positioned(
                                left: 16, // daha sola
                                top: 12, // daha yukarı
                                child: Container(
                                  width: 32,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.22),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
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
                                    (i) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 24,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userCards[index].maskedNumber,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      userCards[index].cardHolder,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Son Kullanma: ${userCards[index].expiryDate}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  _LabelField(
                    label: 'Kart Sahibinin Adı Soyadı',
                    labelEn: '',
                    hint: userCards[selectedCardIndex].cardHolder,
                    initialValue: userCards[selectedCardIndex].cardHolder,
                    readOnly: true,
                  ),
                  const SizedBox(height: 14),
                  _LabelField(
                    label: 'Card Number',
                    labelEn: '',
                    hint: userCards[selectedCardIndex].maskedNumber,
                    initialValue: userCards[selectedCardIndex].maskedNumber,
                    readOnly: true,
                  ),
                  const SizedBox(height: 14),
                  _LabelField(
                    label: 'Expiry Date',
                    labelEn: '',
                    hint: userCards[selectedCardIndex].expiryDate,
                    initialValue: userCards[selectedCardIndex].expiryDate,
                    readOnly: true,
                  ),
                  const SizedBox(height: 14),
                  _LabelField(
                    label: 'CVC',
                    labelEn: '',
                    hint: '***',
                    initialValue: '***',
                    readOnly: true,
                    isCvc: true,
                  ),
                  const SizedBox(height: 28),
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
