import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:velvet/config/constants/environment.dart';
import 'package:velvet/features/auth/domain/datasources/auth_datasource.dart';
import 'package:velvet/features/auth/domain/entities/office.dart';
import 'package:velvet/features/auth/domain/entities/user.dart';
import 'package:velvet/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:velvet/features/auth/infrastructure/mappers/user_mapper.dart';
import 'package:velvet/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

class AuthDatasourceImpl implements AuthDataSource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));
  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      throw CustomError(
          'Check Status Datasource no implementado - require chequear status');
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String nombre, String password) async {
    try {
      final response = await dio
          .post('login', data: {'username': nombre, 'password': password});

      final user = UserMapper.userJsonToEntity(response.data);
      print("aca estoy4");
      final userKey = jsonEncode(response.data);
      await KeyValueStorageServiceImpl().setKeyValue('user', userKey);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Incorrecto usuario o contraseña');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError("Revisar conexión a internet");
      }

      rethrow; // Re-lanzar la excepción original en otros casos de DioException
    } catch (e) {
      throw Exception();
    }
  }

  Future<OfficeLoginResponse> setOfficeLogin(int officeId) async {
    try {
      final response =
          await dio.post('set-office-login', data: {'office_id': officeId});
      final officeLoginResponse = OfficeLoginResponse.fromJson(response.data);
      final userKey = jsonEncode(response.data['user']);
      await KeyValueStorageServiceImpl().setKeyValue('user', userKey);
      return officeLoginResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        throw CustomError('Problema de Servidor');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError("Revisar conexión a internet");
      }

      rethrow; // Re-lanzar la excepción original en otros casos de DioException      rethrow;
    } catch (e) {
      throw Exception();
    }
  }
}
