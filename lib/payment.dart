import 'package:flutter/material.dart';
import 'successpayment.dart';
import 'cart.dart';
import 'models/cart.dart';

class PaymentPage extends StatefulWidget {
  final double totalPrice;
  const PaymentPage({Key? key, required this.totalPrice}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedCard = 'Kredi Kartım';
  final List<String> savedCards = ['Kredi Kartım', 'Ek Kartım'];
  final TextEditingController nameController = TextEditingController(
    text: 'CENGİZ DEMİR',
  );
  final TextEditingController cardController = TextEditingController(
    text: '5400',
  );
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  String? nameError, cardError, dateError, cvcError;

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
    if (!RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})').hasMatch(date)) {
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

  @override
  Widget build(BuildContext context) {
    final double totalPrice = widget.totalPrice;
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Kayıtlı Kartlarım',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCard,
              items: savedCards.map((card) {
                return DropdownMenuItem<String>(
                  value: card,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.credit_card, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          card,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        if (card == 'Kredi Kartım')
                          const Text(
                            '************436',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              letterSpacing: 2,
                            ),
                          ),
                        if (card == 'Ek Kartım')
                          const Text(
                            '************123',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              letterSpacing: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedCard = val!;
                });
              },
              decoration: const InputDecoration(border: InputBorder.none),
              dropdownColor: Colors.transparent,
              iconEnabledColor: Colors.redAccent,
            ),
            const SizedBox(height: 28),
            const Text(
              'Başka Kartla Ödeme Yap',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'KART SAHİBİNİN ADI SOYADI',
                      border: InputBorder.none,
                      errorText: nameError,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  TextField(
                    controller: cardController,
                    decoration: InputDecoration(
                      labelText: 'KART NUMARASI',
                      border: InputBorder.none,
                      errorText: cardError,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    onChanged: (_) => setState(() {}),
                  ),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: 'GEÇERLİLİK TARİHİ',
                            border: InputBorder.none,
                            hintText: 'MM/YY',
                            errorText: dateError,
                          ),
                          keyboardType: TextInputType.datetime,
                          maxLength: 5,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: cvcController,
                          decoration: InputDecoration(
                            labelText: 'CVC',
                            border: InputBorder.none,
                            errorText: cvcError,
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Text(
                  '₺${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: totalPrice == 0 || !isFormValid
                        ? null
                        : () {
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
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
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
                      child: Text('Ödeme Yap'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
