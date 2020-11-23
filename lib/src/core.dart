import 'dart:ui';
import 'package:device_preview/device_preview.dart';
import 'package:device_preview/plugins.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'modal.dart';
import 'helper.dart';

typedef AyncCallbackContext = Future<void> Function(BuildContext context);

/// A plugin for device preview that allows to capture a screenshots from the
/// device (with its frame included)
///
/// An instance should be provided the the [plugins] constructor property of
/// a [DevicePreview].
class ScreenShotModesPlugin extends DevicePreviewPlugin {
  const ScreenShotModesPlugin(
      {@required this.processor, @required this.modes, this.onEnd})
      : super(
          identifier: 'screenshot-mode',
          name: 'Screenshot mode',
          icon: Icons.photo_camera,
          windowSize: const Size(220, 220),
        );

  /// A screenshot that processes a screenshot and returns the result as a display message.
  ///you must use to save image or uploaded to internet ...
  final ScreenshotProcessor processor;

  /// list of type ItemScreenMode repersents all mode page will be taken
  /// function to navigate to next screen
  /// label helps with naming the image in processor
  /// modes , used if you have nested like device frame , dark light mode before page
  final List<ItemScreenMode> modes;
  final void Function(BuildContext) onEnd;

  @override
  Widget buildData(
    BuildContext context,
    Map<String, dynamic> data,
    updateData,
  ) {
    return _Screenshot(
      processor: processor,
      modes: modes,
      onEnd: onEnd,
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
    this.onEnd,
  }) : super(key: key);
  final List<ItemScreenMode> modes;
  final ScreenshotProcessor processor;
  final void Function(BuildContext) onEnd;
  @override
  _ScreenshotState createState() => _ScreenshotState();
}

class _ScreenshotState extends State<_Screenshot> {
  bool isend = false;
  List<Object> link = [];
  dynamic error;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isend) {
        setState(() {
          isend = false;
        });
      }
      _takeScreen(widget.modes, []).then((_) {
        setState(() {
          isend = true;
        });
        widget.onEnd?.call(context);
      });
    });

    super.initState();
  }

  Future<void> _takeScreen(
      List<ItemScreenMode> modes, List<Object> label) async {
    for (final mode in modes) {
      await mode?.function?.call(context);
      if (mode.modes.isNotEmptyNotNull) {
        await _takeScreen(mode.modes, [...label, mode.label]);
      } else {
        await Future.delayed(Duration(milliseconds: 400));
        await _take([...label, mode.label]);
        await Future.delayed(Duration(milliseconds: 40));
      }
    }
  }

  Future<void> _take(List<Object> label) async {
    try {
      final screenshot = await DevicePreview.screenshot(context);

      final link =
          await widget.processor(DeviceScreenshotWithLabel(label, screenshot));
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
            children: [
              isend ? Text("endinggg") : Text("still"),
              ...link
                  .map((e) => Text(
                        e,
                        style: theme.toolBar.fontStyles.body.copyWith(
                          color: theme.toolBar.foregroundColor,
                        ),
                      ))
                  .toList()
            ],
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
