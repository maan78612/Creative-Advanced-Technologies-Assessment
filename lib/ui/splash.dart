import 'dart:convert';

import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/hive/hive_services.dart';
import 'package:assessment/main.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:assessment/ui/event/event_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../model_classes/event_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;

  Future<void> navigateToNext() async {
    Future.delayed(const Duration(seconds: 2), () async {
      await onInit();
    });
  }

  onInit() async {
    /* open hive box*/
    await HiveServices.openBox(HiveServices.boxName);

    /* Hive functions to Get favorite events from mobile database*/
    Provider.of<AppProvider>(context, listen: false)..getFavoriteList()..fetchAllCategories();

    Get.to(() => EventList());

  }

  @override
  void initState() {
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animation.forward();
      }
    });
    animation.forward();

    navigateToNext();
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.colors.whiteColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeInFadeOut,
          child: Image.asset(
            AppConfig.images.logo,
          ),
        ),
      ),
    );
  }
}
