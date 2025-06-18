import 'package:dartz/dartz.dart';
import 'package:wings/core/main_message.dart';
import 'package:wings/domain/repositories/firebase_repository.dart';

class FirebaseUsecase {
  final FirebaseRepository repository;
  FirebaseUsecase(this.repository);

  Future<Either<MsgFailure, void>> updateUserData({
    required String uid,
    required Map<String, String> data,
  }) => repository.updateUserData(uid: uid, data: data);
}
