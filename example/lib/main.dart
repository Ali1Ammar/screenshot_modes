import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:screenshot_modes/screenshot_modes.dart';
import 'api_service.dart';

/*
this example do this
screenshot home page 
screenshot first page 
 get data for second page then navigate to it and take screenshot
change theme mode from light to dark ( toggle mode) then take screenshot above
*/
void main() {
  runApp(DevicePreview(
    builder: (_) => MyApp(),
    plugins: [
      screenShotModesPlugin,
    ],
  ));
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final screenShotModesPlugin =
    ScreenShotModesPlugin(processor: saveScreenShot, modes: [
  ItemScreenMode(null, 'home'),
  ...listPush,
  ItemScreenMode(changeModeDarkLight, 'home'),
  ...listPush
]);
final listPush = [
  ItemScreenMode(pushFirst, 'first'),
  ItemScreenMode(pushSecond, 'second'),
];
final _notifier = ValueNotifier<ThemeMode>(ThemeMode.light);
switchMode() {
  _notifier.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
}

bool get isDarkMode => _notifier.value == ThemeMode.dark;

Future<void> changeModeDarkLight() async {
  Navigator.of(navigatorKey.currentContext)
      .push(DirectPageRouteBuilder(builder: (_) => HomePage()));
  await switchMode();
}

Future pushFirst() async {
  Navigator.of(navigatorKey.currentContext)
      .push(DirectPageRouteBuilder(builder: (_) => FirstPage()));
  // we use wait if we have animations in our page so wait until animation end then take screenshot;
}

Future pushSecond() async {
  // we could get data from server;
  final data = await ApiService.getData();
  Navigator.of(navigatorKey.currentContext).push(DirectPageRouteBuilder(
      builder: (_) => SecondPage(
            nums: data,
          )));
  // we use wait if we have animations in our page so wait until animation end then take screenshot;
}

Future<String> saveScreenShot(DeviceScreenshotWithLabel screen) async {
  String name = screen.label;
  final mode = isDarkMode ? 'dark' : 'ligh';
  final path = join(Directory.current.path, 'screenshot', '$name-$mode.png');
  final imageFile = File(path);
  await imageFile.create(recursive: true);
  await imageFile.writeAsBytes(screen.deviceScreenshot.bytes);
  return '$path saved'; // messege printed to device preview plugins windwos;
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            builder: DevicePreview.appBuilder,
            themeMode: mode,
            navigatorKey: navigatorKey,
            home: HomePage());
      },
    );
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
    Key key,
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
    Key key,
    this.nums,
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

