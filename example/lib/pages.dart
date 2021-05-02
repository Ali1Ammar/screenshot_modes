import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:screenshot_modes/screenshot_modes.dart';

import 'api_service.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future pushHome(BuildContext context) async {
  Navigator.of(navigatorKey.currentContext!)
      .push(DirectPageRouteBuilder(builder: (_) => HomePage()));
}

Future pushFirst(BuildContext context) async {
  Navigator.of(navigatorKey.currentContext!)
      .push(DirectPageRouteBuilder(builder: (_) => FirstPage()));
  // we use wait if we have animations in our page so wait until animation end then take screenshot;
}

Future pushSecond(BuildContext context) async {
  // we could get data from server;
  final data = await ApiService.getData();
  Navigator.of(navigatorKey.currentContext!).push(DirectPageRouteBuilder(
      builder: (_) => SecondPage(
            nums: data,
          )));
  // we use wait if we have animations in our page so wait until animation end then take screenshot;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: mediaQuery.platformBrightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        builder: DevicePreview.appBuilder,
        navigatorKey: navigatorKey,
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(child: Text("Home Page")),
    );
  }
}

class FirstPage extends StatelessWidget {
  FirstPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FirstPage"),
      ),
      body: Center(child: Text("FirstPage")),
    );
  }
}

class SecondPage extends StatelessWidget {
  final List nums;
  SecondPage({
    Key? key,
    required this.nums,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SecondPage"),
      ),
      body: Center(
          child: Column(
        children: [Text("SecondPage"), ...nums.map((e) => Text(e.toString()))],
      )),
    );
  }
}
