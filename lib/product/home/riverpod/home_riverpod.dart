import 'package:flutter/material.dart';
import 'package:voco_case_study/core/cache_manager.dart';
import 'package:voco_case_study/product/home/model/list_user_response.dart';
import 'package:voco_case_study/product/home/service/IHomeService.dart';

enum HomeStatus { initial, success, failure, logout }

class HomeRiverpod extends ChangeNotifier {
  final IHomeService service;
  HomeStatus status = HomeStatus.initial;
  // final bool success;
  bool sonFlag = false;
  int flag = 0;
  ListUsersResponseModel? listUsersResponseModel;

  HomeRiverpod(this.service);

  void firstFetch() async {
    final data = await fetch();
    print(data.runtimeType);
    if (data is ListUsersResponseModel) {
      print("başarılı");
      listUsersResponseModel = data;
      status = HomeStatus.success;
      sonFlag = (data.page == data.totalPages);
      notifyListeners();
    } else {
      status = HomeStatus.failure;
      notifyListeners();
    }
  }

  void moreFetch() async {
    final data = await fetch();
    if (data is ListUsersResponseModel) {
      listUsersResponseModel!.page = data.page;
      listUsersResponseModel!.data = List.of(listUsersResponseModel!.data ?? [])
        ..addAll(data.data ?? []);
      sonFlag = (data.page == data.totalPages);
      notifyListeners();
    } else {
      status = HomeStatus.failure;
      notifyListeners();
    }
  }

  fetch() async {
    flag += 1;
    final data = await service.getListUsers(flag);
    print(data);
    return data;
  }

  void logout() {
    CacheManager.db.deleteToken();
    status = HomeStatus.logout;
    notifyListeners();
  }
}
