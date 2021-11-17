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
  final List<DeviceIdentifier>? devices;

  /// list of Locale used to take screenshot for diffrent language
  final List<Locale>? lang;

  /// pass a custon logic to change language
  final void Function(BuildContext, Locale lang) setLang;

  /// A screenshot that processes a screenshot and returns the result as a display message.
  ///you must use to save image or uploaded to internet ...
  final ScreenshotProcessor processor;
  SimpleScreenShot(
      {this.devices,
      this.useToggleDarkMode = false,
      this.setLightMode = DevicePreviewHelper.setLightMode,
      this.setDarkMode = DevicePreviewHelper.setDarkMode,
      this.setLang = DevicePreviewHelper.setLang,
      this.lang,
      required this.pages,
      required this.processor,
      void Function(BuildContext)? onEnd})
      : super(
            processor: processor,
            modes: generateListItem(
                devices: devices,
                pages: pages,
                langs: lang,
                setDarkMode: setDarkMode,
                setLang: setLang,
                setLightMode: setLightMode,
                useToggleDarkMode: useToggleDarkMode),
            onEnd: onEnd);

  static List<ItemScreenMode> generateListItem({
    List<DeviceIdentifier>? devices,
    bool useToggleDarkMode = false,
    required void Function(BuildContext) setLightMode,
    required void Function(BuildContext) setDarkMode,
    required void Function(BuildContext, Locale lang) setLang,
    List<Locale>? langs,
    required List<ItemScreenMode> pages,
  }) {
    final darkLightItems = useToggleDarkMode
        ? [
            ItemScreenMode(
                function: (context) async => setLightMode(context),
                label: 'light',
                modes: pages),
            ItemScreenMode(
                function: (context) async => setDarkMode(context),
                label: 'dark',
                modes: pages)
          ]
        : pages;

    final deviesItem = devices?.map((e) {
          var itemScreenMode = ItemScreenMode(
              function: (context) async =>
                  DevicePreviewHelper.changeDevice(context, e),
              label: e.name,
              modes: darkLightItems);
          return itemScreenMode;
        }).toList() ??
        darkLightItems;

    final langItem = langs?.map((e) {
          var itemScreenMode = ItemScreenMode(
              function: (context) async =>
                  DevicePreviewHelper.setLang(context, e),
              label: e.toString(),
              modes: deviesItem);
          return itemScreenMode;
        }).toList() ??
        deviesItem;
    return langItem;
  }
}
