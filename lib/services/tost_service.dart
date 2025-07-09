import '../models/tost.dart';

class TostService {
  Future<List<Tost>> fetchTostlar() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simülasyon
    return [
      Tost(
        image: 'assets/images/tostmenu.png',
        title: 'Menü 1',
        desc: 'Az kaşar peyniri, az çeçil peynir, tam beyaz peynir',
        price: '₺85,50',
        stock: true,
      ),
      Tost(
        image: 'assets/images/tostmenu.png',
        title: 'Menü 2',
        desc: 'Az kaşar peyniri, az çeçil peynir, tam beyaz peynir',
        price: '₺85,50',
        stock: true,
      ),
      Tost(
        image: 'assets/images/tostmenu.png',
        title: 'Menü 3',
        desc: 'Az kaşar peyniri, az çeçil peynir, tam beyaz peynir',
        price: '₺85,50',
        stock: true,
      ),
      Tost(
        image: 'assets/images/tostmenu.png',
        title: 'Menü 4',
        desc: 'Az kaşar peyniri, az çeçil peynir, tam beyaz peynir',
        price: '₺85,50',
        stock: false,
      ),
      Tost(
        image: 'assets/images/tostmenu.png',
        title: 'Menü 5',
        desc: 'Az kaşar peyniri, az çeçil peynir, tam beyaz peynir',
        price: '₺85,50',
        stock: true,
      ),
    ];
  }
}
