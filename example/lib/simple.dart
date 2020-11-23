import 'package:device_preview/device_preview.dart';
import 'package:example/main.dart';
import 'package:example/pages.dart';
import 'package:screenshot_modes/screenshot_modes.dart';

final simpleScreenShotModesPlugin = SimpleScreenShot(
  processor: saveScreenShot,
  pages: listPush,
  devices: [
    Devices.android.samsungNote10Plus.identifier,
    Devices.ios.iPhone11ProMax.identifier,
    Devices.ios.iPadMini.identifier,
    Devices.android.samsungS20.identifier,
  ],
  useToggleDarkMode: true,
);

final listPush = [
  ItemScreenMode(function: pushHome, label: 'home'),
  ItemScreenMode(function: pushFirst, label: 'first'),
  ItemScreenMode(function: pushSecond, label: 'second'),
];
