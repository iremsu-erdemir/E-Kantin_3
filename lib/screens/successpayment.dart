import 'package:flutter/material.dart';
import '../components/ek_bottom_nav_bar.dart';
import 'sepetim_page.dart';
import 'package:intl/intl.dart';
import '../models/siparis.dart';
import '../models/user.dart';
import '../services/local_storage_service.dart';
import 'siparisler.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../models/notification.dart';

class SuccessPaymentPage extends StatelessWidget {
  final double totalPrice;
  final String orderNumber;
  const SuccessPaymentPage({
    Key? key,
    required this.totalPrice,
    required this.orderNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                orderNumber,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Siparişin Başarıyla Gerçekleşmiştir !',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Siparişinizi merkez kantinden yukarıdaki takip numarası ile alabilirsiniz\nToplam: ₺${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 15, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final username = UserSingleton().user?.username ?? 'anonim';
                    final now = DateTime.now();
                    final formattedDate = DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(now);
                    final yeniSiparis = Siparis(
                      id: UniqueKey().toString(),
                      urun:
                          'Ürün', // Buraya gerçek ürün adı parametre ile gelmeli, örnek olarak 'Ürün' yazıldı
                      tutar: totalPrice,
                      durum: 'aktif',
                      img: 'assets/images/sandwich.png',
                      siparisNo: orderNumber,
                      tarih: formattedDate,
                      kayitTarihi: now.toIso8601String(),
                    );
                    await LocalStorageService.addOrder(username, yeniSiparis);
                    // Bildirim ekle
                    await Provider.of<NotificationProvider>(
                      context,
                      listen: false,
                    ).addNotification(
                      username,
                      NotificationModel(
                        title: 'Yeni Sipariş',
                        content:
                            'Yeni bir sipariş oluşturuldu: ${yeniSiparis.urun}',
                        date: now.toString(),
                      ),
                    );
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const SiparislerPage(),
                      ),
                      (route) => false,
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
                  child: const Text('Siparişlerime Git'),
                ),
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
