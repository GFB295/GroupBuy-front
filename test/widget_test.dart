import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_front/main.dart';

void main() {
  testWidgets('L\'application démarre et affiche l\'écran d\'accueil', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GroupBuyApp());

    // Vérifie que le titre de l'écran d'accueil est présent
    expect(find.text('Achats groupés'), findsOneWidget);
  });
}