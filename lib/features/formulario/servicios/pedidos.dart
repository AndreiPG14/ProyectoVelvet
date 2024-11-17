import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:velvet/features/formulario/pedido.dart';
import 'package:velvet/features/formulario/servicios/pedidos_controller.dart';
import 'package:velvet/features/shared/widgets/bottom_navigation_bar.dart';

class PedidosScreen extends ConsumerStatefulWidget {
  final item;
  const PedidosScreen({super.key, this.item});

  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends ConsumerState<PedidosScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  String errorMessage = '';
  int _selectedIndex = 2;
  PedidosController con = PedidosController();

  @override
  void initState() {
    super.initState();
    con = PedidosController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await con.getClientes();
      await con.getDocumento();
    });
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    con.clientesController.dispose();
    con.tipoDocumentoController.dispose();
    con.nombre.dispose();
    con.apellidos.dispose();
    con.email.dispose();
    con.telefono.dispose();
    con.direccion.dispose();
    con.credito.dispose();
    con.documento.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.authStatus == AuthStatus.notAuthenticated) {
        ref.read(pedidosProvider.notifier).clearPedidos();
      }
    });
    final pedidos = ref.watch(pedidosProvider);
    double total = pedidos.fold(
        0, (sum, pedido) => sum + (pedido.basePrice * pedido.quantity));
    double igv = total * 0.18;
    double subtotal = total - igv;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Fecha",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                con.selectDate(context).then((_) {
                  if (mounted) {
                    setState(() {});
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      con.getFormattedDate(),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropDownTextField(
                    controller: con.clientesController,
                    clearOption: true,
                    searchShowCursor: true,
                    enableSearch: true,
                    padding: EdgeInsets.all(30.0),
                    searchAutofocus: true,
                    textFieldDecoration: const InputDecoration(
                      hintText: "Cliente",
                      isCollapsed: true,
                      contentPadding: EdgeInsets.all(12),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    dropDownItemCount: 5,
                    dropDownList: con.dropdownclientes,
                    onChanged: (val) async {
                      if (val != "" && mounted) {}
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleccione un cliente';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle),
                  color: Colors.green,
                  onPressed: () {
                    if (con.dropdowntipoDocumento.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Cargando datos. Por favor, espere.')),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Agregar Cliente'),
                          content: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DropDownTextField(
                                      controller: con.tipoDocumentoController,
                                      clearOption: true,
                                      searchShowCursor: true,
                                      enableSearch: true,
                                      padding: EdgeInsets.all(30.0),
                                      searchAutofocus: true,
                                      textFieldDecoration:
                                          const InputDecoration(
                                        hintText: "Tipo de Documento",
                                        isCollapsed: true,
                                        contentPadding: EdgeInsets.all(12),
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                      ),
                                      dropDownItemCount: 5,
                                      dropDownList: con.dropdowntipoDocumento,
                                      onChanged: (val) async {
                                        if (val != "") {}
                                        setState(() {});
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Seleccione un cliente';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: TextFormField(
                                        controller: con.documento,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: 'Documento',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          suffixIcon: GestureDetector(
                                            onTap: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                // Si el campo es válido, realiza la acción
                                                await con.getDatos(int.parse(
                                                    con.documento.text));
                                                if (mounted) {
                                                  setState(() {});
                                                }
                                                print(
                                                    'Icono de búsqueda presionado');
                                              }
                                            },
                                            child: Icon(Icons.search),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingrese el documento';
                                          }
                                          if (int.tryParse(value) == null) {
                                            return 'Por favor, ingrese un número válido';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: TextField(
                                        controller: con.nombre,
                                        decoration: InputDecoration(
                                          hintText: 'Nombre',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                        ),
                                        onChanged: (value) async {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: TextField(
                                        controller: con.apellidos,
                                        decoration: InputDecoration(
                                          hintText: 'Apellidos',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: TextField(
                                        controller: con.email,
                                        decoration: InputDecoration(
                                          hintText: 'Email',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: TextField(
                                        controller: con.telefono,
                                        decoration: InputDecoration(
                                          hintText: 'Teléfono',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: TextField(
                                        controller: con.direccion,
                                        decoration: InputDecoration(
                                          hintText: 'Dirección',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: TextField(
                                        controller: con.direccion,
                                        decoration: InputDecoration(
                                          hintText: 'S/. Crédito',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          actions: [
                            TextButton(
                              child: Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  setState(() {
                                    con.tipoDocumentoController
                                        .setDropDown(null);
                                    con.nombre.clear();
                                    con.apellidos.clear();
                                    con.email.clear();
                                    con.telefono.clear();
                                    con.direccion.clear();
                                    con.credito.clear();
                                    con.documento.clear();
                                  });
                                });
                              },
                            ),
                            TextButton(
                              child: Text('Agregar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : pedidos.isEmpty
                          ? Center(child: Text('No hay pedidos'))
                          : ListView.separated(
                              itemCount: pedidos.length,
                              itemBuilder: (context, i) {
                                final pedido = pedidos[i];
                                final double total =
                                    pedido.basePrice * pedido.quantity;

                                return ListTile(
                                  title: Text(pedido.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Cantidad: ${pedido.quantity.toString()}'),
                                      Text(
                                          'Precio total: S/${total.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove_circle),
                                        color: Colors.red,
                                        onPressed: () {
                                          ref
                                              .read(pedidosProvider.notifier)
                                              .decrementQuantity(pedido);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add_circle),
                                        color: Colors.green,
                                        onPressed: () {
                                          ref
                                              .read(pedidosProvider.notifier)
                                              .incrementQuantity(pedido);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.black,
                                        onPressed: () {
                                          ref
                                              .read(pedidosProvider.notifier)
                                              .removePedido(pedido);
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    print(
                                        'Pedido seleccionado: ${pedido.name}');
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                            ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subtotal: S/${subtotal.toStringAsFixed(2)}'),
                Divider(),
                Text('IGV (18%): S/${igv.toStringAsFixed(2)}'),
                Divider(),
                Text('Total: S/${total.toStringAsFixed(2)}'),
              ],
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
