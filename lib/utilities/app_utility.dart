import 'package:assessment/utilities/show_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUtility {


  static void hideKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  static String getFreshDateTimeID() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // will pop function
   DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ShowMessage.toast("press again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }






}
