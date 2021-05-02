import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:example/pages.dart';
import 'package:example/simple.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:screenshot_modes/screenshot_modes.dart';

/*
this example do this
screenshot home page 
screenshot first page 
 get data for second page then navigate to it and take screenshot
change theme mode from light to dark ( toggle mode) then take screenshot above
*/
void main() {
  runApp(DevicePreview(
    builder: (_) =>
        MaterialApp(builder: DevicePreview.appBuilder, home: MyApp()),
    plugins: [
      // you only need one ethier simple way or advanced way
      // advancedScreenShotModesPlugin,
      simpleScreenShotModesPlugin
    ],
  ));
}

Future<String> saveScreenShot(DeviceScreenshotWithLabel screen) async {
  String name = screen.label.join('/');
  final path = join(Directory.current.path, 'screenshot', '$name.png');
  final imageFile = File(path);
  await imageFile.create(recursive: true);
  await imageFile.writeAsBytes(screen.deviceScreenshot.bytes);
  return '$path saved'; // messege printed to device preview plugins windwos;
}
