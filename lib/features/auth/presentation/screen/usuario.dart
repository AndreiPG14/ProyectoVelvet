import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:velvet/features/auth/presentation/screen/login_screen.dart';
import 'package:velvet/features/shared/widgets/bottom_navigation_bar.dart'; // Asegúrate de importar el provider correcto

class UsuarioScreen extends ConsumerStatefulWidget {
  const UsuarioScreen({Key? key}) : super(key: key);

  @override
  _UsuarioScreenState createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends ConsumerState<UsuarioScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Usuario'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido, ${user?.nombre ?? 'Usuario'}',
            ),
            Text(
              'Email: ${user?.email ?? ''}',
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                  width: 200,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 168, 76, 175),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          ref.read(authProvider.notifier).logoutUser();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Text(
                          "Cerrar Sesión",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ))),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
