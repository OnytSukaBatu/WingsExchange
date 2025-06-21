import 'package:dartz/dartz.dart';
import 'package:wings/core/main_message.dart';
import 'package:wings/data/models/user_model.dart';
import 'package:wings/domain/entities/user_entity.dart';

abstract class FirebaseRepository {
  Future<Either<MsgFailure, void>> updateUserData({required String uid, required Map<String, String> data});

  Future<Either<MsgFailure, UserEntity>> getUserData({required String email});

  Future<Either<MsgFailure, String>> getApiKey();

  Future<Either<MsgFailure, String>> saveUserData({required UserModel model});
}
