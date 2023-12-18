part of '../home_view.dart';

class UserListview extends ConsumerWidget {
  const UserListview({
    super.key,
    required ScrollController scrollController,
    required this.watchHome,
    required this.userList,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final HomeRiverpod watchHome;
  final List<Data> userList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: watchHome.sonFlag ? userList.length : userList.length + 1,
        itemBuilder: (context, index) {
          if (index >= userList.length && watchHome.sonFlag == false) {
            return TextButton(
                onPressed: () {
                  ref.read(homeRiverpod).moreFetch();
                },
                child: const Text("Daha Fazla"));
          }
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    userList[index].avatar ?? ConstantsString.vocoIconUrl),
              ),
              title: Text(
                  "${userList[index].firstName ?? ""} ${userList[index].lastName ?? ""}"),
              subtitle: Text(userList[index].email ?? ""),
            ),
          );
        });
  }
}
