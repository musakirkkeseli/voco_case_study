import 'package:flutter/material.dart';
import 'package:voco_case_study/core/cache_manager.dart';
import 'package:voco_case_study/product/home/model/list_user_response.dart';
import 'package:voco_case_study/product/home/service/IHomeService.dart';

enum HomeStatus { initial, success, failure, logout }

class HomeRiverpod extends ChangeNotifier {
  final IHomeService service;
  HomeStatus status = HomeStatus.initial;
  bool sonFlag = false;
  int flag = 0;
  ListUsersResponseModel? listUsersResponseModel;

  HomeRiverpod(this.service);

// sayfa ilk açıldığında ilk kısım veriyi getirir
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

// kullanıcının tetiklemesiyle beraber daha fazla veriyi getirir
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

// veri getirme işlemi
  fetch() async {
    flag += 1;
    final data = await service.getListUsers(flag);
    print(data);
    return data;
  }

// kullanıcı çıkış yaptığınd gerekli temizliği yapar
  void logout() {
    CacheManager.db.deleteToken();
    status = HomeStatus.logout;
    notifyListeners();
  }
}
