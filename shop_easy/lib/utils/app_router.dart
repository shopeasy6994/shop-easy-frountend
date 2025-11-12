import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop_easyy/models/address.dart';
import 'package:shop_easyy/providers/auth_provider.dart';
import 'package:shop_easyy/screens/auth/login_screen.dart';
import 'package:shop_easyy/screens/auth/welcome_screen.dart';
import 'package:shop_easyy/screens/main_screen.dart';
import 'package:shop_easyy/screens/products/product_detail_screen.dart';
import 'package:shop_easyy/screens/profile/add_edit_address_screen.dart';
import 'package:shop_easyy/screens/profile/address_screen.dart';
import 'package:shop_easyy/screens/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScreen(),
        // ADD THE NEW NESTED ROUTE
        routes: [
          GoRoute(
            path: 'product/:productId', // e.g., /home/product/123
            builder: (context, state) {
              final productId = state.pathParameters['productId']!;
              return ProductDetailScreen(productId: productId);
            },
          ),
          GoRoute(
              path: 'profile/addresses',
              builder: (context, state) => const AddressScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const AddEditAddressScreen(),
                ),
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    final address = state.extra as Address?;
                    return AddEditAddressScreen(address: address);
                  },
                ),
              ]),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final authProvider = context.read<AuthProvider>();
      final bool loggedIn = authProvider.isAuthenticated;
      final bool isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/welcome' ||
          state.matchedLocation == '/splash';

      if (!loggedIn && !isLoggingIn) {
        return '/welcome';
      }

      if (loggedIn &&
          (state.matchedLocation == '/login' ||
              state.matchedLocation == '/welcome')) {
        return '/home';
      }

      return null;
    },
  );
}
