import 'package:dio/dio.dart';

import 'user_model.dart';

class UserRepository {
  final Dio dio;

  UserRepository(this.dio);

  Future<List<User>> fetchUsers() async {
    final response = await dio.get('/users');

    return (response.data as List)
      .map((user) => User.fromJson(user)).toList();
  }

  Future<void> addUser(User user) async {
    try {
      await dio.post('/users', data: user.toJson());

    }catch(e) {
      throw Exception('Failed to add user : $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await dio.delete('/users/$id');
    }catch(e) {
      throw Exception('Failed to delete user : $e');
    }
  }

  Future<User> fetchUserById(String id) async {
    try {
      final response = await dio.post('/users/$id');

      return User.fromJson(response.data);

    } catch(error) {
      throw Exception('Failed to fetch user : $error');
    }
  }
}