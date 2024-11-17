import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:velvet/features/shared/infrastructure/services/key_value_storage_service_impl.dart';
import 'package:velvet/services/api.dart';

class ServiciosController {
  BuildContext? context;
  List<dynamic> servicios = [];
  String errorMessage = '';
  bool isLoading = false;

  Future init(BuildContext context) async {
    this.context = context;
    isLoading = true;
    await getServicios();
    isLoading = false;
  }
  Future getServicios() async {
    try {
      final token =
          await KeyValueStorageServiceImpl().getValue<String>('token');
      final response = await ApiController.consulta(
          'services-paginated?paginated=true&page=1&itemsPerPage=50',
          'get',
          null,
          token);
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        Map<String, dynamic> resp =
            jsonDecode(response.body) as Map<String, dynamic>;
        servicios = resp['data'] as List<dynamic>? ?? [];
        for (var servicio in servicios) {
          try {
            final basePrice =
                double.tryParse(servicio['base_price'] ?? '0.0') ?? 0.0;
            print(
                'Nombre del servicio: ${servicio['name']}, Precio base: \$${basePrice.toStringAsFixed(2)}');
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
