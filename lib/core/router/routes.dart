import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pocket_fm/core/router/routes_name.dart';
import 'package:pocket_fm/features/cart/presentation/cart_screen.dart';
import 'package:pocket_fm/features/landing/provider/landing_provider.dart';
import 'package:pocket_fm/features/products/presentation/product_details.dart';
import 'package:pocket_fm/features/products/presentation/product_screen.dart';
import 'package:pocket_fm/features/profile/presentation/profile.dart';
import 'package:pocket_fm/features/landing/presentation/landing_screen.dart';
import 'package:provider/provider.dart';

final routerKey = GlobalKey<NavigatorState>();
final shellRouteKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(navigatorKey: routerKey, initialLocation: RoutesName.product, routes: [adminShellRoute]);
}

final adminShellRoute = ShellRoute(
  navigatorKey: shellRouteKey,
  builder: (context, state, child) {
    return ChangeNotifierProvider(
      create: (context) => LandingProvider(),
      builder: (context, c) {
        return LandingScreen(child: child);
      },
    );
  },
  routes: [
    GoRoute(
      path: RoutesName.product,
      name: RoutesName.product,
      builder: (context, state) {
        return const ProductScreen();
      },
      routes: [
        GoRoute(
          path: RoutesName.productDetail,
          name: RoutesName.productDetail,
          builder: (context, state) {
            final String id = state.uri.queryParameters['id'] ?? "";
            return ProductDetails(id: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: RoutesName.cart,
      name: RoutesName.cart,
      builder: (context, state) {
        return const CartScreen();
      },
    ),
    GoRoute(path: RoutesName.profile, name: RoutesName.profile, builder: (context, state) => const ProfileScreen()),
  ],
);
