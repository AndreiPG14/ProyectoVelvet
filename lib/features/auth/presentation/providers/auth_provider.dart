import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velvet/features/auth/domain/entities/office.dart';

import 'package:velvet/features/auth/domain/entities/user.dart';
import 'package:velvet/features/auth/domain/repositories/auth_repositorie.dart';
import 'package:velvet/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:velvet/features/auth/infrastructure/mappers/user_mapper.dart';
import 'package:velvet/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:velvet/features/formulario/pedido.dart';
import 'package:velvet/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
    ref: ref, 
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageServiceImpl keyValueStorageService;
  final Ref ref;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String nombre, String password) async {
    state = state.copyWith(isLoading: true);
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      logoutUser(errorMessage: 'Revisar conexión a internet');
    }
    try {
      print("aca estoy");
      final user = await authRepository.login(nombre, password);
      print("aca estoy2");
      print('logged in user $user');

      final jsonString = jsonEncode(user.toJson());
      print('JSON Response: $jsonString');

      _setLoggedUser(user);
    } on CustomError catch (e) {
      logoutUser(errorMessage: e.message);
    } on SocketException {
      logoutUser(errorMessage: 'Revisar conexión a internet');
    } catch (e) {
      logoutUser(errorMessage: 'Contraseña o Usuario incorrecto');
      print('hola soy el error: ${e.toString()}');
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);
    state = state.copyWith(
        errorMessage: '',
        authStatus: AuthStatus.authenticated,
        isLoading: false,
        user: user);
  }

  void logoutUser({String? errorMessage}) async {
    await keyValueStorageService.removeKey('token');
    await keyValueStorageService.removeKey('user');
    state = AuthState(
      authStatus: AuthStatus.notAuthenticated,
      isLoading: false,
      user: null,
      errorMessage: errorMessage
    );
    ref.read(pedidosProvider.notifier).clearPedidos();
  }

  void setOfficeLogin(int officeId) async {
    state = state.copyWith(isLoading: true);

    try {
      final officeLoginResponse = await authRepository.setOfficeLogin(officeId);

      final user = officeLoginResponse.user;

      final companyId = officeLoginResponse.companyId;

      state = state.copyWith(
        user: user,
        isLoading: false,
        errorMessage: '',
      );

      await keyValueStorageService.setKeyValue(
          'user', jsonEncode(user.toJson()));

      await keyValueStorageService.setKeyValue(
          'company_id', companyId.toString());

      await keyValueStorageService.setKeyValue('officeId', officeId.toString());

      await keyValueStorageService.setKeyValue(
          'office_login_name', officeLoginResponse.officeLoginName);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al seleccionar la sucursal',
      );
    }
  }

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) {
      return logoutUser();
    }
    try {
      final userKey = await keyValueStorageService.getValue<String>('user');
      final userDecode = jsonDecode(userKey!);
      final user = UserMapper.userJsonToEntity(userDecode);
      //final rol = user.roles;
      //final roles = rol.map((e) => e.name).toList();

      _setLoggedUser(user);
    } catch (e) {
      logoutUser(errorMessage: 'Error checkstatus');
    }
  }
}

enum AuthStatus {
  authenticated,
  notAuthenticated,
  cheking,
}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String? errorMessage;
  final bool isLoading;
  final OfficeLoginResponse? officeLoginResponse;
  AuthState({
    this.authStatus = AuthStatus.cheking,
    this.isLoading = false,
    this.user,
    this.errorMessage = '',
    this.officeLoginResponse,
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    bool? isLoading,
    User? user,
    String? errorMessage,
    OfficeLoginResponse? officeLoginResponse,
  }) {
    return AuthState(
        authStatus: authStatus ?? this.authStatus,
        isLoading: isLoading ?? this.isLoading,
        user: user ?? this.user,
        officeLoginResponse: officeLoginResponse ?? this.officeLoginResponse,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
