import 'package:dio/dio.dart';
import 'package:mobile_test/core/model/user_model.dart';

class UserService {
  final dio = Dio();
  String baseUrl = 'https://reqres.in/api/users';

  Future<UserModel> getUserData({int page = 1, int perPage = 10}) async {
    try {
      final response = await dio.get(baseUrl, queryParameters: {
        'page': page,
        'per_page': perPage,
      });
      UserModel model = UserModel.fromJson(response.data);
      return model;
    } catch (e) {
      throw Exception('Failed to fetch data');
    }
  }
}
