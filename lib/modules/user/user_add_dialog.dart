import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_model.dart';
import 'user_provider.dart';

class UserAddDialog extends ConsumerWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Add User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final email = emailController.text;

              if (name.isNotEmpty && email.isNotEmpty) {
                final newUser = User(name: name, email: email, isAdmin: false);
                ref.read(userListProvider.notifier).addUser(newUser);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add')),
      ],
    );
  }
}