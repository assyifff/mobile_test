import 'package:flutter/widgets.dart';
import 'package:mobile_test/core/model/user_model.dart';
import 'package:mobile_test/core/service/user_service.dart';

class UserProvider extends ChangeNotifier {
  final service = UserService();
  List<Data> userList = [];
  bool isLoading = false;
  bool isError = false;
  int _page = 1;
  int _perPage = 10;
  String? selectedTitle;

  Future<void> initialize({int page = 1, int perPage = 10}) async {
    _page = page;
    _perPage = perPage;
    await getUserList();
  }

  Future<void> getUserList() async {
    try {
      isLoading = true;
      isError = false;

      final response =
          await service.getUserData(page: _page, perPage: _perPage);
      if (_page == 1) {
        userList = response.data ?? [];
      } else {
        userList.addAll(response.data ?? []);
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (!isLoading && !isError) {
      _page++;
      await getUserList();
    }
  }

  Future<void> refreshData() async {
    if (!isLoading && !isError) {
      _page = 1;
      await getUserList();
    }
  }

  void updateSelectedTitle(String? title) {
    selectedTitle = title;
    notifyListeners();
  }
}
