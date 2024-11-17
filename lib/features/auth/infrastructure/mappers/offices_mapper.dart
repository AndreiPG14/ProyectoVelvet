import 'package:velvet/features/auth/domain/entities/office.dart';
import 'package:velvet/features/auth/infrastructure/mappers/user_mapper.dart';

class OfficeLoginMapper {
  static OfficeLoginResponse officeLoginJsonToEntity(
      Map<String, dynamic> json) {
    return OfficeLoginResponse(
      user: UserMapper.userJsonToEntity(json['user']),
      companyId: json['company_id'],
      sedeId: json['sede_id'],
      officeId: json['office_id'],
      tillUserId: json['till_user_id'],
      officeLoginName: json['office_login_name'],
      storeHouse: json['store_house'],
    );
  }

  static Map<String, dynamic> officeLoginEntityToJson(
      OfficeLoginResponse officeLogin) {
    return {
      'user': UserMapper.userEntityToJson(officeLogin.user),
      'company_id': officeLogin.companyId,
      'sede_id': officeLogin.sedeId,
      'office_id': officeLogin.officeId,
      'till_user_id': officeLogin.tillUserId,
      'office_login_name': officeLogin.officeLoginName,
      'store_house': officeLogin.storeHouse,
    };
  }
}
