import 'package:wings/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String data;
  final String display;
  final String email;
  final String pin;
  final String rupiah;

  UserModel({
    required this.id,
    required this.data,
    required this.display,
    required this.email,
    required this.pin,
    required this.rupiah,
  });

  factory UserModel.fromArray(Map<String, dynamic> array) {
    return UserModel(
      id: array['id'],
      data: array['data'],
      display: array['display'],
      email: array['email'],
      pin: array['pin'],
      rupiah: array['rupiah'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      data: data,
      display: display,
      email: email,
      pin: pin,
      rupiah: rupiah,
    );
  }
}
