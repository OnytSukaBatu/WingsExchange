import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:wings/data/datasources/dio_datasource.dart';
import 'package:wings/data/datasources/firebase_datasource.dart';
import 'package:wings/data/repositories/dio_repository.dart';
import 'package:wings/data/repositories/firebase_repository.dart';
import 'package:wings/domain/repositories/dio_repository.dart';
import 'package:wings/domain/repositories/firebase_repository.dart';
import 'package:wings/domain/usecases/dio_usecase.dart';
import 'package:wings/domain/usecases/firebase_usecase.dart';

final injection = GetIt.instance;

Future<void> initInjection() async {
  injection.registerLazySingleton(() => Dio());
  injection.registerLazySingleton(() => FirebaseFirestore.instance);

  injection.registerLazySingleton(() => FirebaseRemoteDataSource(injection()));
  injection.registerLazySingleton(() => DioRemoteDataSource(injection()));

  injection.registerLazySingleton<FirebaseRepository>(() => FirebaseRepositoryImpl(injection()));
  injection.registerLazySingleton<DioRepository>(() => DioRepositoryImpl(injection()));

  injection.registerLazySingleton(() => FirebaseUsecase(injection()));
  injection.registerLazySingleton(() => DioUsecase(injection()));
}
