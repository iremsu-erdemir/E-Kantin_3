import '../models/user.dart';

class UserService {
  // Şu an sabit kullanıcı, ileride backend ile değiştirilecek
  final List<User> _dummyUsers = [
    User(
      username: 'erdem',
      password: '1234',
      name: 'Erdem',
      role: 'admin',
      image: 'assets/images/person.png',
    ),
    User(
      username: 'cengiz',
      password: '1234',
      name: 'Cengiz Demir',
      role: 'Yazılım Şube Müdürü',
      image: 'assets/images/cengizBey.png',
    ),
    User(
      username: 'turgay',
      password: '1234',
      name: 'Turgay Tülü',
      role: 'Kültür ve Sosyal İşler Şube Müdürü',
      image: 'assets/images/turgay.png',
    ),
    User(
      username: 'taner',
      password: '1234',
      name: 'Taner Mutlu',
      role: 'Personel',
      image: 'assets/images/person.png',
    ),
    User(
      username: 'esma',
      password: '1234',
      name: 'Esma Nur Kayhan',
      role: 'Personel',
      image: 'assets/images/person.png',
    ),
    User(
      username: 'erkan',
      password: '1234',
      name: 'Erkan Öztürk',
      role: 'Personel',
      image: 'assets/images/person.png',
    ),
  ];

  Future<User?> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simülasyon
    try {
      return _dummyUsers.firstWhere(
        (u) => u.username == username && u.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  List<User> getAllUsers() {
    return _dummyUsers;
  }
}
