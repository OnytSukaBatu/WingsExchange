import 'package:dartz/dartz.dart';
import 'package:wings/core/main_message.dart';

abstract class FirebaseRepository {
  Future<Either<MsgFailure, void>> updateUserData({
    required String uid,
    required Map<String, String> data,
  });
}
