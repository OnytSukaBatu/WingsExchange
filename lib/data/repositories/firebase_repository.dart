import 'package:dartz/dartz.dart';
import 'package:wings/core/main_message.dart';
import 'package:wings/data/datasources/firebase_datasource.dart';
import 'package:wings/data/models/user_model.dart';
import 'package:wings/domain/entities/user_entity.dart';
import 'package:wings/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remote;
  FirebaseRepositoryImpl(this.remote);

  @override
  Future<Either<MsgFailure, void>> updateUserData({required String uid, required Map<String, String> data}) async {
    try {
      return Right(await remote.updateUserData(uid: uid, data: data));
    } catch (e) {
      return Left(MsgFailure('Gagal memperbarui data'));
    }
  }

  @override
  Future<Either<MsgFailure, UserEntity>> getUserData({required String email}) async {
    try {
      return Right((await remote.getUserData(email: email)).toEntity());
    } catch (e) {
      return Left(MsgFailure('Gagal mengambil data'));
    }
  }

  @override
  Future<Either<MsgFailure, String>> getApiKey({String? field}) async {
    try {
      return Right(await remote.getApiKey(field: field));
    } catch (e) {
      return Left(MsgFailure('Gagal mengambil data'));
    }
  }

  @override
  Future<Either<MsgFailure, String>> saveUserData({required UserModel model}) async {
    try {
      return Right(await remote.saveUserData(model: model));
    } catch (e) {
      return Left(MsgFailure('Gagal menyimpan data'));
    }
  }
}
