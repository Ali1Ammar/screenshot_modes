import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class DevicePreviewHelper {
  static DevicePreviewStore getDevicePreviewStore(BuildContext context) =>
      Provider.of<DevicePreviewStore>(context, listen: false);
  static DevicePreviewData getDevicePreviewData(BuildContext context) =>
      getDevicePreviewStore(context).data;
  static isDarkMode(BuildContext context, {bool listen = true}) => listen
      ? Provider.of<DevicePreviewStore>(context, listen: true).data.isDarkMode
      : getDevicePreviewData(context).isDarkMode;
  static void toggleMode(BuildContext context) =>
      getDevicePreviewStore(context).toggleDarkMode();
  static void setMode(BuildContext context, ThemeMode mode) {
    final store = getDevicePreviewStore(context);
    final currentMode =
        store.data.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    if (mode != currentMode) {
      store.toggleDarkMode();
    }
  }

  static void setLightMode(BuildContext context) =>
      setMode(context, ThemeMode.light);
  static void setDarkMode(BuildContext context) =>
      setMode(context, ThemeMode.dark);
  static void changeDevice(
      BuildContext context, DeviceIdentifier device) async {
    DevicePreviewHelper.getDevicePreviewStore(context).selectDevice(device);
  }
}

class DirectPageRouteBuilder extends PageRouteBuilder {
  DirectPageRouteBuilder({@required WidgetBuilder builder})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) =>
                builder(context),
            transitionDuration: Duration.zero);
}

extension ListHelper on List {
  bool get isEmptyOrNull => this == null || this.isEmpty;
  bool get isNotEmptyNotNull => this != null && this.isNotEmpty;
}
