// uygulama işl açıldığında çalışacak olan işlemleri barındırır
import 'package:flutter/material.dart';
import 'package:voco_case_study/core/cache_manager.dart';
import 'package:voco_case_study/core/widget/app_error_widget.dart';

final class AppInitialze {
  AppInitialze._();
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    //Uygulama CacheManager sınıfı çalıştırır
    await CacheManager.db.init();
    //uygulamada yaşanacak beklenmedik büyük hatalarda ekrana AppErrorWidget widgeti gösterilir
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return const AppErrorWidget();
    };
  }
}
