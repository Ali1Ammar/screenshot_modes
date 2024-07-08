import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'modal.dart';

typedef AyncCallbackContext = Future<void> Function(BuildContext context);

/// A plugin for device preview that allows to capture a screenshots from the
/// device (with its frame included)
///
/// An instance should be provided the the [plugins] constructor property of
/// a [DevicePreview].
class ScreenShotModesPlugin extends StatelessWidget {
  const ScreenShotModesPlugin(
      {required this.processor, required this.modes, this.onEnd});

  /// A screenshot that processes a screenshot and returns the result as a display message.
  ///you must use to save image or uploaded to internet ...
  final ScreenshotProcessor processor;

  /// list of type ItemScreenMode repersents all mode page will be taken
  /// function to navigate to next screen
  /// label helps with naming the image in processor
  /// modes , used if you have nested like device frame , dark light mode before page
  final List<ItemScreenMode> modes;
  final void Function(BuildContext)? onEnd;

  @override
  Widget build(
    BuildContext context,
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
    Key? key,
    required this.processor,
    required this.modes,
    this.onEnd,
  }) : super(key: key);
  final List<ItemScreenMode> modes;
  final ScreenshotProcessor processor;
  final void Function(BuildContext)? onEnd;
  @override
  _ScreenshotState createState() => _ScreenshotState();
}

class _ScreenshotState extends State<_Screenshot> {
  bool isLoading = false;
  List<Object> link = [];
  dynamic error;
  void pressTake() {
    setState(() {
      link.clear();
      isLoading = true;
    });

    _takeScreen(widget.modes, []).then((_) {
      setState(() {
        isLoading = false;
      });
      widget.onEnd?.call(context);
    });
  }

  Future<void> _takeScreen(
      List<ItemScreenMode> modes, List<Object> label) async {
    for (final mode in modes) {
      await mode.function?.call(context);
      if (mode.modes != null) {
        await _takeScreen(
            mode.modes!, [...label, if (mode.label != null) mode.label!]);
      } else {
        await Future.delayed(Duration(milliseconds: 400));
        await _take([...label, if (mode.label != null) mode.label!]);
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
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 32.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            SafeArea(
              top: false,
              bottom: false,
              minimum: const EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "screenshot mode",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : OutlinedButton(
                          onPressed: pressTake,
                          child: Text(isLoading ? "Re Take" : "Take")),
                  if (!isLoading && link.isNotEmpty)
                    IconButton(
                        onPressed: () {
                          setState(() {
                            link.clear();
                          });
                        },
                        icon: Icon(Icons.clear))
                ],
              ),
            ),
            if (error != null)
              Text(
                'Error while processing screenshot : $error',
              ),
            if (link.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                    itemCount: link.length,
                    itemBuilder: (context, i) {
                      final item = link[link.length - i - 1];
                      return Text(item.toString());
                    }),
              ),
            Divider()
          ],
        ),
      ),
    );
  }
}
