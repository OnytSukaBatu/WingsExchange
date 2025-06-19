import 'package:dartz/dartz.dart';
import 'package:wings/core/main_message.dart';
import 'package:wings/domain/entities/aset_entity.dart';

abstract class DioRepository {
  Future<Either<MsgFailure, List<AsetEntity>>> getListMarket();

  Future<Either<MsgFailure, num>> getAsetPrice({required String id});
}
