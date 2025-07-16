import 'package:e_kantin/screens/siparisler.dart';
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
import 'home_page.dart';
import '../models/borc.dart';

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
  final bool isCayOcagiBorcu;
  final double? kalanBorc;
  final List<Borc> borcList;
  const PaymentPage({
    Key? key,
    required this.totalPrice,
    this.user,
    this.isCayOcagiBorcu = false,
    this.kalanBorc,
    this.borcList = const [],
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  List<UserCard> userCards = [];
  UserCard? selectedUserCard;
  bool isLoading = true;
  bool showCardDropdown = false;
  bool isCardSelected = false; // Dropdown'dan kart seçildi mi?

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
    _addSampleCardsIfNeeded();
    _loadUserCards();
    // Sayfa ilk açıldığında hiçbir kart seçili olmasın, alanlar boş gelsin
    selectedUserCard = null;
    nameController.clear();
    cardController.clear();
    dateController.clear();
    cvcController.clear();
    Future.delayed(Duration(seconds: 2), () {
      debugPrint('initState içinden _pay çağrılıyor');
      _pay();
    });
  }

  Future<void> _addSampleCardsIfNeeded() async {
    final existingCards = await UserCardService.getCards();
    if (existingCards.isEmpty) {
      await UserCardService.addCard(
        UserCard(
          cardHolder: 'CENGIZ DEMIR',
          cardNumber: '5400123412341234',
          expiryDate: '12/27',
          cvc: '123',
        ),
      );
      await UserCardService.addCard(
        UserCard(
          cardHolder: 'CENGIZ DEMIR',
          cardNumber: '4543123412345678',
          expiryDate: '11/28',
          cvc: '456',
        ),
      );
      await UserCardService.addCard(
        UserCard(
          cardHolder: 'CENGIZ DEMIR',
          cardNumber: '4023123412349876',
          expiryDate: '10/29',
          cvc: '789',
        ),
      );
    }
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
    setState(() {
      isLoading = false;
      // selectedUserCard = null; // Zaten yukarıda null
    });
  }

  void _fillControllers(UserCard card) {
    nameController.text = card.cardHolder;
    cardController.text = card.cardNumber;
    dateController.text = card.expiryDate;
    cvcController.clear();
  }

  // Kayıtlı kart seçildiğinde:
  void _onCardSelected(UserCard card) {
    setState(() {
      selectedUserCard = card;
      nameController.text = card.cardHolder;
      cardController.text = card.cardNumber;
      dateController.text = card.expiryDate;
      cvcController.clear();
      showCardDropdown = false;
      isCardSelected = true;
      nameError = null;
      cardError = null;
      dateError = null;
      cvcError = cvcController.text.trim().isEmpty ? 'CVC zorunlu' : null;
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

  Future<void> _pay() async {
    debugPrint('_pay fonksiyonu çağrıldı');
    // Buraya ödeme işlemiyle ilgili test/debug kodlarını ekleyebilirsin.
  }

  // Ödeme butonuna basınca toplu kontrol fonksiyonu ekle
  void _validateAllFields() {
    setState(() {
      if (!isCardSelected) {
        nameError = nameController.text.trim().isEmpty ? 'İsim zorunlu' : null;
        final card = cardController.text.replaceAll(' ', '').trim();
        if (card.isEmpty) {
          cardError = 'Kart numarası zorunlu';
        } else if (card.length != 16 || int.tryParse(card) == null) {
          cardError = '16 haneli geçerli kart numarası girin';
        } else {
          cardError = null;
        }
        final date = dateController.text.trim();
        if (date.isEmpty) {
          dateError = 'Tarih zorunlu';
        } else if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}').hasMatch(date)) {
          dateError = 'MM/YY formatında girin';
        } else {
          dateError = null;
        }
      }
      // Kayıtlı kart seçiliyse sadece CVC kontrolü yap
      if (isCardSelected) {
        if (cvcController.text.trim().isEmpty) {
          cvcError = 'CVC zorunlu';
        } else if (cvcController.text.trim().length != 3 ||
            int.tryParse(cvcController.text.trim()) == null) {
          cvcError = '3 haneli CVC girin';
        } else {
          cvcError = null;
        }
      } else {
        cvcError = cvcController.text.trim().isEmpty ? 'CVC zorunlu' : null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = widget.totalPrice;
    final bool isLoggedIn =
        UserSingleton().user != null &&
        (UserSingleton().user!.name?.isNotEmpty ?? false);
    // DEBUG: PaymentPage'e gelen veriler
    print('--- PaymentPage DEBUG ---');
    print('totalPrice: ₺$totalPrice');
    print('kalanBorc: ₺${widget.kalanBorc}');
    print('borcList:');
    for (var b in widget.borcList) {
      print('  - ${b.urun} (₺${b.tutar})');
    }
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
              if (widget.borcList.isNotEmpty) ...[
                const Text(
                  'Ödenecek Borçlar:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ...widget.borcList.map(
                  (b) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(b.urun, style: const TextStyle(fontSize: 15)),
                      Text(
                        '₺${b.tutar.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 24, thickness: 1),
              ],
              const SizedBox(height: 8),
              const Text('Kayıtlı Kartlarım', style: kSectionTitleStyle),
              const SizedBox(height: 10),
              CardDisplayBox(
                title: selectedUserCard?.cardHolder ?? 'Kredi Kartım',
                maskedNumber:
                    selectedUserCard?.maskedNumber ?? '************ 436',
                onTap: () {
                  setState(() {
                    if (selectedUserCard != null) {
                      // Kayıtlı kart seçiliyse, manuel girişe geç
                      selectedUserCard = null;
                      isCardSelected = false;
                      nameController.clear();
                      cardController.clear();
                      dateController.clear();
                      cvcController.clear();
                      nameError = null;
                      cardError = null;
                      dateError = null;
                      cvcError = null;
                    } else {
                      showCardDropdown = !showCardDropdown;
                    }
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
                                isCardSelected = true;
                                nameError = null;
                                cardError = null;
                                dateError = null;
                                cvcError = cvcController.text.trim().isEmpty
                                    ? 'CVC zorunlu'
                                    : null;
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
                absorbing:
                    (selectedUserCard != null && !showCardDropdown) ||
                    showCardDropdown,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                        enabled: !isCardSelected,
                        decoration: InputDecoration(
                          labelText: 'KART SAHİBİNİN ADI SOYADI',
                          labelStyle: kInputLabelStyle,
                          filled: true,
                          fillColor: isCardSelected
                              ? Colors.grey[200]
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          errorText: isCardSelected ? null : nameError,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          counterText: '',
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (isCardSelected) {
                              nameError = null;
                            } else {
                              nameError = value.trim().isEmpty
                                  ? 'İsim zorunlu'
                                  : null;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: cardController,
                        focusNode: cardFocus,
                        maxLength: 16,
                        keyboardType: TextInputType.number,
                        enabled: !isCardSelected,
                        decoration: InputDecoration(
                          labelText: 'KART NUMARASI',
                          labelStyle: kInputLabelStyle,
                          filled: true,
                          fillColor: isCardSelected
                              ? Colors.grey[200]
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          errorText: isCardSelected ? null : cardError,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          counterText: '',
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (isCardSelected) {
                              cardError = null;
                            } else {
                              final card = value.replaceAll(' ', '').trim();
                              if (card.isEmpty) {
                                cardError = 'Kart numarası zorunlu';
                              } else if (card.length != 16 ||
                                  int.tryParse(card) == null) {
                                cardError =
                                    '16 haneli geçerli kart numarası girin';
                              } else {
                                cardError = null;
                              }
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: dateController,
                        focusNode: dateFocus,
                        maxLength: 5,
                        keyboardType: TextInputType.datetime,
                        enabled: !isCardSelected,
                        decoration: InputDecoration(
                          labelText: 'GEÇERLİLİK TARİHİ',
                          labelStyle: kInputLabelStyle,
                          hintText: 'mm/yy',
                          filled: true,
                          fillColor: isCardSelected
                              ? Colors.grey[200]
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          errorText: isCardSelected ? null : dateError,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          counterText: '',
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (isCardSelected) {
                              dateError = null;
                            } else {
                              if (value.trim().isEmpty) {
                                dateError = 'Tarih zorunlu';
                              } else if (!RegExp(
                                r'^(0[1-9]|1[0-2])\/\d{2}',
                              ).hasMatch(value)) {
                                dateError = 'MM/YY formatında girin';
                              } else {
                                dateError = null;
                              }
                            }
                          });
                          // Sadece rakam girilmişse ve 2 karakterden sonra '/' eklenmemişse otomatik ekle
                          if (value.length == 2 && !value.contains('/')) {
                            dateController.text = value + '/';
                            dateController
                                .selection = TextSelection.fromPosition(
                              TextPosition(offset: dateController.text.length),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // CVC her zaman aktif ve AbsorbPointer dışında
              TextFormField(
                controller: cvcController,
                focusNode: cvcFocus,
                maxLength: 3,
                keyboardType: TextInputType.number,
                enabled: true,
                style: kInputTextStyle,
                decoration: InputDecoration(
                  labelText: 'CVC',
                  labelStyle: kInputLabelStyle,
                  hintText: '***',
                  filled: true,
                  fillColor: Colors.white,
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
                onChanged: (value) {
                  setState(() {
                    if (isCardSelected) {
                      if (value.trim().isEmpty) {
                        cvcError = 'CVC zorunlu';
                      } else if (value.trim().length != 3 ||
                          int.tryParse(value.trim()) == null) {
                        cvcError = '3 haneli CVC girin';
                      } else {
                        cvcError = null;
                      }
                    } else {
                      cvcError = value.trim().isEmpty ? 'CVC zorunlu' : null;
                    }
                  });
                },
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
                                SnackBar(
                                  content: Text(
                                    'Lütfen giriş yapmadan önce bu işlemi gerçekleştiremezsiniz.',
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          : () async {
                              _validateAllFields();
                              if ((isCardSelected ||
                                      (nameError == null &&
                                          cardError == null &&
                                          dateError == null)) &&
                                  cvcError == null) {
                                // Eğer kayıtlı kart seçiliyse CVC kontrolü yap
                                if (selectedUserCard != null &&
                                    selectedUserCard!.cvc != null) {
                                  if (cvcController.text.trim() !=
                                      selectedUserCard!.cvc) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Yanlış bilgi girdiniz'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                    return;
                                  }
                                }
                                // Ürün adını sepet temizlenmeden önce al
                                final productName = _getProductName(context);
                                Provider.of<CartProvider>(
                                  context,
                                  listen: false,
                                ).clear();
                                if (widget.isCayOcagiBorcu) {
                                  await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 32,
                                          ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 48,
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Ödeme Başarıyla Tamamlandı!',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Şu kadar borcunuz kaldı: ₺${(widget.kalanBorc ?? 0).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(
                                                context,
                                              ).pop(); // Önce dialogu kapat
                                              Navigator.of(context).pop(
                                                'odeme_basarili',
                                              ); // Sonra PaymentPage'i kapat
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Kapat'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                  // HomePage'e yönlendirme kodunu kaldırıyoruz
                                  // Navigator.of(context).pushAndRemoveUntil(...);
                                } else {
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
                                        productName: productName,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Lütfen bilgileri eksiksiz ve doğru girin',
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 1),
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
        currentIndex: 3,
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

String _getProductName(BuildContext context) {
  // SepetimPage'den gelen ürün adı varsa onu kullan
  final ModalRoute<Object?>? route = ModalRoute.of(context);
  if (route != null && route.settings.arguments is Map) {
    final args = route.settings.arguments as Map;
    if (args['title'] != null && args['title'] is String) {
      return args['title'] as String;
    }
  }
  // Sepetteki tüm ürünlerin adını virgül ile birleştir
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  if (cartProvider.items.isNotEmpty) {
    return cartProvider.items.map((e) => e.name).join(', ');
  }
  return 'Ürün';
}
