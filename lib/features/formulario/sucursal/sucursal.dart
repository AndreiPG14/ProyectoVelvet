import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:velvet/features/formulario/servicios/servicios.dart';
import 'package:velvet/features/formulario/sucursal/sucursal_controller.dart';

class SucursalScreen extends ConsumerStatefulWidget {
  final item;
  const SucursalScreen({super.key, this.item});

  @override
  _SucursalScreenState createState() => _SucursalScreenState();
}

class _SucursalScreenState extends ConsumerState<SucursalScreen> {
  late SucursalController con;

  @override
  void initState() {
    super.initState();
    con = SucursalController(ref);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await con.init();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/velvet_png.png',
              width: 200,
              height: 200,
            ),
            Text(
              "Selecciona una sucursal!",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: DropDownTextField(
                controller: con.officesController,
                clearOption: true,
                textFieldDecoration: const InputDecoration(
                  hintText: "Sucursal",
                  isCollapsed: true,
                  contentPadding: EdgeInsets.all(12),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, seleccione una oficina";
                  }
                  return null;
                },
                dropDownItemCount: 5,
                dropDownList: con.dropdownOffices,
                onChanged: (val) {
                  if (val != null) {
                    print('Oficina seleccionada: ${val.value}');
                  }
                },
              ),
            ),
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
                    onPressed: () async {
                      final success = await con.setOfficeLogin();
                      if (success) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiciosScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Error al seleccionar la sucursal. Intente nuevamente.'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Acceder",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
