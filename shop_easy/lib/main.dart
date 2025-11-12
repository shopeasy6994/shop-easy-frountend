import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_easyy/providers/auth_provider.dart';
import 'package:shop_easyy/providers/cart_provider.dart';
import 'package:shop_easyy/providers/home_provider.dart';
import 'package:shop_easyy/providers/order_provider.dart';
import 'package:shop_easyy/providers/product_provider.dart';
import 'package:shop_easyy/providers/wishlist_provider.dart';
import 'package:shop_easyy/utils/app_router.dart';
import 'package:shop_easyy/utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        // OrderProvider depends on AuthProvider for the token
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (_) => OrderProvider(null),
          update: (_, auth, previousOrders) => OrderProvider(auth),
        ),
      ],
      child: MaterialApp.router(
        title: 'Shop Easy',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
