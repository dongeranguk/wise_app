import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wise_app/modules/user/user_provider.dart';

import 'user_add_dialog.dart';
import 'user_details_screen.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userListProvider);

    return Scaffold(
      body: usersAsync.when(
        data: (users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text('email : ${user.email}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => ref.read(userListProvider.notifier).deleteUser(user.id!),
              ),
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailsScreen(userId: user.id!)));
              },
            );
          },
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Center(child: Text('Error : $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => UserAddDialog(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}



