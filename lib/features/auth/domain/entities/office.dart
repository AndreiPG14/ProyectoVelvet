import 'package:velvet/features/auth/domain/entities/user.dart';
import 'package:velvet/features/auth/infrastructure/mappers/offices_mapper.dart';

class OfficeLoginResponse {
  final User user;
  final int companyId;
  final int? sedeId;
  final int officeId;
  final int? tillUserId;
  final String officeLoginName;
  final int storeHouse;

  OfficeLoginResponse({
    required this.user,
    required this.companyId,
    this.sedeId,
    required this.officeId,
    this.tillUserId,
    required this.officeLoginName,
    required this.storeHouse,
  });

  factory OfficeLoginResponse.fromJson(Map<String, dynamic> json) {
    return OfficeLoginMapper.officeLoginJsonToEntity(json);
  }

  Map<String, dynamic> toJson() {
    return OfficeLoginMapper.officeLoginEntityToJson(this);
  }
}
