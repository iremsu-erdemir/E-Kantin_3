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
  bool isEditing = false;
  late TextEditingController nameController;
  late TextEditingController numberController;
  late TextEditingController expiryController;
  late TextEditingController cvcController;
  UserCard? originalCard;

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
      if (userCards.isNotEmpty) {
        _initControllers(userCards[0]);
      }
    });
  }

  void _initControllers(UserCard card) {
    nameController = TextEditingController(text: card.cardHolder);
    numberController = TextEditingController(text: card.cardNumber);
    expiryController = TextEditingController(text: card.expiryDate);
    cvcController = TextEditingController(text: card.cvc ?? '');
    originalCard = card;
  }

  void _onPageChanged(int index) {
    setState(() {
      selectedCardIndex = index;
      isEditing = false;
      _initControllers(userCards[index]);
    });
  }

  void _startEdit() {
    setState(() {
      isEditing = true;
    });
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;
      _initControllers(userCards[selectedCardIndex]);
    });
  }

  Future<void> _saveEdit() async {
    // Validasyon
    String name = nameController.text.trim();
    String number = numberController.text.replaceAll(' ', '').trim();
    String expiry = expiryController.text.trim();
    String cvc = cvcController.text.trim();
    if (name.isEmpty ||
        number.length != 16 ||
        expiry.isEmpty ||
        cvc.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen tüm alanları doğru doldurun!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final newCard = UserCard(
      cardHolder: name,
      cardNumber: number,
      expiryDate: expiry,
      cvc: cvc,
    );
    await UserCardService.updateCard(originalCard!, newCard);
    await _loadUserCards();
    setState(() {
      isEditing = false;
      _initControllers(newCard);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kart başarıyla güncellendi!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _deleteCard() async {
    final cardToDelete = userCards[selectedCardIndex];
    userCards.removeAt(selectedCardIndex);
    // Kaldırmak için kartları yeniden kaydet
    await UserCardService.clearCards();
    for (final c in userCards) {
      await UserCardService.addCard(c);
    }
    setState(() {
      isEditing = false;
      if (userCards.isEmpty) {
        nameController.dispose();
        numberController.dispose();
        expiryController.dispose();
        cvcController.dispose();
      } else {
        selectedCardIndex = 0;
        _initControllers(userCards[0]);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kart silindi!'),
        backgroundColor: Colors.red,
      ),
    );
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
                      onPageChanged: isEditing ? null : _onPageChanged,
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
                                left: 16,
                                top: 12,
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
                    hint: nameController.text,
                    initialValue: nameController.text,
                    readOnly: !isEditing,
                    controller: nameController,
                  ),
                  const SizedBox(height: 14),
                  _LabelField(
                    label: 'Card Number',
                    labelEn: '',
                    hint: numberController.text,
                    initialValue: numberController.text,
                    readOnly: !isEditing,
                    controller: numberController,
                    maxLength: 16,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  _LabelField(
                    label: 'Expiry Date',
                    labelEn: '',
                    hint: expiryController.text,
                    initialValue: expiryController.text,
                    readOnly: !isEditing,
                    controller: expiryController,
                    maxLength: 5,
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 14),
                  _LabelField(
                    label: 'CVC',
                    labelEn: '',
                    hint: cvcController.text.isEmpty
                        ? '***'
                        : cvcController.text,
                    initialValue: cvcController.text.isEmpty
                        ? '***'
                        : cvcController.text,
                    readOnly: !isEditing,
                    controller: cvcController,
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    isCvc: true,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      if (!isEditing) ...[
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
                            onPressed: _startEdit,
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
                      ] else ...[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveEdit,
                            child: const Text('Kaydet'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
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
                            onPressed: _cancelEdit,
                            child: const Text('Vazgeç'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
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
                    ],
                  ),
                  if (isEditing)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Center(
                        child: TextButton.icon(
                          onPressed: _deleteCard,
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text(
                            'Kartı Sil',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
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
  final TextEditingController? controller;
  final int? maxLength;
  final TextInputType? keyboardType;
  const _LabelField({
    required this.label,
    required this.labelEn,
    required this.hint,
    required this.initialValue,
    this.readOnly = true,
    this.isCvc = false,
    this.controller,
    this.maxLength,
    this.keyboardType,
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
          controller: controller ?? TextEditingController(text: initialValue),
          obscureText: isCvc,
          maxLength: maxLength,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            filled: true,
            fillColor: readOnly ? Colors.white : const Color(0xFFF3F3F3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF0F0F0)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            counterText: '',
          ),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
