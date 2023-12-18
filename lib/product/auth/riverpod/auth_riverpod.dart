import 'package:flutter/material.dart';
import 'package:voco_case_study/core/cache_manager.dart';
import 'package:voco_case_study/product/auth/model/auth_request_model.dart';
import 'package:voco_case_study/product/auth/model/auth_successful_response_model.dart';
import 'package:voco_case_study/product/auth/service/IAuthService.dart';

enum AuthStatus {
  loading,
  success,
  failure,
}

enum AuthPageStatus {
  login,
  register,
}

class AuthRiverpod extends ChangeNotifier {
  final IAuthService service;
  AuthPageStatus pageStatus = AuthPageStatus.login;
  AuthStatus? status;

  AuthRiverpod(this.service);

  void changePage() {
    pageStatus == AuthPageStatus.login
        ? pageStatus = AuthPageStatus.register
        : pageStatus = AuthPageStatus.login;
    print(pageStatus);
    notifyListeners();
  }

  void fetch(AuthRequestModel authRequestModel) async {
    print("işlem geldi");
    statusLoading();
    final data = pageStatus == AuthPageStatus.login
        ? await service.postLogin(authRequestModel)
        : await service.postRegister(authRequestModel);
    if (data is AuthSuccessfulResponseModel) {
      await CacheManager.db.setToken(data.token ?? "");
      status = AuthStatus.success;
      notifyListeners();
    } else {
      status = AuthStatus.failure;
      notifyListeners();
    }
  }

  void statusLoading() {
    status = AuthStatus.loading;
    notifyListeners();
  }
}
