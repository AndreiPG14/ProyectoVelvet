import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velvet/config/constants/environment.dart';
import 'package:velvet/features/auth/domain/entities/user.dart';
import 'package:velvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:velvet/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

class SucursalController {
  final WidgetRef ref;
  final Dio dio;

  List<Office> offices = [];
  List<DropDownValueModel> dropdownOffices = [];
  SingleValueDropDownController officesController =
      SingleValueDropDownController();

  SucursalController(this.ref)
      : dio = Dio(BaseOptions(baseUrl: Environment.apiUrl)) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token =
              await KeyValueStorageServiceImpl().getValue<String>('token');
          options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (DioError e, handler) {
          if (e.response?.statusCode == 401) {
            print('Error de autorización: Token inválido o expirado.');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> init() async {
    try {
      print('Iniciando carga de oficinas...');

      final authState = ref.read(authProvider);
      final user = authState.user;

      if (user != null) {
        offices = user.offices;
        print('Oficinas cargadas: $offices');

        dropdownOffices = offices
            .map((office) =>
                DropDownValueModel(name: office.name, value: office.id))
            .toList();
        print('Dropdown offices: $dropdownOffices');

        officesController = SingleValueDropDownController(
            data: dropdownOffices.isNotEmpty ? dropdownOffices[0] : null);
      } else {
        print('User is null');
      }
    } catch (e) {
      print('Error al cargar las oficinas: $e');
    }
  }

  Office? get selectedOffice {
    final selectedValue = officesController.dropDownValue?.value;
    if (selectedValue == null) {
      return null;
    }
    try {
      return offices.firstWhere((office) => office.id == selectedValue);
    } catch (e) {
      print('Error al obtener la sucursal seleccionada: $e');
      return null;
    }
  }

  Future<bool> setOfficeLogin() async {
    final selectedOffice = this.selectedOffice;
    if (selectedOffice != null) {
      print('ID de oficina seleccionada: ${selectedOffice.id}');
      try {
        final response = await dio
            .post('set-office-login', data: {'office_id': selectedOffice.id});

        if (response.data != null &&
            response.data is Map &&
            response.data.containsKey('user')) {
          final userKey = jsonEncode(response.data['user']);
          await KeyValueStorageServiceImpl().setKeyValue('user', userKey);
          print(
              'La oficina seleccionada se ha almacenado correctamente en el backend.');
          return true;
        } else {
          print('Error: response.data o user es nulo.');
          throw Exception('Datos de usuario no válidos');
        }
      } on DioError catch (e) {
        print('Error en la solicitud HTTP: ${e.message}');
        throw Exception('Error en la conexión de red');
      } catch (e) {
        print('Error general al establecer el login de la oficina: $e');
        throw Exception('Error desconocido');
      }
    } else {
      print('Error: No se ha seleccionado una oficina.');
      return false;
    }
  }
}
