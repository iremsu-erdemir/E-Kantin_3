import 'package:flutter/material.dart';
import 'services/user_service.dart';
import 'models/user.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageHeight = screenWidth * (408.89 / 440.73);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
            child: SingleChildScrollView(
              // İçerik kaydırılabilir olsun diye
              child: Container(
                width: screenWidth,
                // Beyaz kartın üst kenarının, resmin alt kenarından biraz yukarıda olmasını sağlar
                margin: EdgeInsets.only(top: imageHeight - 40),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 0,
                ),
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // İçeriği sola hizala
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
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 48,
                      ), // veya 56, 64... (gözünüze en uygun olanı seçin)
                      Align(
                        alignment: Alignment.center,
                        child: _buildTextField(
                          controller: _usernameController,
                          hintText: 'Kullanıcı Adı',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Şifre',
                        obscureText: true,
                      ),
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
                              inactiveThumbColor:
                                  Colors.grey[300], // Pasif başparmak rengi
                              inactiveTrackColor:
                                  Colors.grey[200], // Pasif iz rengi
                            ),
                          ),
                          const SizedBox(width: 4), // Boşluk
                          const Text(
                            'Kullanıcı Adı / Şifre Kaydet',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18), // Boşluk
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      // Giriş Butonu
                      SizedBox(
                        width: double.infinity, // Genişliği doldur
                        height: 48, // Yükseklik
                        child: ElevatedButton(
                          onPressed: _loading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.redAccent, // Buton arka plan rengi
                            foregroundColor: Colors.white, // Buton yazı rengi
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Buton köşelerini yuvarla
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 0, // Gölge yok
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Giriş'),
                        ),
                      ),
                      const SizedBox(height: 32), // Boşluk
                      Center(
                        child: Image.asset(
                          'assets/images/Fingerprint.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Image.asset(
                          'assets/images/DisplayDown.png',
                          width: 375,
                          height: 34,
                          fit: BoxFit.contain,
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

  Future<void> _handleLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final user = await UserService().login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() {
      _loading = false;
    });
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage(user: user)),
      );
    } else {
      setState(() {
        _error = 'Kullanıcı adı veya şifre hatalı!';
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width - 48, // 24 px sağ ve sol padding
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Oval köşe
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ), // Gri çerçeve
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black26),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
          isDense: true,
        ),
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        cursorColor: Colors.redAccent,
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
