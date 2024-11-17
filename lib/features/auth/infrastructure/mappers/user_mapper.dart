import 'package:velvet/features/auth/domain/entities/user.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) {
    return User(
      nombre: json["user"]["employee"]["fullname"],
      email: json["user"]["email"],
      id: json["user"]["id"],
      token: json["token"],
      selectOffice: json["select_office"],
      offices: List<Office>.from(
        json["user"]["employee"]["offices"].map(
          (office) => Office(
            id: office["id"],
            name: office["name"],
            address: office["address"],
            phone: office["phone"] ?? '',
            company: office["company_id"],
          ),
        ),
      ),
    );
  }

  static Map<String, dynamic> userEntityToJson(User user) {
    return {
      'data': {
        'nombre': user.nombre,
        'email': user.email,
        'id': user.id,
        'token': user.token,
        'select_office': user.selectOffice,
        'offices': user.offices.map((office) => office.toJson()).toList(),
      }
    };
  }
}
