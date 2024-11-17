import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velvet/features/formulario/pedido.dart';
import 'package:velvet/features/formulario/servicios/servicios_controller.dart';
import 'package:velvet/features/shared/widgets/bottom_navigation_bar.dart';

class ServiciosScreen extends ConsumerStatefulWidget {
  final item;
  const ServiciosScreen({super.key, this.item});

  @override
  _ServiciosScreenState createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends ConsumerState<ServiciosScreen> {
  late ServiciosController con;
  bool isLoading = true;
  String errorMessage = '';
  int _selectedIndex = 0;
  String _searchText = '';
  TextEditingController _searchController = TextEditingController();
  bool _isMounted = false; // Flag para verificar si el widget está montado

  @override
  void initState() {
    super.initState();
    con = ServiciosController();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await con.init(context);
        if (_isMounted) {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        if (_isMounted) {
          setState(() {
            errorMessage = 'Error loading services: $e';
            isLoading = false;
          });
        }
      }
    });

    _isMounted = true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _isMounted = false; 

    super.dispose();
  }

  List<dynamic> get filteredServicios {
    return con.servicios
        .where((servicio) =>
            servicio['name'].toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : con.servicios.isEmpty
                  ? Center(child: Text('No hay servicios disponibles'))
                  : Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Buscar servicios',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchText = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListView.builder(
                              itemCount: filteredServicios.length,
                              itemBuilder: (context, i) {
                                final servicio = filteredServicios[i];
                                final double basePrice = double.tryParse(
                                        servicio['base_price'] ?? '0.0') ??
                                    0.0;

                                return Column(
                                  children: [
                                    ListTile(
                                      title:
                                          Text(servicio['name'] ?? 'No name'),
                                      subtitle: Text(
                                          'Precio: S/${basePrice.toStringAsFixed(2)}'),
                                      trailing: IconButton(
                                        icon: Icon(Icons.add_circle,
                                            color: Colors.green),
                                        onPressed: () {
                                          final pedido = Pedido(
                                            name: servicio['name'],
                                            basePrice: basePrice,
                                            quantity: 1,
                                          );
                                          ref
                                              .read(pedidosProvider.notifier)
                                              .addPedido(pedido);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(Icons.check_circle,
                                                      color: Colors.white),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      '${servicio['name']} agregado correctamente',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              duration: Duration(seconds: 2),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      onTap: () {
                                        print(
                                            'Servicio seleccionado: ${servicio['name']}');
                                      },
                                    ),
                                    Divider(height: 0),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
