import 'package:velvet/features/auth/domain/datasources/auth_datasource.dart';
import 'package:velvet/features/auth/domain/entities/office.dart';
import 'package:velvet/features/auth/domain/entities/user.dart';
import 'package:velvet/features/auth/domain/repositories/auth_repositorie.dart';
import 'package:velvet/features/auth/infrastructure/datasources/auth_datasource_impl.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({AuthDataSource? dataSource})
      : dataSource = dataSource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String nombre, String password) {
    return dataSource.login(nombre, password);
  }

  @override
  Future<OfficeLoginResponse> setOfficeLogin(int officeId) async {
    return dataSource.setOfficeLogin(officeId);
  }
}
