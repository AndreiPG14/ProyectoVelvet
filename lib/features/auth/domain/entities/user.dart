class User {
  late final String nombre;
  final int id;
  final String email;
  final String token;
  final bool selectOffice;
  final List<Office> offices;

  User({
    this.nombre = "",
    required this.id,
    required this.email,
    required this.token,
    required this.selectOffice,
    required this.offices,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nombre: json['user']['employee']['fullname'] ?? '',
      id: json['user']['id'],
      email: json['user']['email'],
      token: json['token'],
      selectOffice: json['select_office'],
      offices: List<Office>.from(json['user']['employee']['offices']
          .map((office) => Office.fromJson(office))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'id': id,
      'email': email,
      'token': token,
      'select_office': selectOffice,
      'offices': offices.map((office) => office.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'User{nombre: $nombre, id: $id, email: $email, token: $token, selectOffice: $selectOffice, offices: $offices}';
  }
}

class Office {
  final int id;
  final int company;

  final String name;
  final String address;
  final String? phone;
  Office({
    required this.id,
    required this.company,
    required this.name,
    required this.address,
    this.phone,
  });

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      company: json['company_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      "company_id": company,
      'phone': phone,
    };
  }
}
