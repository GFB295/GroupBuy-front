import 'package:flutter/material.dart';
import '../widgets/group_purchase_card.dart';
import '../utils/dummy_data.dart';

class GroupPurchaseScreen extends StatelessWidget {
  const GroupPurchaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achats groupés')),
      body: ListView.builder(
        itemCount: dummyGroupPurchases.length,
        itemBuilder: (context, index) {
          return GroupPurchaseCard(groupPurchase: dummyGroupPurchases[index]);
        },
      ),
    );
  }
} 