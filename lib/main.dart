import 'dart:io';

import 'package:assessment/env/prod.dart';
import 'package:assessment/model_classes/app_config_env.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:assessment/provider/text_form_provider.dart';
import 'package:assessment/ui/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:overlay_tutorial/overlay_tutorial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

main({String env = "dev"}) async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  runApp(MyApp());
}

class SimpleCounterTutorial extends StatefulWidget {
  final String title;

  const SimpleCounterTutorial({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _SimpleCounterTutorialState createState() => _SimpleCounterTutorialState();
}

class _SimpleCounterTutorialState extends State<SimpleCounterTutorial>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _tweenAnimation;

  bool _isTutorialEnabled = true;

  int _counter = 0;

  List<double> data2 = [
    417.58,
    447.18,
    420.66,
    542.52,
    376.06,
    542.52,
    377.6,
    514.84,
    376.06,
    465.63,
    391.44,
    462.55,
    389.13,
    448.71,
    386.83,
    434.1,
    393.75,
    426.42,
    407.59,
    425.65,
    415.28,
    442.56,
    419.89,
    448.71,
    310.71,
    484.85,
    319.93,
    470.24,
    317.63,
    466.4,
    342.23,
    474.09,
    348.38,
    474.09,
    349.92,
    494.85,
    353.77,
    520.22,
    356.84,
    540.21,
    298.41,
    537.9,
    308.4,
    517.91,
    309.94,
    503.3,
    308.4,
    483.31,
    319.17,
    341.84,
    363.76,
    340.3,
    365.3,
    351.83,
    355.3,
    351.83,
    351.46,
    361.06,
    349.92,
    386.43,
    331.47,
    377.21,
    315.32,
    373.36,
    313.78,
    368.75,
    317.63,
    355.68,
    316.86,
    346.45,
    284.57,
    342.61,
    274.57,
    343.38,
    259.19,
    381.05,
    256.12,
    401.04,
    264.57,
    384.13,
    278.41,
    376.44,
    287.64,
    375.67,
    294.56,
    368.75,
    293.79,
    363.37,
    286.1,
    357.22
  ];

  List<double> data = [
    392.94,
    437.49,
    406.6,
    428.65,
    417.04,
    445.52,
    428.29,
    446.33,
    429.1,
    431.86,
    428.29,
    419.01,
    435.52,
    388.48,
    433.11,
    365.98,
    421.86,
    341.88,
    409.81,
    336.25,
    404.99,
    328.22,
    388.12,
    304.92,
    365.62,
    313.76,
    363.21,
    333.04,
    365.62,
    349.11,
    354.38,
    358.75,
    348.75,
    370.8,
    350.36,
    386.87,
    358.39,
    406.15,
    361.61,
    428.65,
    368.03,
    437.49,
    375.27,
    443.92,
    373.66,
    454.36,
    382.5,
    458.38,
    389.73,
    458.38,
    391.33,
    439.9,
    392.94,
    435.08,
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _tweenAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_animationController
      ..repeat(
        reverse: true,
      ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(data.length);
    final textTheme = Theme.of(context).textTheme;
    const tutorialColor = Colors.yellow;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Creative Advance Technology Assessment',
      home: SafeArea(
        child: Builder(builder: (context) {
          List<Offset> offset = [];
          List<Offset> offset2 = [];
          for (int x = 0; x < data.length;) {
            offset.add(Offset(data[x], data[x + 1]));
            x = x + 2;
          }
          for (int x = 0; x < data2.length;) {
            offset2.add(Offset(data2[x], data2[x + 1]));
            x = x + 2;
          }
          return Stack(
            children: [
              OverlayTutorialScope(
                enabled: _isTutorialEnabled,
                overlayColor: Colors.blueAccent.withOpacity(.6),
                // Disable all the widgets. All the widgets are now non-interactive.
                child: AbsorbPointer(
                  absorbing: _isTutorialEnabled,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(widget.title),
                    ),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OverlayTutorialHole(
                            enabled: true,
                            overlayTutorialEntry:
                                OverlayTutorialCustomShapeEntry(
                              shapeBuilder: (rect, path) {
                                path = Path.combine(
                                  PathOperation.difference,
                                  path,
                                  Path()..addPolygon(offset2, true),
                                );
                                return path;
                              },
                            ),
                            child: const Icon(
                              Icons.share,
                              size: 64,
                            ),
                          ),
                          const SizedBox(height: 64),
                          const Text(
                            'You have pushed the button this many times:',
                          ),
                          OverlayTutorialHole(
                            enabled: true,
                            overlayTutorialEntry: OverlayTutorialRectEntry(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              radius: const Radius.circular(16.0),
                              overlayTutorialHints: <OverlayTutorialWidgetHint>[
                                OverlayTutorialWidgetHint(
                                  position: (rect) => Offset(0, rect.bottom),
                                  builder: (context, entryRect) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Current Counter will be displayed here',
                                            style: textTheme.bodyText2!
                                                .copyWith(color: tutorialColor),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            child: Text(
                              '$_counter',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    floatingActionButton: OverlayTutorialHole(
                      enabled: true,
                      overlayTutorialEntry: OverlayTutorialRectEntry(
                        padding: const EdgeInsets.all(8.0),
                        radius: const Radius.circular(16.0),
                        overlayTutorialHints: [
                          OverlayTutorialWidgetHint(
                            builder: (context, entryRect) {
                              return Positioned(
                                top: entryRect.rRect!.top - 24.0,
                                left: entryRect.rRect!.left,
                                child: Text(
                                  'Try this out',
                                  style: textTheme.bodyText2!
                                      .copyWith(color: tutorialColor),
                                ),
                              );
                            },
                          ),
                          OverlayTutorialWidgetHint(
                            position: (rect) => Offset(0, rect.center.dy),
                            builder: (context, entryRect) {
                              return SizedBox(
                                width: entryRect.rRect!.left,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Click here to add counter',
                                          style: textTheme.bodyText2!
                                              .copyWith(color: tutorialColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      child: FloatingActionButton(
                        onPressed: _incrementCounter,
                        tooltip: 'Increment',
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ),
              ),
              if (_isTutorialEnabled)
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      _isTutorialEnabled = false;
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    /* Initialize environment variables on basis on [main_dev] && [main_prod] classes*/
    AppConfigEnv.fromJson(configPro);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => TextFormProvider()),
        ],
        child: ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (BuildContext context, Widget? child) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Creative Advance Technology Assessment',
                home: child,
              );
            },
            child: const SplashScreen()));
  }
}
