# screenshot_modes

<h4 align="center">easy screenshot take for your app</h4><br/>

<h5>screenshot_modes is a flutter package that work ad plugin for device preview package, take automatice screenshots for our app page </h5>
<br/><br/>
<p align="center">
  <img src="https://raw.githubusercontent.com/Ali1Ammar/screenshot_modes/main/screenshot_modes.gif" alt="screenshot modes for Flutter gif" />
</p>

# you will need to setup [device preview](https://pub.dev/packages/device_preview') package first before using this plugin. it is just a few step.

# setup this plugin 

0- you will need to setup [device preview](https://pub.dev/packages/device_preview') package first before using this plugin. it is just a few step.<br/>

1-  define ScreenShotModesPlugin
```dart
final screenShotModesPlugin =  ScreenShotModesPlugin(processor: saveScreenShot, modes: _modes );
```
<br/>
2- pass screenShotModesPlugin to DevicePreview

```dart
void main() {
  runApp(DevicePreview(
    builder: (_) => MyApp(),
    plugins: [
      screenShotModesPlugin,
    ],
  ));
}
```
<br/>

3- define saveScreenShot function  this response for saving the image or upload it to some server or that ever you want to do with the image example to save the image in desktop 
<br/>
```dart
Future<String> saveScreenShot(DeviceScreenshotWithLabel screen) async {
  String name = screen.label; // this same label defined in ItemScreenMode 
  final path = join(Directory.current.path, 'screenshot', '$name.png');
  final imageFile = File(path);
  await imageFile.create(recursive: true);
  await imageFile.writeAsBytes(screen.deviceScreenshot.bytes);
  return '$path saved'; // messege printed to device preview plugins windwos;
}
```
<br/>
4- add item to _modes list 
<br/>

```dart

final _modes = [
  ItemScreenMode(null, 'home'),
  ItemScreenMode(pushFirst, 'first'),
  ItemScreenMode(pushSecond, 'second'),
  ItemScreenMode(changeModeDarkLight, 'home'),
  ItemScreenMode(pushFirst, 'first'),
  ItemScreenMode(pushSecond, 'second'),
];

```
<br/>
5- click the new button(screenshot mode) in device preview tabs 

# what is ItemScreenMode : 
<h7>it is represents every screenshot we will take </h7><br/>
<h7>
the first parameter is a function that called before take screen 
we must navigate to the page you want take screenshot for it
maybe also get some data from database or api before navigate 
</h7><br/>
<h7>
the scond parameter label is string helps for naming the image inside  processor (saveScreenShot) 
</h7><br/>
<br/><br/>
# why there is null in first ItemScreenMode ?
<br/>
because we didnt need to do any things before first shot we already inside home page (defalut page)
<br/>
# why we must use DirectPageRouteBuilder for navigation
<br/>
you must use DirectPageRouteBuilder for navigation like this
<br/>

```dart
Future pushFirst() async {
  Navigator.of(navigatorKey.currentContext)
      .push(DirectPageRouteBuilder(builder: (_) => FirstPage()));
  // we use wait if we have animations in our page so wait until animation end then take screenshot;
}

Future pushSecond() async {
  // we could get data from server;
  final data = await ApiService.getData();
  Navigator.of(navigatorKey.currentContext).push(DirectPageRouteBuilder(
      builder: (_) => SecondPage(
            nums: data,
          )));
  // we use wait if we have animations in our page so wait until animation end then take screenshot;
}

```

<br/>
because the MaterialPageRoute have 500ms Duration for animations 
this will cause as a problem with screenshot 
so we must etiher use DirectPageRouteBuilder or await 500ms Duration after Navigation inside ItemScreenMode function
<br/><br/><br/>
