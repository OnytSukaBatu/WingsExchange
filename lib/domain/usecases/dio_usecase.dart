import 'package:dartz/dartz.dart';
import 'package:wings/core/main_message.dart';
import 'package:wings/domain/entities/aset_entity.dart';
import 'package:wings/domain/repositories/dio_repository.dart';

class DioUsecase {
  final DioRepository repository;
  DioUsecase(this.repository);

  Future<Either<MsgFailure, List<AsetEntity>>> getListMarket() {
    return repository.getListMarket();
  }

  Future<Either<MsgFailure, num>> getAsetPrice({required String id}) {
    return repository.getAsetPrice(id: id);
  }
}
