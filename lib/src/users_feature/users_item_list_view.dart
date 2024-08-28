// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../settings/settings_view.dart';
import 'users_item.dart';
// import 'users_item_details_view.dart';

import 'package:http/http.dart' as http;

import 'users_item_details_view.dart';

/// Displays a list of UsersItems.
class UsersItemListView extends StatelessWidget {
  const UsersItemListView({
    super.key,
  });

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
          future: __getUser(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final List<UsersItem> items =
                    (jsonDecode(snapshot.data!) as List<dynamic>)
                        .map((dynamic e) => UsersItem.fromJson(e))
                        .toList();
                return ListView.builder(
                    restorationId: 'usersItemListView',
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final UsersItem item = items[index];
                      return ListTile(
                          title: Text('${item.name} Card'),
                          leading: const CircleAvatar(
                            foregroundImage:
                                AssetImage('assets/images/flutter_logo.png'),
                          ),
                          onTap: () {
                            context.goNamed('usersItem',
                                pathParameters: {'id': '${item.id}'});
                          });
                    });
              }
            } else {
              return const CircularProgressIndicator();
            }
          }),
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
