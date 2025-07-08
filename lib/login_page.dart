import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Görseldeki ekmekli arka planın en boy oranına göre yüksekliği hesaplayın
    // Yaklaşık olarak 408.89 / 440.73 oranı kullanıldı.
    final double imageHeight = screenWidth * (408.89 / 440.73); 

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Arka plan rengi
      body: Stack(
        children: [
          // Üstte ekmekli arka plan resmi
          SizedBox(
            width: screenWidth,
            height: imageHeight,
            child: Image.asset(
              'assets/images/bread_background.png', // Resim yolu
              fit: BoxFit.cover, // Resmin kutuyu doldurmasını sağlar
            ),
          ),
          // Beyaz kart ve form alanı
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView( // İçerik kaydırılabilir olsun diye
              child: Container(
                width: screenWidth,
                // Beyaz kartın üst kenarının, resmin alt kenarından biraz yukarıda olmasını sağlar
                margin: EdgeInsets.only(top: imageHeight - 40), 
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                decoration: const BoxDecoration(
                  color: Colors.white, // Beyaz kartın rengi
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36), // Üst sol köşeyi yuvarla
                    topRight: Radius.circular(36), // Üst sağ köşeyi yuvarla
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12, // Gölge rengi
                      blurRadius: 24, // Gölge bulanıklığı
                      offset: Offset(0, -8), // Gölge konumu
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // İçeriği sola hizala
                    children: [
                      const Text(
                        'E-Kantin',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8), // Boşluk
                      const Text(
                        'Lütfen Giriş Yapınız !',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24), // Boşluk
                      // Kullanıcı Adı TextField
                      _buildTextField('Kullanıcı Adı'),
                      const SizedBox(height: 16), // Boşluk
                      // Şifre TextField
                      _buildTextField('Şifre', obscureText: true),
                      const SizedBox(height: 10), // Boşluk
                      Row(
                        children: [
                          Transform.scale(
                            scale: 0.9, // Switch boyutunu küçült
                            child: Switch(
                              value: _rememberMe,
                              onChanged: (val) {
                                setState(() {
                                  _rememberMe = val; // Switch durumunu güncelle
                                });
                              },
                              activeColor: Colors.redAccent, // Aktif renk
                              inactiveThumbColor: Colors.grey[300], // Pasif başparmak rengi
                              inactiveTrackColor: Colors.grey[200], // Pasif iz rengi
                            ),
                          ),
                          const SizedBox(width: 4), // Boşluk
                          const Text(
                            'Kullanıcı Adı / Şifre Kaydet',
                            style: TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18), // Boşluk
                      // Giriş Butonu
                      SizedBox(
                        width: double.infinity, // Genişliği doldur
                        height: 48, // Yükseklik
                        child: ElevatedButton(
                          onPressed: () {
                            // Giriş butonu tıklandığında yapılacak işlemler
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent, // Buton arka plan rengi
                            foregroundColor: Colors.white, // Buton yazı rengi
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Buton köşelerini yuvarla
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 0, // Gölge yok
                          ),
                          child: const Text('Giriş'),
                        ),
                      ),
                      const SizedBox(height: 32), // Boşluk
                      // Parmak izi ikonu
                      Center(
                        child: Icon(
                          Icons.fingerprint,
                          size: 56,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 8), // Boşluk
                      // Alt çizgi (home indicator gibi)
                      Center(
                        child: Container(
                          width: 40, // Genişlik
                          height: 4, // Yükseklik
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Renk
                            borderRadius: BorderRadius.circular(2), // Köşeleri yuvarla
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Standart TextField widget'ı
  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100], // TextField'ın arka plan rengi
        borderRadius: BorderRadius.circular(12), // Köşeleri yuvarla
        border: Border.all(color: Colors.grey[300]!), // Kenarlık
      ),
      child: TextField(
        obscureText: obscureText, // Şifre alanı ise metni gizle
        decoration: InputDecoration(
          border: InputBorder.none, // Kenarlığı kaldır
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), // İç boşluk
          hintText: hintText, // İpucu metni
          hintStyle: const TextStyle(color: Colors.grey), // İpucu metni stili
        ),
        style: const TextStyle(
          color: Colors.black, // Yazı rengi
        ),
      ),
    );
  }
}

// Bu widget artık kullanılmıyor, çünkü ana LoginPage içinde entegre edildi.
// class DisplayDownBar extends StatelessWidget {
//   const DisplayDownBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: 0,
//       bottom: 0,
//       child: Container(
//         width: 375,
//         height: 34,
//         color: Colors.grey[300],
//         child: Center(
//           child: Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey[500],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
