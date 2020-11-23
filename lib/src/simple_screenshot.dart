import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';

import '../screenshot_modes.dart';

class SimpleScreenShot extends ScreenShotModesPlugin {
  /// true if you want to take screen for light and dark mode.
  final bool useToggleDarkMode;

  /// use if you have special function for settin modes, default Device_preview way
  final void Function(BuildContext) setLightMode;

  /// use if you have special function for settin modes, default Device_preview way
  final void Function(BuildContext) setDarkMode;

  ///  list of ItemScreenMode , represnts all your page
  final List<ItemScreenMode> pages;

  /// list of device(frame) to take screen to it, frames set using Devices class  like taht
  ///   Devices.android.samsungNote10Plus.identifier,
  ///   Devices.ios.iPhone11ProMax.identifier,
  final List<DeviceIdentifier> devices;

  /// A screenshot that processes a screenshot and returns the result as a display message.
  ///you must use to save image or uploaded to internet ...
  final ScreenshotProcessor processor;
  SimpleScreenShot(
      {this.devices,
      this.useToggleDarkMode = false,
      this.setLightMode = DevicePreviewHelper.setLightMode,
      this.setDarkMode = DevicePreviewHelper.setDarkMode,
      @required this.pages,
      @required this.processor,
      void Function(BuildContext) onEnd})
      : super(
            processor: processor,
            modes: devices.isEmptyOrNull
                ? pages
                : [
                    ...devices
                        .map<ItemScreenMode>((e) => ItemScreenMode(
                            function: (context) async =>
                                DevicePreviewHelper.changeDevice(context, e),
                            label: e.name,
                            modes: useToggleDarkMode
                                ? [
                                    ItemScreenMode(
                                        function: (context) async =>
                                            setLightMode(context),
                                        label: 'light',
                                        modes: pages),
                                    ItemScreenMode(
                                        function: (context) async =>
                                            setDarkMode(context),
                                        label: 'dark',
                                        modes: pages)
                                  ]
                                : pages))
                        .toList()
                  ],
            onEnd: onEnd);
}
