import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/utils/app_theme.dart';
import 'src/models/product.dart';
import 'src/screens/splash_screen.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/register_screen.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/product_detail_screen.dart';
import 'src/screens/join_group_screen.dart';
import 'src/screens/payment_success_screen.dart';
import 'src/screens/cart_screen.dart';
import 'src/screens/favorites_screen.dart';
import 'src/screens/order_tracking_screen.dart';
import 'src/screens/notifications_screen.dart';
import 'src/screens/profile_screen.dart';

void main() {
  runApp(const ProviderScope(child: GroupBuyApp()));
}

class GroupBuyApp extends StatelessWidget {
  const GroupBuyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achat Groupé',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/product-detail': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as Product;
          return ProductDetailScreen(product: product);
        },
        '/join-group': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as Product;
          return JoinGroupScreen(product: product);
        },
        '/payment-success': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as Product;
          return PaymentSuccessScreen(product: product);
        },
        '/cart': (context) => const CartScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/orders': (context) => const OrderTrackingScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
