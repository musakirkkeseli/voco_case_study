//Message sayfası için kullanılan request sınıfının türetildiği ana sınıftır.

import 'package:dio/dio.dart';
import 'package:voco_case_study/product/home/model/list_user_response.dart';

abstract class IHomeService {
  final Dio dio;

  IHomeService(this.dio);

//baseUrl'nin sonuna kolaylıkla ekleme yapmak için kullanılır
  final String listUsersPath = IHomeServicePath.listUsers.rawValue;

//requesti atacak olan fonksiyon tanımlanır
  Future<ListUsersResponseModel?> getListUsers(int page);
}

enum IHomeServicePath { listUsers }

//BaseUrl'nin sonuna Message sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension IHomeServicePathExtension on IHomeServicePath {
  String get rawValue {
    switch (this) {
      case IHomeServicePath.listUsers:
        return '/api/users';
    }
  }
}
