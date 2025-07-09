import '../models/sandwich.dart';

class SandwichService {
  Future<List<Sandwich>> fetchSandwiches() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simülasyon
    return [
      Sandwich(
        image: 'assets/images/sandwichMenu.png',
        title: 'Menü 1',
        desc: 'Az kaşar peyniri, az çeçil peynir, tam beyaz peynir',
        price: '₺85,50',
        stock: true,
      ),
      Sandwich(
        image: 'assets/images/sandwichMenu.png',
        title: 'Menü 2',
        desc: 'Az kaşar peyniri, az çeçil peynir, tam beyaz peynir',
        price: '₺85,50',
        stock: true,
      ),
      Sandwich(
        image: 'assets/images/sandwichMenu.png',
        title: 'Menü 3',
        desc: 'Az kaşar peyniri, az çeçil peynir, tam beyaz peynir',
        price: '₺85,50',
        stock: false,
      ),
      Sandwich(
        image: 'assets/images/sandwichMenu.png',
        title: 'Menü 4',
        desc: 'Az kaşar peyniri, az çeçil peynir, tam beyaz peynir',
        price: '₺85,50',
        stock: true,
      ),
      Sandwich(
        image: 'assets/images/sandwichMenu.png',
        title: 'Menü 5',
        desc: 'Az kaşar peyniri, az çeçil peynir, tam beyaz peynir',
        price: '₺85,50',
        stock: true,
      ),
    ];
  }
}
