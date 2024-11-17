import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:velvet/features/shared/infrastructure/services/key_value_storage_service_impl.dart';
import 'package:velvet/services/api.dart';

class ProductosController {
  BuildContext? context;
  List<dynamic> productos = [];
  String errorMessage = '';
  bool isLoading = false;

  Future init(BuildContext context) async {
    this.context = context;
    isLoading = true;
    await getproductos();
    isLoading = false;
  }

  Future getproductos() async {
    try {
      final token =
          await KeyValueStorageServiceImpl().getValue<String>('token');
      final response = await ApiController.consulta(
          'inventories/get-catalogue-to-sale?category=Hardware',
          'get',
          null,
          token);
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        dynamic resp = jsonDecode(response.body);

        productos = resp;
        for (var producto in productos) {
          try {
            final basePrice =
                double.tryParse(producto['price'] ?? '0.0') ?? 0.0;
            print(
                'Nombre del producto: ${producto['description']}, Precio base: \$${basePrice.toStringAsFixed(2)}');
          } catch (e) {
            print('Error al procesar servicio: $e');
          }
        }
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      errorMessage =
          'Error fetching services. Please check your connection and try again.';
      print('Error fetching services: $e');
    }
  }
}
