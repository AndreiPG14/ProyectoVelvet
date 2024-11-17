import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:velvet/config/router/app_router_notifier.dart';
import 'package:velvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:velvet/features/auth/presentation/screen/check_auth_status.dart';
import 'package:velvet/features/auth/presentation/screen/login_screen.dart';
import 'package:velvet/features/auth/presentation/screen/usuario.dart';
import 'package:velvet/features/formulario/servicios/pedidos.dart';
import 'package:velvet/features/formulario/servicios/producto.dart';
import 'package:velvet/features/formulario/servicios/servicios.dart';
import 'package:velvet/features/formulario/sucursal/sucursal.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterProviderS);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) =>
            const MaterialPage(child: CheckAuthStatus()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            const MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/form-sucursal',
        pageBuilder: (context, state) =>
            const MaterialPage(child: SucursalScreen()),
      ),
      GoRoute(
        path: '/servicios',
        pageBuilder: (context, state) =>
            const MaterialPage(child: ServiciosScreen()),
      ),
      GoRoute(
        path: '/producto',
        pageBuilder: (context, state) =>
            const MaterialPage(child: ProductosScreen()),
      ),
      GoRoute(
        path: '/pedidos',
        pageBuilder: (context, state) =>
            const MaterialPage(child: PedidosScreen()),
      ),
      GoRoute(
        path: '/usuario',
        pageBuilder: (context, state) =>
            const MaterialPage(child: UsuarioScreen()),
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.uri.path;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.cheking) {
        return null;
      }
      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login') {
          return null;
        } else {
          return '/login';
        }
      }
      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/splash') {
          return '/form-sucursal'; // Redirige al SucursalScreen
        } else {
          return null;
        }
      }

      return null;
    },
  );
});
