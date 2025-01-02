import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'user_model.dart';
import 'user_repository.dart';
import 'package:collection/collection.dart';

part 'user_provider.g.dart';

@riverpod
Dio dio(DioRef ref) {
  return Dio(BaseOptions(
    baseUrl: 'http://192.168.88.57:3000',
    connectTimeout: const Duration(milliseconds: 5000),
    receiveTimeout: const Duration(milliseconds: 3000),
  ));
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio);
}

@riverpod
class UserList extends _$UserList {
  List<User>? _cachedUsers;

  @override
  FutureOr<List<User>> build() {
    if(_cachedUsers != null) {
      return _cachedUsers!;
    }

    return fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
    final repository = ref.read(userRepositoryProvider);
    final users = await repository.fetchUsers();

    return users;
  }

  Future<void> addUser(User user) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(userRepositoryProvider);
      await repository.addUser(user);

      final updatedUsers = await repository.fetchUsers();

      state = AsyncData(updatedUsers);

    }catch(e, trace) {
      state = AsyncError(e, trace);
    }
  }

  Future<void> deleteUser(String id) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(userRepositoryProvider);
      await repository.deleteUser(id);

      final updatedUsers = await repository.fetchUsers();

      state =  AsyncData(updatedUsers);

    }catch(e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<User?> fetchUserDetails(String userId) async {

    try {
      final repository = ref.read(userRepositoryProvider);

      return await repository.fetchUserById(userId);
    }catch(e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}


