//IAuthService sınfından türetilmiş olan AuthService sınfını tutarki
//bu sınıf Message sayfası için gerekli olan requesti atmakla görevlidir.

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:voco_case_study/core/base_dio_service.dart';
import 'package:voco_case_study/product/auth/model/auth_request_model.dart';
import 'package:voco_case_study/product/auth/model/auth_successful_response_model.dart';
import 'package:voco_case_study/product/auth/model/auth_unsuccessful_response_model.dart';
import 'package:voco_case_study/product/auth/service/IAuthService.dart';

class AuthService extends IAuthService {
  AuthService(Dio dio) : super(dio);

//Bu fonsiyon içerisine MessageRequestModel tipinde değişken alırki bu request için gereken verileri içinde barındırır
  @override
  Future postLogin(AuthRequestModel authRequestModel) async {
    print(authRequestModel);
    try {
      final response =
          await dio.post(loginPath, data: authRequestModel.toJson());
      print(response);
//istek başarılı ise requesti MessagesResponseModel nesnesine aktarır
      if (response.statusCode == HttpStatus.ok) {
        return AuthSuccessfulResponseModel.fromJson(response.data);
      } else {
        print("object");
        return null;
      }
    } on DioException catch (e) {
      String errorMesaj = BaseDioService.service.handleDioError(e);
      return AuthUnsuccessfulResponseModel(error: errorMesaj);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  //Bu fonsiyon içerisine MessageRequestModel tipinde değişken alırki bu request için gereken verileri içinde barındırır
  @override
  Future postRegister(AuthRequestModel authRequestModel) async {
    try {
      final response =
          await dio.post(registerPath, data: authRequestModel.toJson());
//istek başarılı ise requesti MessagesResponseModel nesnesine aktarır
      if (response.statusCode == HttpStatus.ok) {
        return AuthSuccessfulResponseModel.fromJson(response.data);
      } else {
        print("object");
        return null;
      }
    } on DioException catch (e) {
      String errorMesaj = BaseDioService.service.handleDioError(e);
      return AuthUnsuccessfulResponseModel(error: errorMesaj);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
