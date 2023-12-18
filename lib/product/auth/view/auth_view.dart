import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voco_case_study/core/constant_string.dart';
import 'package:voco_case_study/core/widget/loading_widget.dart';
import 'package:voco_case_study/product/auth/model/auth_request_model.dart';
import 'package:voco_case_study/product/auth/riverpod/auth_riverpod.dart';
import 'package:voco_case_study/product/auth/service/auth_service.dart';
import 'package:voco_case_study/product/home/view/home_view.dart';

final authRiverpod = ChangeNotifierProvider((ref) => AuthRiverpod(
    AuthService(Dio(BaseOptions(baseUrl: ConstantsString.baseUrl)))));

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var read = ref.read(authRiverpod);
    var watch = ref.watch(authRiverpod);
    ref.listen(
      authRiverpod,
      (previous, next) {
        switch (next.status) {
          // login ve register işlemleri için request atıldığı sırada kullanıcıyı bekleten ekran
          case AuthStatus.loading:
            showDialog(
                context: context,
                builder: (context) => Dialog(
                      insetPadding: const EdgeInsets.all(0),
                      backgroundColor: Colors.transparent,
                      child: WillPopScope(
                          child: const LoadingWidget(),
                          onWillPop: () async => false),
                    ));
            break;
          // login register işlemlerinde oluşan hatayı ekrana çıkarır
          case AuthStatus.failure:
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(next.errorModel.error ?? ""),
              ),
            ).then((value) => read.statusClean());
            break;
          // işlem başarılı ise kullanıcı listesine yönlendirir
          case AuthStatus.success:
            Navigator.of(context)
              ..pop()
              ..pushReplacement(MaterialPageRoute(
                builder: (context) => const HomeView(),
              ));
            break;
          default:
        }
      },
    );

    return Scaffold(
        appBar: AppBar(
          // watch.pageStatus değeri kullanıcının sayfa değerinin login mi yoksa register mı bilgisini içerir
          title: Text(watch.pageStatus == AuthPageStatus.login
              ? ConstantsString.login
              : ConstantsString.register),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.network(
                  "https://vocoapp.com/logo-icon.svg",
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: controllerEmail,
                  validator: (val) => EmailValidator.validate(val ?? "")
                      ? null
                      : ConstantsString.enterEmail,
                  decoration: const InputDecoration(
                    labelText: ConstantsString.email,
                    icon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: controllerPassword,
                  validator: (val) {
                    if (val != null) {
                      if (val.isEmpty) {
                        return ConstantsString.textFieldEmptyWarning;
                      } else if (val.length < 8) {
                        return ConstantsString.minCharacterWarning;
                      }
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: ConstantsString.password,
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // reguest gönder
                      read.fetch(AuthRequestModel(
                          email: controllerEmail.text,
                          password: controllerPassword.text));
                    }
                  },
                  child: Text(watch.pageStatus == AuthPageStatus.login
                      ? ConstantsString.login
                      : ConstantsString.register),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    // loginden registere registerden logine
                    read.changePage();
                  },
                  child: Text(watch.pageStatus == AuthPageStatus.login
                      ? ConstantsString.gotoRegister
                      : ConstantsString.gotoLogin),
                ),
              ],
            ),
          ),
        ));
  }
}
