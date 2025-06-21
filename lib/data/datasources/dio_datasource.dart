import 'package:dio/dio.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';
import 'package:wings/data/models/aset_model.dart';

class DioRemoteDataSource {
  final Dio dio;
  DioRemoteDataSource(this.dio);

  Future<List<AsetModel>> getListMarket() async {
    String url = MainConfig.urlListMarket;
    Map<String, String> headers = {'x-cg-demo-api-key': await f.secureRead(key: MainConfig.stringApiKey)};

    return await dio.get(url, options: Options(headers: headers)).then((value) {
      List<dynamic> responseData = value.data;
      return responseData.map((item) => AsetModel.fromArray(item)).toList();
    });
  }

  Future<num> getAsetPrice({required String id}) async {
    String url = MainConfig.urlAsetPrice;
    Map<String, String> headers = {'x-cg-demo-api-key': await f.secureRead(key: MainConfig.stringApiKey)};

    return await dio.get('$url$id', options: Options(headers: headers)).then((value) {
      Map<String, dynamic> responseData = value.data;
      return responseData[id]['idr'];
    });
  }

  Future<List> getAsetChart({required String id, required int days}) async {
    String url0 = MainConfig.urlChart0;
    String url1 = MainConfig.urlChart1;
    String url2 = MainConfig.urlChart2;

    String url = '$url0$id$url1$days$url2';

    Map<String, String> headers = {'x-cg-demo-api-key': await f.secureRead(key: MainConfig.stringApiKey)};

    return await dio.get(url, options: Options(headers: headers)).then((value) {
      Map<String, dynamic> responseData = value.data;
      return responseData['prices'];
    });
  }
}
