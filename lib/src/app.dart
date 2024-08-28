// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_restful_api/src/users_feature/users_item.dart';

import 'users_feature/users_item_list_view.dart';
import 'users_feature/users_item_details_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final List<UsersItem> items;
  late GoRouter _router;

  @override
  void initState() {
    __setItems();
    __initRoutes();
    super.initState();
  }

  void __initRoutes() async {
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => const UsersItemListView(),
        ),
        GoRoute(
          name: 'settings',
          path: '/settings',
          builder: (context, state) =>
              SettingsView(controller: widget.settingsController),
        ),
        GoRoute(
          name: 'usersItem',
          path: '/usersItem/:id',
          builder: (context, state) {
            final Map<String, String> queryParams = state.pathParameters;
            final int id = int.parse(queryParams['id']!);
            late UsersItem? item;
            try {
              item = items
                  .map((e) {
                    if (e.id == id) {
                      return e;
                    }
                  })
                  .whereNotNull()
                  .toList()[0];
            } catch (e) {
              context.go('/');
            }
            // ignore: argument_type_not_assignable
            return UsersItemDetailsView(item: item);
          },
        ),
      ],
    );
  }

  Future<void> __setItems() async {
    List<UsersItem> items = (jsonDecode(await __getUser()) as List<dynamic>)
        .map((dynamic e) => UsersItem.fromJson(e))
        .toList();
    setState(() {
      this.items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: widget.settingsController.themeMode,
      routerConfig: _router,
      // routerDelegate: _router.routerDelegate,
      // routeInformationParser: _router.routeInformationParser,
      // routeInformationProvider: _router.routeInformationProvider,
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
