import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/order_provider.dart';
import '../providers/tracking_provider.dart';

class TestMyPurchasesScreen extends ConsumerWidget {
  const TestMyPurchasesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);
    final trackingData = ref.watch(trackingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Test - Mes Achats',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0EA5E9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test des États - Section "Mes Achats"',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 20),
            
            // État 1 : Aucune commande
            _buildTestSection(
              context,
              'État 1 : Aucune commande',
              'Simule l\'état quand l\'utilisateur n\'a pas encore de commandes',
              () => _testEmptyState(ref),
              const Color(0xFF10B981),
            ),
            
            const SizedBox(height: 16),
            
            // État 2 : Liste de commandes
            _buildTestSection(
              context,
              'État 2 : Liste de commandes',
              'Affiche les commandes avec données de démonstration',
              () => _testOrderList(ref),
              const Color(0xFF0EA5E9),
            ),
            
            const SizedBox(height: 16),
            
            // État 3 : Tracking
            _buildTestSection(
              context,
              'État 3 : Tracking',
              'Teste l\'écran de suivi avec Google Maps',
              () => _testTracking(context),
              const Color(0xFF8B5CF6),
            ),
            
            const SizedBox(height: 20),
            
            // Informations de debug
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informations de Debug',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Commandes actives: ${orders.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    'Données de tracking: ${trackingData.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Bouton pour aller à la vraie page
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/my-purchases'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.visibility, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Voir la vraie page "Mes Achats"',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection(
    BuildContext context,
    String title,
    String description,
    VoidCallback onTap,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Tester',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _testEmptyState(WidgetRef ref) {
    ref.read(orderProvider.notifier).clearHistory();
    ScaffoldMessenger.of(ref.context).showSnackBar(
      const SnackBar(
        content: Text('État vide activé - Aucune commande affichée'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _testOrderList(WidgetRef ref) {
    ref.read(orderProvider.notifier).resetToDemoData();
    ScaffoldMessenger.of(ref.context).showSnackBar(
      const SnackBar(
        content: Text('Liste de commandes chargée avec données de démonstration'),
        backgroundColor: Color(0xFF0EA5E9),
      ),
    );
  }

  void _testTracking(BuildContext context) {
    Navigator.pushNamed(context, '/my-purchases');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigation vers la page de tracking'),
        backgroundColor: Color(0xFF8B5CF6),
      ),
    );
  }
} 