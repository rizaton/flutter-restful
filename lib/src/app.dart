import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_restful_api/src/users_feature/users_item.dart';

import 'users_feature/users_item_list_view.dart';
import 'users_feature/users_item_details_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
  late List<UsersItem> items;

  @override
  void initState() {
    __setItems();
    super.initState();
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
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
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
          routes: <String, WidgetBuilder>{
            '/': (BuildContext context) => const UsersItemListView(),
            '/settings': (BuildContext context) =>
                SettingsView(controller: widget.settingsController),
            '/usersItem': (BuildContext context) => const UsersItemListView(),
          },
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                late Object? arguments = routeSettings.arguments;
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: widget.settingsController);
                  case UsersItemListView.routeName:
                    return const UsersItemListView();
                  default:
                    if (routeSettings.name!.contains('/usersItem/')) {
                      if (arguments != null) {
                        try {
                          final args = arguments as Map<String, dynamic>;
                          return UsersItemDetailsView(
                              item: args['item'] as UsersItem);
                        } catch (e) {
                          rethrow;
                        }
                      } else {
                        final int index = int.parse(
                            routeSettings.name!.replaceAll('/usersItem/', ''));
                        arguments = {
                          'item': items[index],
                          'id': items[index].id
                        };
                        final args = arguments as Map<String, dynamic>;
                        try {
                          return UsersItemDetailsView(
                              item: args['item'] as UsersItem);
                        } catch (e) {
                          rethrow;
                          // print('get HIT2 $arguments');
                          // // return const UsersItemListView();
                          // return build(context);
                        }
                      }
                    } else {
                      return build(context);
                    }
                }
              },
            );
          },
        );
      },
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
