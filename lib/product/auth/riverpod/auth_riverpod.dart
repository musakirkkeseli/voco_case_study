import 'package:flutter/material.dart';
import 'package:voco_case_study/core/cache_manager.dart';
import 'package:voco_case_study/product/auth/model/auth_request_model.dart';
import 'package:voco_case_study/product/auth/model/auth_successful_response_model.dart';
import 'package:voco_case_study/product/auth/model/auth_unsuccessful_response_model.dart';
import 'package:voco_case_study/product/auth/service/IAuthService.dart';

// bekleme ekranı, giriş yaptı başarısı ve giriş yaparken hata oluştu
enum AuthStatus {
  loading,
  success,
  failure,
}

// sayfa login durumunda mı register durumunda mı
enum AuthPageStatus {
  login,
  register,
}

class AuthRiverpod extends ChangeNotifier {
  final IAuthService service;
  AuthPageStatus pageStatus = AuthPageStatus.login;
  AuthStatus? status;
  AuthUnsuccessfulResponseModel errorModel =
      AuthUnsuccessfulResponseModel(error: "Beklenmedik bir hata oluştu");

  AuthRiverpod(this.service);
// loginden registere registerden logine geçişi sağlar
  void changePage() {
    pageStatus == AuthPageStatus.login
        ? pageStatus = AuthPageStatus.register
        : pageStatus = AuthPageStatus.login;
    notifyListeners();
  }

// login ve register işlemlerinin gerçekleştiği yer
  void fetch(AuthRequestModel authRequestModel) async {
    statusLoading();
    final data = pageStatus == AuthPageStatus.login
        ? await service.postLogin(authRequestModel)
        : await service.postRegister(authRequestModel);
    if (data is AuthSuccessfulResponseModel) {
      await CacheManager.db.setToken(data.token ?? "");
      status = AuthStatus.success;
      notifyListeners();
    } else {
      if (data is AuthUnsuccessfulResponseModel) {
        errorModel = data;
      }
      status = AuthStatus.failure;
      notifyListeners();
    }
  }

  void statusLoading() {
    status = AuthStatus.loading;
    notifyListeners();
  }

  void statusClean() {
    status = null;
  }
}
