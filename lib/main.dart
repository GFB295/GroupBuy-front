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
import 'src/screens/my_purchases_screen.dart';
import 'src/screens/test_my_purchases_screen.dart';
import 'src/screens/notifications_screen.dart';
import 'src/screens/profile_screen.dart';
import 'src/screens/admin_dashboard_screen.dart';
import 'src/screens/admin_user_management_screen.dart';
import 'src/screens/admin_employee_management_screen.dart';
import 'src/screens/admin_group_product_management_screen.dart';
import 'src/screens/admin_roles_permissions_screen.dart';
import 'src/screens/admin_stats_screen.dart';
import 'src/screens/manager_dashboard_screen.dart';
import 'src/screens/manager_product_management_screen.dart';
import 'src/screens/manager_order_tracking_screen.dart';
import 'src/screens/manager_profile_screen.dart';
import 'src/screens/manager_stats_screen.dart';
import 'src/screens/category_demo_screen.dart';
import 'src/screens/home_screen_with_categories.dart';
import 'src/widgets/category_selector.dart';
import 'src/widgets/icon_category_selector.dart';
import 'src/widgets/image_test_widget.dart';
import 'src/screens/image_diagnostic_screen.dart';
import 'src/screens/simple_image_test_screen.dart';
import 'src/screens/payment_screen.dart';

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
        '/payment': (context) => const PaymentScreen(),
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
        '/my-purchases': (context) => const MyPurchasesScreen(),
        '/test-my-purchases': (context) => const TestMyPurchasesScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/profile': (context) => const ProfileScreen(),

        // Admin routes
        '/admin-dashboard': (context) => const AdminDashboardScreen(),
        '/admin-users': (context) => const AdminUserManagementScreen(),
        '/admin-employees': (context) => const AdminEmployeeManagementScreen(),
        '/admin-group-products': (context) => const AdminGroupProductManagementScreen(),
        '/admin-roles': (context) => const AdminRolesPermissionsScreen(),
        '/admin-stats': (context) => const AdminStatsScreen(),
        // Manager routes
        '/manager-dashboard': (context) => const ManagerDashboardScreen(),
        '/manager-products': (context) => const ManagerProductManagementScreen(),
        '/manager-orders': (context) => const ManagerOrderTrackingScreen(),
        '/manager-profile': (context) => const ManagerProfileScreen(),
        '/manager-stats': (context) => const ManagerStatsScreen(),
        // Routes de démonstration
        '/category-demo': (context) => const CategoryDemoScreen(),
        '/home-with-categories': (context) => const HomeScreenWithCategories(),
        '/test-categories': (context) => const HomeScreen(),
        '/test-images': (context) => const ImageTestWidget(),
        '/image-diagnostic': (context) => const ImageDiagnosticScreen(),
        '/simple-image-test': (context) => const SimpleImageTestScreen(),
      },
    );
  }
}
