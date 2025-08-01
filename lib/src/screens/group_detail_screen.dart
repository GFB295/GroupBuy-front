import 'package:flutter/material.dart';
import '../utils/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupDetailScreen extends StatelessWidget {
  final String groupName;
  final int participants;
  final List<Map<String, dynamic>> products;
  final double price;

  const GroupDetailScreen({
    Key? key,
    this.groupName = 'Achat groupé 1',
    this.participants = 5,
    this.products = const [
      {'name': 'Produit 1', 'price': 20.0},
      {'name': 'Produit 2', 'price': 35.0},
    ],
    this.price = 15.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppPalette.primary, AppPalette.mint],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppPalette.grey,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groupName,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.group, color: AppPalette.accent),
                            const SizedBox(width: 8),
                            Text('$participants participants', style: GoogleFonts.poppins()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text('Produits', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 8),
                        ...products.map((p) => ListTile(
                              leading: const Icon(Icons.shopping_bag, color: AppPalette.primary),
                              title: Text(p['name'], style: GoogleFonts.poppins()),
                              trailing: Text('${p['price']} €', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                            )),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPalette.accent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            child: Text('Rejoindre pour $price €'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                child: Icon(Icons.groups, size: 48, color: AppPalette.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 