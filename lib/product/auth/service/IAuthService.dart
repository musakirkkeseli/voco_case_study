//Message sayfası için kullanılan request sınıfının türetildiği ana sınıftır.

import 'package:dio/dio.dart';
import 'package:voco_case_study/product/auth/model/auth_request_model.dart';
import 'package:voco_case_study/product/auth/model/auth_successful_response_model.dart';

abstract class IAuthService {
  final Dio dio;

  IAuthService(this.dio);

//baseUrl'nin sonuna kolaylıkla ekleme yapmak için kullanılır
  final String loginPath = IAuthServicePath.login.rawValue;
  final String registerPath = IAuthServicePath.register.rawValue;

//requesti atacak olan fonksiyon tanımlanır
  Future<AuthSuccessfulResponseModel?> postLogin(
      AuthRequestModel authRequestModel);
  Future<AuthSuccessfulResponseModel?> postRegister(
      AuthRequestModel authRequestModel);
}

enum IAuthServicePath { login, register }

//BaseUrl'nin sonuna Message sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension IAuthServicePathExtension on IAuthServicePath {
  String get rawValue {
    switch (this) {
      case IAuthServicePath.login:
        return '/api/login';
      case IAuthServicePath.register:
        return '/api/register';
    }
  }
}
