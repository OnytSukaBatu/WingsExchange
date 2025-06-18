import 'package:wings/data/datasources/dio_datasource.dart';
import 'package:wings/domain/repositories/dio_repository.dart';

class DioRepositoryImpl implements DioRepository {
  final DioRemoteDataSource remote;
  DioRepositoryImpl(this.remote);
}
