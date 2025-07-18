import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../models/borc.dart';

class AdminCayAlacakDetayPage extends StatefulWidget {
  final String username;
  final String name;
  const AdminCayAlacakDetayPage({
    Key? key,
    required this.username,
    required this.name,
  }) : super(key: key);

  @override
  State<AdminCayAlacakDetayPage> createState() =>
      _AdminCayAlacakDetayPageState();
}

class _AdminCayAlacakDetayPageState extends State<AdminCayAlacakDetayPage> {
  List<Borc> borclar = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadBorclar();
  }

  Future<void> _loadBorclar() async {
    setState(() => loading = true);
    borclar = await LocalStorageService.getUserDebts(widget.username);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          '${widget.name} Borç Detayı',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : borclar.isEmpty
          ? const Center(child: Text('Borç bulunamadı.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: borclar.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final b = borclar[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.urun,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              softWrap: true,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              b.tarih,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₺${b.tutar.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
