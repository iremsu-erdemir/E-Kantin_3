import 'package:flutter/material.dart';
import 'successpayment.dart';
import 'cart.dart';
import '../models/cart.dart';
import '../models/user.dart';
import '../services/user_card_service.dart';
import '../models/user_card.dart';
import '../components/ek_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'favorilerim.dart';

// Renkler ve text stilleri
const Color kRed = Color(0xFFFF5A5A);
const Color kInputLabel = Color(0xFFBDBDBD);
const Color kInputText = Color(0xFF222222);
const Color kTitle = Color(0xFF222222);
const Color kCardWhite = Colors.white;
const TextStyle kCardTitleStyle = TextStyle(
  color: kCardWhite,
  fontWeight: FontWeight.w700,
  fontSize: 20,
  fontFamily: 'Poppins',
);
const TextStyle kCardNumberStyle = TextStyle(
  color: kCardWhite,
  fontWeight: FontWeight.w400,
  fontSize: 18,
  fontFamily: 'Poppins',
  letterSpacing: 2,
);
const TextStyle kCardLastDigitsStyle = TextStyle(
  color: kCardWhite,
  fontWeight: FontWeight.w400,
  fontSize: 18,
  fontFamily: 'Poppins',
);
const TextStyle kSectionTitleStyle = TextStyle(
  color: kTitle,
  fontWeight: FontWeight.w700,
  fontSize: 16,
  fontFamily: 'Poppins',
);
const TextStyle kInputLabelStyle = TextStyle(
  color: kInputLabel,
  fontWeight: FontWeight.w600,
  fontSize: 12,
  fontFamily: 'Poppins',
);
const TextStyle kInputTextStyle = TextStyle(
  color: kInputText,
  fontWeight: FontWeight.w400,
  fontSize: 16,
  fontFamily: 'Poppins',
);
const TextStyle kAmountStyle = TextStyle(
  color: kTitle,
  fontWeight: FontWeight.w700,
  fontSize: 22,
  fontFamily: 'Poppins',
);
const TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w700,
  fontSize: 16,
  fontFamily: 'Poppins',
);

// Özel kart kutusu widget'ı (globalde)
class CardDisplayBox extends StatelessWidget {
  final String title;
  final String maskedNumber;
  final VoidCallback? onTap;
  const CardDisplayBox({
    super.key,
    required this.title,
    required this.maskedNumber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Masked number ve son 3 hane ayrımı
    String stars = maskedNumber.replaceAll(RegExp(r'\d'), '*');
    String lastDigits = maskedNumber.replaceAll(RegExp(r'\D'), '');
    if (lastDigits.length > 3) {
      stars = stars.substring(0, stars.length - 3);
      lastDigits = lastDigits.substring(lastDigits.length - 3);
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        decoration: BoxDecoration(
          color: kRed,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: kCardTitleStyle),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Text(stars, style: kCardNumberStyle),
                    const SizedBox(width: 4),
                    Text(lastDigits, style: kCardLastDigitsStyle),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final double totalPrice;
  final User? user;
  const PaymentPage({Key? key, required this.totalPrice, this.user})
    : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  List<UserCard> userCards = [];
  UserCard? selectedUserCard;
  bool isLoading = true;
  bool showCardDropdown = false;

  // Form controllerlar
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  // FocusNode'lar
  final FocusNode nameFocus = FocusNode();
  final FocusNode cardFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode cvcFocus = FocusNode();

  String? nameError, cardError, dateError, cvcError;

  @override
  void initState() {
    super.initState();
    _loadUserCards();
  }

  @override
  void dispose() {
    nameController.dispose();
    cardController.dispose();
    dateController.dispose();
    cvcController.dispose();
    nameFocus.dispose();
    cardFocus.dispose();
    dateFocus.dispose();
    cvcFocus.dispose();
    super.dispose();
  }

  Future<void> _loadUserCards() async {
    userCards = await UserCardService.getCards();
    // Test için en az 2 kart ekle (mock)
    if (userCards.length < 2) {
      userCards = [
        UserCard(
          cardHolder: 'Ali Veli',
          cardNumber: '1234567812345678',
          expiryDate: '12/25',
        ),
        UserCard(
          cardHolder: 'Ayşe Yılmaz',
          cardNumber: '8765432187654321',
          expiryDate: '11/27',
        ),
        UserCard(
          cardHolder: 'Cengiz  Demir',
          cardNumber: '1234432187654321',
          expiryDate: '10/37',
        ),
      ];
    }
    setState(() {
      isLoading = false;
      if (userCards.isNotEmpty) {
        selectedUserCard = userCards.first;
        _fillControllers(selectedUserCard!);
      }
    });
  }

  void _fillControllers(UserCard card) {
    nameController.text = card.cardHolder;
    cardController.text = card.cardNumber;
    dateController.text = card.expiryDate;
    cvcController.clear();
  }

  void _onCardSelected(UserCard card) {
    setState(() {
      selectedUserCard = card;
      _fillControllers(card);
      showCardDropdown = false;
    });
  }

  bool get isFormValid {
    nameError = null;
    cardError = null;
    dateError = null;
    cvcError = null;
    final name = nameController.text.trim();
    final card = cardController.text.replaceAll(' ', '');
    final date = dateController.text.trim();
    final cvc = cvcController.text.trim();
    if (name.isEmpty) {
      nameError = 'İsim zorunlu';
    }
    if (card.length != 16 || int.tryParse(card) == null) {
      cardError = '16 haneli geçerli kart numarası girin';
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}').hasMatch(date)) {
      dateError = 'MM/YY formatında girin';
    }
    if (cvc.length != 3 || int.tryParse(cvc) == null) {
      cvcError = '3 haneli CVC girin';
    }
    return nameError == null &&
        cardError == null &&
        dateError == null &&
        cvcError == null;
  }

  void _focusFirstError() {
    if (nameError != null) {
      FocusScope.of(context).requestFocus(nameFocus);
    } else if (cardError != null) {
      FocusScope.of(context).requestFocus(cardFocus);
    } else if (dateError != null) {
      FocusScope.of(context).requestFocus(dateFocus);
    } else if (cvcError != null) {
      FocusScope.of(context).requestFocus(cvcFocus);
    }
  }

  Future<void> _addNewCard() async {
    final newCard = UserCard(
      cardHolder: nameController.text.trim(),
      cardNumber: cardController.text.replaceAll(' ', ''),
      expiryDate: dateController.text.trim(),
    );
    await UserCardService.addCard(newCard);
    await _loadUserCards();
    setState(() {
      selectedUserCard = userCards.firstWhere(
        (c) =>
            c.cardNumber == newCard.cardNumber &&
            c.expiryDate == newCard.expiryDate,
        orElse: () => userCards.first,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = widget.totalPrice;
    final bool isLoggedIn =
        widget.user != null && (widget.user!.name?.isNotEmpty ?? false);
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Ödeme',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('Kayıtlı Kartlarım', style: kSectionTitleStyle),
              const SizedBox(height: 10),
              CardDisplayBox(
                title: selectedUserCard?.cardHolder ?? 'Kredi Kartım',
                maskedNumber:
                    selectedUserCard?.maskedNumber ?? '************ 436',
                onTap: () {
                  setState(() {
                    showCardDropdown = !showCardDropdown;
                  });
                },
              ),
              if (showCardDropdown && userCards.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: userCards.map((card) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedUserCard = card;
                                nameController.text = card.cardHolder;
                                cardController.text = card.cardNumber;
                                dateController.text = card.expiryDate;
                                cvcController.clear();
                                showCardDropdown = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: card == selectedUserCard
                                    ? const Color(0xFFFF3D3D).withOpacity(0.1)
                                    : Colors.white,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.credit_card,
                                    color: Color(0xFFFF3D3D),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    card.maskedNumber,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    card.cardHolder,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 28),
              const Text('Başka Kartla Ödeme Yap', style: kSectionTitleStyle),
              const SizedBox(height: 10),
              AbsorbPointer(
                absorbing: false, // Sadece CVC aktif olacak
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        focusNode: nameFocus,
                        enabled:
                            selectedUserCard ==
                            null, // Sadece kart seçili değilse aktif
                        decoration: InputDecoration(
                          labelText: 'KART SAHİBİNİN ADI SOYADI',
                          labelStyle: kInputLabelStyle,
                          filled: true,
                          fillColor: const Color(0xFFF3F3F3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          errorText: nameError,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'İsim zorunlu';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: cardController,
                        focusNode: cardFocus,
                        maxLength: 16,
                        keyboardType: TextInputType.number,
                        enabled:
                            selectedUserCard ==
                            null, // Sadece kart seçili değilse aktif
                        decoration: InputDecoration(
                          labelText: 'KART NUMARASI',
                          labelStyle: kInputLabelStyle,
                          filled: true,
                          fillColor: const Color(0xFFF3F3F3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          errorText: cardError,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          counterText: '',
                        ),
                        validator: (value) {
                          final card = value?.replaceAll(' ', '').trim() ?? '';
                          if (card.isEmpty) {
                            return 'Kart numarası zorunlu';
                          }
                          if (card.length != 16 || int.tryParse(card) == null) {
                            return '16 haneli geçerli kart numarası girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: dateController,
                              focusNode: dateFocus,
                              maxLength: 5,
                              keyboardType: TextInputType.datetime,
                              enabled:
                                  selectedUserCard ==
                                  null, // Sadece kart seçili değilse aktif
                              decoration: InputDecoration(
                                labelText: 'GEÇERLİLİK TARİHİ',
                                labelStyle: kInputLabelStyle,
                                hintText: 'mm/yy',
                                filled: true,
                                fillColor: const Color(0xFFF3F3F3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                errorText: dateError,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                counterText: '',
                              ),
                              validator: (value) {
                                final date = value?.trim() ?? '';
                                if (date.isEmpty) {
                                  return 'Tarih zorunlu';
                                }
                                if (!RegExp(
                                  r'^(0[1-9]|1[0-2])\/\d{2}',
                                ).hasMatch(date)) {
                                  return 'MM/YY formatında girin';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: cvcController,
                              focusNode: cvcFocus,
                              maxLength: 3,
                              keyboardType: TextInputType.number,
                              enabled: true, // CVC her zaman aktif
                              style: kInputTextStyle, // Koyu renk
                              decoration: InputDecoration(
                                labelText: 'CVC',
                                labelStyle: kInputLabelStyle,
                                hintText: '***',
                                filled: true,
                                fillColor:
                                    Colors.white, // Gri değil, beyaz arka plan
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                errorText: cvcError,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                counterText: '',
                              ),
                              validator: (value) {
                                final cvc = value?.trim() ?? '';
                                if (cvc.isEmpty) {
                                  return 'CVC zorunlu';
                                }
                                if (cvc.length != 3 ||
                                    int.tryParse(cvc) == null) {
                                  return '3 haneli CVC girin';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Text(
                    '₺${totalPrice.toStringAsFixed(2)}',
                    style: kAmountStyle,
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: (!isLoggedIn)
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Lütfen giriş yapmadan önce bu işlemi gerçekleştiremezsiniz.',
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          : () {
                              print("Kart Adı: '${nameController.text}'");
                              print("Kart No: '${cardController.text}'");
                              print("Tarih: '${dateController.text}'");
                              print("CVC: '${cvcController.text}'");
                              if (_formKey.currentState!.validate()) {
                                Provider.of<CartProvider>(
                                  context,
                                  listen: false,
                                ).clear();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SuccessPaymentPage(
                                      totalPrice: totalPrice,
                                      orderNumber:
                                          (1000 +
                                                  DateTime.now()
                                                          .millisecondsSinceEpoch %
                                                      9000)
                                              .toString(),
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Lütfen bilgileri eksiksiz girin',
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3D3D),
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text('Ödeme Yap', style: kButtonTextStyle),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: EKBottomNavBar(
        currentIndex: 2, // PaymentPage için uygun index
        onTap: (int index) {
          // Diğer indexler için mevcut davranış devam eder
        },
        parentContext: context,
      ),
    );
  }
}

// Custom input widget (görseldeki gibi sade, border yok, gri arka plan, bold label)
class _CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? errorText;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? hintText;
  final FocusNode? focusNode;
  const _CustomInput({
    required this.controller,
    required this.label,
    this.errorText,
    this.maxLength,
    this.keyboardType,
    this.hintText,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyboardType,
      style: kInputTextStyle,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: kInputLabelStyle,
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF3F3F3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        counterText: '',
      ),
    );
  }
}
