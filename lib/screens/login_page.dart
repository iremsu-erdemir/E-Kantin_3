import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import '../components/ek_bottom_nav_bar.dart';
import 'home_page.dart' hide EKBottomNavBar;

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
    final double breadImageWidth = 440.73;
    final double breadImageHeight = 600.00;
    final double cardWidth = breadImageWidth;
    final double cardHeight = 447;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Ekmek görseli
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bread_background.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.42,
              fit: BoxFit.cover,
            ),
          ),
          // Container (form)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.36,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 24,
                      offset: Offset(0, -8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'E-Kantin',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Lütfen Giriş Yapınız !',
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                      const SizedBox(height: 48),
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
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 0.9,
                            child: Switch(
                              value: _rememberMe,
                              onChanged: (val) {
                                setState(() {
                                  _rememberMe = val;
                                });
                              },
                              activeColor: Colors.redAccent,
                              inactiveThumbColor: Colors.grey[300],
                              inactiveTrackColor: Colors.grey[200],
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Kullanıcı Adı / Şifre Kaydet',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
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
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 0,
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
                      const SizedBox(height: 32),
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
      UserSingleton().user = user;
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
      width: MediaQuery.of(context).size.width - 48,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
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
