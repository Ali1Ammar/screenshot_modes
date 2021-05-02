import 'package:device_preview/device_preview.dart';
import 'package:example/pages.dart';
import 'package:flutter/material.dart';
import 'package:screenshot_modes/screenshot_modes.dart';
import 'main.dart';

final advancedScreenShotModesPlugin =
    ScreenShotModesPlugin(processor: saveScreenShot, modes: listDevice);
final listDevice = [
  ItemScreenMode(
    function: setDeviceToIphone,
    label: "iphone",
    modes: listLightDark,
  ),
  ItemScreenMode(
      function: setDeviceToNote, label: "note", modes: listLightDark),
];
final listLightDark = [
  ItemScreenMode(
      function: (context) async {
        await setModeTo(context, ThemeMode.light);
      },
      label: "light",
      modes: listPush),
  ItemScreenMode(
      function: (context) async {
        await setModeTo(context, ThemeMode.dark);
      },
      label: "dark",
      modes: listPush),
];
final listPush = [
  ItemScreenMode(function: pushHome, label: 'home'),
  ItemScreenMode(function: pushFirst, label: 'first'),
  ItemScreenMode(function: pushSecond, label: 'second'),
];

Future<void> changeModeDarkLight(BuildContext context) async {
  DevicePreviewHelper.toggleMode(context);
}

Future<void> setModeTo(BuildContext context, ThemeMode mode) async {
  Navigator.of(navigatorKey.currentContext!)
      .push(DirectPageRouteBuilder(builder: (_) => HomePage()));
  final store = DevicePreviewHelper.getDevicePreviewStore(context);
  if (store.data.isDarkMode && mode == ThemeMode.light) {
    store.toggleDarkMode();
  }
}

Future<void> setDeviceToNote(BuildContext context) async {
  DevicePreviewHelper.changeDevice(
      context, Devices.android.samsungNote10Plus.identifier);
}

Future<void> setDeviceToIphone(BuildContext context) async {
  DevicePreviewHelper.getDevicePreviewStore(context)
      .selectDevice(Devices.ios.iPhone11.identifier);
}
