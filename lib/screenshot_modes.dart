library screenshot_modes;

import 'dart:ui';
import 'package:device_preview/device_preview.dart';
import 'package:device_preview/plugins.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class DeviceScreenshotWithLabel {
  final String label;
  final DeviceScreenshot deviceScreenshot;
  const DeviceScreenshotWithLabel(this.label, this.deviceScreenshot);
}

class ItemScreenMode {
  const ItemScreenMode(this.function, [this.label]);
  final AsyncCallback function;
  final String label;
}

/// A plugin for device preview that allows to capture a screenshots from the
/// device (with its frame included)
///
/// An instance should be provided the the [plugins] constructor property of
/// a [DevicePreview].
class ScreenShotModesPlugin extends DevicePreviewPlugin {
  const ScreenShotModesPlugin(
      {

      ///function you must use to save image or uploaded to internet ...
      this.processor,

      /// list of type ItemScreenMode you must use
      /// function to navigate to next screen
      /// label helps with naming the image in processor
      this.modes})
      : super(
          identifier: 'screenshot-mode',
          name: 'Screenshot mode',
          icon: Icons.photo_camera,
          windowSize: const Size(220, 220),
        );

  /// A screenshot that processes a screenshot and returns the result as a display message.
  final ScreenshotProcessor processor;
  final List<ItemScreenMode> modes;

  @override
  Widget buildData(
    BuildContext context,
    Map<String, dynamic> data,
    updateData,
  ) {
    return _Screenshot(
      processor: processor,
      modes: modes,
    );
  }
}

/// Process a given [screenshot] and returns a displayed message.
///
/// See also :
///   * [DevicePreview] uses it to process all the screenshots taken by the user.
typedef ScreenshotProcessor = Future<String> Function(
  DeviceScreenshotWithLabel screenshot,
);

class _Screenshot extends StatefulWidget {
  const _Screenshot({
    Key key,
    @required this.processor,
    @required this.modes,
  }) : super(key: key);
  final List<ItemScreenMode> modes;
  final ScreenshotProcessor processor;

  @override
  _ScreenshotState createState() => _ScreenshotState();
}

class _ScreenshotState extends State<_Screenshot> {
  List<String> link = [];
  dynamic error;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _takeScreen();
    });

    super.initState();
  }

  int _indexCall = 0;
  _takeScreen() async {
    var modes = widget.modes[_indexCall++];
    await modes?.function?.call();
    await _take(modes?.label);
    await Future.delayed(Duration(milliseconds: 10));
    if (_indexCall < widget.modes.length) _takeScreen();
  }

  Future<void> _take([String label]) async {
    try {
      final screenshot = await DevicePreview.screenshot(context);

      final link =
          await widget.processor(DeviceScreenshotWithLabel(label, screenshot));
      await Clipboard.setData(ClipboardData(text: link));
      setState(() {
        this.link.add(link);
      });
    } catch (e) {
      setState(() {
        error = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = DevicePreviewTheme.of(context);
    if (error != null) {
      return SingleChildScrollView(
        child: Padding(
          padding: theme.toolBar.spacing.regular,
          child: Text(
            'Error while processing screenshot : $error',
            style: theme.toolBar.fontStyles.body.copyWith(
              color: theme.toolBar.foregroundColor,
            ),
          ),
        ),
      );
    }
    if (link != null && link.isNotEmpty) {
      return SingleChildScrollView(
        child: Padding(
          padding: theme.toolBar.spacing.regular,
          child: Column(
            children: link
                .map((e) => Text(
                      e,
                      style: theme.toolBar.fontStyles.body.copyWith(
                        color: theme.toolBar.foregroundColor,
                      ),
                    ))
                .toList(),
          ),
        ),
      );
    }
    return Center(
      child: CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(theme.toolBar.foregroundColor),
      ),
    );
  }
}

class DirectPageRouteBuilder extends PageRouteBuilder {
  DirectPageRouteBuilder({@required WidgetBuilder builder})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) =>
                builder(context),
            transitionDuration: Duration.zero);
}
