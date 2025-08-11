import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/features/auth/auth.dart';
import 'package:teslo_app/features/auth/presentation/providers/providers.dart';
import 'package:teslo_app/features/products/products.dart';

import 'app_router_notifier.dart';

// provider para rutas protegidas
final goRouterProvider = Provider((ref){
  final goRouterNotifier = ref.read(goRouterNotifierProvider);


  return GoRouter(
    initialLocation: '/checking',
    // refreshListenable espera algo de tipo ChangeNotifier
    // cuando cambia evalua nuevamente el redirect
    refreshListenable: goRouterNotifier, 
    routes: [
      ///* Primera pantalla
      GoRoute(
        path: '/checking',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state){
          final productId = state.pathParameters['id'];

          return ProductScreen(productId: productId ?? 'no-id');
        },
      ),
    ],


    redirect: (context,state) {
      final isGointTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      // checking del estatus de auth
      if(isGointTo == '/checking' && authStatus == AuthStatus.checking) return null;

      // si no estamos autenticados y estamos
      if(authStatus == AuthStatus.notAuthenticated){
        if(isGointTo == '/login' || isGointTo == '/register') return null;

        return '/login';
      }
      
      // si estamos autenticados
      if(authStatus == AuthStatus.authenticated) {
        if(isGointTo == '/login' || isGointTo == '/register' || isGointTo == '/checking') return '/';

        return null;
      }

      return null;  
    }
  );
});

