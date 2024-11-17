import 'package:flutter/material.dart';
import 'package:velvet/features/auth/presentation/screen/usuario.dart';
import 'package:velvet/features/formulario/servicios/pedidos.dart';
import 'package:velvet/features/formulario/servicios/producto.dart';
import 'package:velvet/features/formulario/servicios/servicios.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  MyBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  double _elevation = 0;

  void _navigateToScreen(BuildContext context, int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = ServiciosScreen();
        break;
      case 1:
        screen = ProductosScreen();
        break;
      case 2:
        screen = PedidosScreen();
        break;
      case 3:
        screen = UsuarioScreen();
        break;
      default:
        screen = ServiciosScreen();
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 168, 76, 175),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: _elevation,
            spreadRadius: _elevation / 2,
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.room_service),
            label: 'Servicios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pedido',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuario',
          ),
        ],
        currentIndex: widget.selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (index) {
          setState(() {
            _elevation = 8; // Aumenta la elevación al hacer clic
          });
          widget.onItemTapped(index);
          _navigateToScreen(context, index);
          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) {
              setState(() {
                _elevation =
                    0; // Vuelve a la elevación normal después de un breve momento
              });
            }
          });
        },
      ),
    );
  }
}
