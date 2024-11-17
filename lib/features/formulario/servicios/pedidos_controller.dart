import 'dart:convert';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:velvet/features/formulario/pedido.dart';
import 'package:velvet/features/shared/infrastructure/services/key_value_storage_service_impl.dart';
import 'package:velvet/services/api.dart';

class PedidosController {
  BuildContext? context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  List<dynamic> clientes = [];
  List<DropDownValueModel> dropdownclientes = [];
  SingleValueDropDownController clientesController =
      SingleValueDropDownController(data: null);
  List<dynamic> tipoDocumento = [];
  List<DropDownValueModel> dropdowntipoDocumento = [];
  SingleValueDropDownController tipoDocumentoController =
      SingleValueDropDownController(data: null);
  List<dynamic> datos = [];
  DateTime fecha = DateTime.now();
  TextEditingController documento = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController apellidos = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController direccion = TextEditingController();
  TextEditingController credito = TextEditingController();

  Future init(BuildContext context, int? empresaId) async {
    this.context = context;
    await getClientes();
    await getDocumento();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fecha,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fecha) {
      fecha = picked;
    }
  }

  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(fecha);
  }

  Future<void> getClientes() async {
    try {
      final token =
          await KeyValueStorageServiceImpl().getValue<String>('token');
      final response = await ApiController.consulta(
          'customers-list-paginated', 'get', null, token);
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final Map<String, dynamic> resp = jsonDecode(response.body);
        print('Decoded JSON: $resp');
        if (resp.containsKey('customers') &&
            resp['customers'] is Map<String, dynamic>) {
          final Map<String, dynamic> customersData = resp['customers'];

          if (customersData.containsKey('data') &&
              customersData['data'] is List) {
            final List<dynamic> clientesData = customersData['data'];

            dropdownclientes
                .clear(); // Limpia la lista antes de agregar nuevos elementos
            for (var cliente in clientesData) {
              if (cliente is Map<String, dynamic> &&
                  cliente.containsKey('fullname') &&
                  cliente.containsKey('id')) {
                dropdownclientes.add(DropDownValueModel(
                    name: cliente['fullname'], value: cliente['id']));
              }
            }
            print('Clientes cargados: ${dropdownclientes.length}');
          } else {
            print('No se encontró la lista de clientes en la respuesta');
          }
        } else {
          print('No se encontró el objeto customers en la respuesta');
        }
      } else {
        print('Error en la respuesta: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al procesar la respuesta: $e');
    }
  }

  Future<void> getDocumento() async {
    try {
      final token =
          await KeyValueStorageServiceImpl().getValue<String>('token');

      final response =
          await ApiController.consulta('types-documents', 'get', null, token);

      if (response.statusCode == 200) {
        dynamic resp = jsonDecode(response.body);
        tipoDocumento = resp;
        for (var i = 0; i < tipoDocumento.length; i++) {
          dropdowntipoDocumento.add(DropDownValueModel(
              name: tipoDocumento[i]['name'], value: tipoDocumento[i]['id']));
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getDatos(int document) async {
    try {
      final token =
          await KeyValueStorageServiceImpl().getValue<String>('token');

      final response = await ApiController.consulta(
          'customers/$document/search-document', 'get', null, token);

      if (response.statusCode == 200) {
        dynamic resp = jsonDecode(response.body);
        nombre.text = resp['name'] ?? '';
        apellidos.text = resp['surname'] ?? '';
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
final pedidosProvider = StateNotifierProvider<PedidosNotifier, List<Pedido>>((ref) {
  return PedidosNotifier();
});
  void dispose() {
    clientesController.dispose();
    tipoDocumentoController.dispose();
    documento.dispose();
    nombre.dispose();
    apellidos.dispose();
    email.dispose();
    telefono.dispose();
    direccion.dispose();
    credito.dispose();
  }
}
