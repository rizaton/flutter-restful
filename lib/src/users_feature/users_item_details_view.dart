// ignore_for_file: unused_import
import 'dart:ui';

import 'package:flutter/material.dart';
import 'users_item.dart';

import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class UsersItemDetailsView extends StatefulWidget {
  const UsersItemDetailsView({super.key, required this.item});
  final UsersItem item;

  @override
  State<UsersItemDetailsView> createState() => _UsersItemDetailsViewState();
}

class _UsersItemDetailsViewState extends State<UsersItemDetailsView> {
  @override
  initState() {
    __getUser();
    super.initState();
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
            Text('ID: ${widget.item.id}'),
            Text('Name: ${widget.item.name}'),
            Text('Username: ${widget.item.username}'),
            Text('Password: ${widget.item.password}'),
            Text('Access: ${widget.item.access}'),
          ],
        ),
      ),
    );
  }
}

Future<String> __getUser() async {
  try {
    final response = await http.get(Uri.http('localhost:8080', '/api/user'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to make the request: $e');
  }
}
