import 'package:dartz/dartz.dart';
import 'package:wings/core/main_message.dart';
import 'package:wings/domain/entities/user_entity.dart';
import 'package:wings/domain/repositories/firebase_repository.dart';

class FirebaseUsecase {
  final FirebaseRepository repository;
  FirebaseUsecase(this.repository);

  Future<Either<MsgFailure, void>> updateUserData({
    required String uid,
    required Map<String, String> data,
  }) {
    return repository.updateUserData(uid: uid, data: data);
  }

  Future<Either<MsgFailure, UserEntity>> getUserData({required String email}) {
    return repository.getUserData(email: email);
  }
}
