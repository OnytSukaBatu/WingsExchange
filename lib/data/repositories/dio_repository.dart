import 'package:dartz/dartz.dart';
import 'package:wings/core/main_message.dart';
import 'package:wings/data/datasources/dio_datasource.dart';
import 'package:wings/data/models/aset_model.dart';
import 'package:wings/domain/entities/aset_entity.dart';
import 'package:wings/domain/repositories/dio_repository.dart';

class DioRepositoryImpl implements DioRepository {
  final DioRemoteDataSource remote;
  DioRepositoryImpl(this.remote);

  @override
  Future<Either<MsgFailure, List<AsetEntity>>> getListMarket() async {
    try {
      List<AsetModel> listData = await remote.getListMarket();
      return Right(await listData.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(MsgFailure('Gagal mengambil data'));
    }
  }

  @override
  Future<Either<MsgFailure, num>> getAsetPrice({required String id}) async {
    try {
      return Right(await remote.getAsetPrice(id: id));
    } catch (e) {
      return Left(MsgFailure('Gagal mengambil data'));
    }
  }

  @override
  Future<Either<MsgFailure, List>> getAsetChart({required String id, required int days}) async {
    try {
      return Right(await remote.getAsetChart(id: id, days: days));
    } catch (e) {
      return Left(MsgFailure('Gagal mengambil data'));
    }
  }
}
