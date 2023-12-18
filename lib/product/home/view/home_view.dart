import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voco_case_study/core/constant_string.dart';
import 'package:voco_case_study/core/widget/loading_widget.dart';
import 'package:voco_case_study/product/auth/view/auth_view.dart';
import 'package:voco_case_study/product/home/model/list_user_response.dart';
import 'package:voco_case_study/product/home/riverpod/home_riverpod.dart';
import 'package:voco_case_study/product/home/service/home_service.dart';

part 'widget/user_listview.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final homeRiverpod = ChangeNotifierProvider((ref) => HomeRiverpod(
      HomeService(Dio(BaseOptions(baseUrl: ConstantsString.baseUrl)))));
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    ref.read(homeRiverpod).firstFetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var readHome = ref.read(homeRiverpod);
    var watchHome = ref.watch(homeRiverpod);
    ref.listen(homeRiverpod, (previous, next) {
      switch (next.status) {
        case HomeStatus.logout:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AuthView()));
          break;
        default:
      }
    });
    ListUsersResponseModel listUsersResponseModel =
        watchHome.listUsersResponseModel ?? ListUsersResponseModel();
    List<Data> userList = (listUsersResponseModel.data ?? []);
    return Scaffold(
        appBar: AppBar(
          title: const Text(ConstantsString.homeAppbarTitle),
          actions: [
            IconButton(
                onPressed: () {
                  readHome.logout();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: body(watchHome, userList));
  }

// kullanıcı listesinin getirilmesi durumlarına göre farklı durumları sağlar
  body(HomeRiverpod watchHome, List<Data> userList) {
    switch (watchHome.status) {
      case HomeStatus.initial:
        return const LoadingWidget();
      case HomeStatus.success:
        return UserListview(
            homeRiverpod: homeRiverpod,
            scrollController: _scrollController,
            watchHome: watchHome,
            userList: userList);
      default:
        return const Center(
          child: Text("Beklenmedik bir hata oluştu"),
        );
    }
  }
}
