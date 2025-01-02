import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wise_app/modules/user/user_provider.dart';

class UserDetailsScreen extends ConsumerWidget {
  const UserDetailsScreen({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userListNotifier = ref.read(userListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("상세 정보"),),
        body: FutureBuilder(
      future: userListNotifier.fetchUserDetails(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error : ${snapshot.error}'));
        } else if(snapshot.hasData) {
          final user = snapshot.data!;
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name),
                  Text(user.email),
                ],
              ));
        } else {
          return const Center(child: Text('No user data available'));
        }
      },
    ));
  }
}
