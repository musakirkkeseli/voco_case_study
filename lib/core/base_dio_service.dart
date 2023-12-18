// hata yakalamaya yardımcı olur
import 'package:dio/dio.dart';

class BaseDioService {
  BaseDioService._();
  static final BaseDioService service = BaseDioService._();

  String handleDioError(DioException e) {
    String message;
    if (e.response?.data['error'] != null) {
      message = e.response?.data['error'];
    } else {
      switch (e.type) {
        case DioExceptionType.connectionError:
          message =
              "İnternet bağlantınızı kontrol edip daha sonra tekrar deneyin.";
          break;
        case DioExceptionType.connectionTimeout:
          message =
              e.response?.data['error'] ?? "Bağlantı zaman aşımına uğradı.";
          break;
        case DioExceptionType.badCertificate:
          message =
              e.response?.data['error'] ?? "Bir sorun oluştu:Hata kodu #1";
          break;
        case DioExceptionType.badResponse:
          message =
              e.response?.data['error'] ?? "Bir sorun oluştu:Hata kodu #2";
          break;
        case DioExceptionType.receiveTimeout:
          message =
              e.response?.data['error'] ?? "Bir sorun oluştu:Hata kodu #3";
          break;
        default:
          message =
              e.response?.data['error'] ?? "Bir sorun oluştu:Hata kodu #5";
          break;
      }
    }

    return message;
  }
}
