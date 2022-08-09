import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:example/main.dart';
import 'package:example/pages.dart';
import 'package:screenshot_modes/screenshot_modes.dart';

final simpleScreenShotModesPlugin = SimpleScreenShot(
  processor: saveScreenShot,
  pages: listPush,
  lang: [Locale('ar'), Locale('en')],
  devices: [
    Devices.android.samsungGalaxyNote20.identifier,
    Devices.ios.iPhone13ProMax.identifier
  ],
  useToggleDarkMode: true,
);

final listPush = [
  ItemScreenMode(function: pushHome, label: 'home'),
  ItemScreenMode(function: pushFirst, label: 'first'),
  ItemScreenMode(function: pushSecond, label: 'second'),
];
