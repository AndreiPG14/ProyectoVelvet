import 'package:velvet/features/auth/domain/entities/office.dart';
import 'package:velvet/features/auth/domain/entities/user.dart';

abstract class AuthDataSource {
  Future<User> login(String nombre, String password);

  Future<User> checkAuthStatus(String token);

  Future<OfficeLoginResponse> setOfficeLogin(int officeId);
}
