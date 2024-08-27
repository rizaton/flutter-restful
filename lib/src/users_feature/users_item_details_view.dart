import 'package:flutter/material.dart';
import 'users_item.dart';

class UsersItemDetailsView extends StatelessWidget {
  const UsersItemDetailsView({super.key, required this.item});
  final UsersItem item;

  static String routeName(int id) {
    return '/usersItem/$id';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('ID: ${item.id}'),
            Text('Name: ${item.name}'),
            Text('Username: ${item.username}'),
            Text('Password: ${item.password}'),
            Text('Access: ${item.access}'),
          ],
        ),
      ),
    );
  }
}
