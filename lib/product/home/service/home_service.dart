//IHomeService sınfından türetilmiş olan HomeService sınfını tutarki
//bu sınıf Message sayfası için gerekli olan requesti atmakla görevlidir.

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:voco_case_study/product/home/model/list_user_response.dart';
import 'package:voco_case_study/product/home/service/IHomeService.dart';

class HomeService extends IHomeService {
  HomeService(Dio dio) : super(dio);

//Bu fonsiyon içerisine MessageRequestModel tipinde değişken alırki bu request için gereken verileri içinde barındırır
  @override
  Future<ListUsersResponseModel?> getListUsers(int page) async {
    String url = "$listUsersPath?page=$page";
    final response = await dio.get(url);
//istek başarılı ise requesti MessagesResponseModel nesnesine aktarır
    if (response.statusCode == HttpStatus.ok) {
      return ListUsersResponseModel.fromJson(response.data);
    } else {
      print("object");
      return null;
    }
  }
}
