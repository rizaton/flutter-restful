import 'dart:convert';

import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'users_item.dart';
// import 'users_item_details_view.dart';

import 'package:http/http.dart' as http;

import 'users_item_details_view.dart';

/// Displays a list of UsersItems.
class UsersItemListView extends StatelessWidget {
  const UsersItemListView({
    super.key,
    this.items = const [
      UsersItem(
          id: 0,
          name: 'Tony Afriza',
          username: 'tony',
          password: '123',
          access: 1),
      UsersItem(
          id: 1,
          name: 'John Doe',
          username: 'john',
          password: '123',
          access: 1),
      UsersItem(
          id: 2,
          name: 'Jane Doe',
          username: 'jane',
          password: '123',
          access: 1),
      UsersItem(
          id: 3,
          name: 'Tony Stark',
          username: 'stark',
          password: '123',
          access: 1),
    ],
  });

  static const routeName = '/';

  final List<UsersItem> items;

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
      // body: ListView.builder(
      //   restorationId: 'usersItemListView',
      //   itemCount: items.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     final item = items[index];
      //     return ListTile(
      //         title: Text('${item.name} Card'),
      //         leading: const CircleAvatar(
      //           foregroundImage: AssetImage('assets/images/flutter_logo.png'),
      //         ),
      //         onTap: () {
      //           Navigator.pushNamed(
      //             context,
      //             UsersItemDetailsView.routeName(index),
      //             arguments: {'item': item, 'id': item.id},
      //           );
      //         });
      //   },
      // ),
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
                            Navigator.pushNamed(
                              context,
                              UsersItemDetailsView.routeName(index),
                              arguments: {'item': item, 'id': item.id},
                            );
                          });
                    });

                // return FutureBuilder(
                //     future: __getUser(),
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState ==
                //           ConnectionState.done) {
                //         if (snapshot.hasError) {
                //           return Text('Error: ${snapshot.error}');
                //         } else {
                //           final List<UsersItem> item =
                //               (jsonDecode(snapshot.data!) as List<dynamic>)
                //                   .map((dynamic e) => UsersItem.fromJson(e))
                //                   .toList();
                //           return Text('data: ${item}');
                //         }
                //       } else {
                //         return const CircularProgressIndicator();
                //       }
                //     });
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
