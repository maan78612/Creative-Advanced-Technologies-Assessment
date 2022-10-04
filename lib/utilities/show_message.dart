import 'package:assessment/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ShowMessage {



  static void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 14.sp,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  static void snackBar(
      String title,
      String message,
      bool progress,
      ) {
    Get.snackbar(title, message,
        backgroundColor: AppConfig.colors.themeColor,
        colorText: Colors.white,
        showProgressIndicator: progress,
        progressIndicatorBackgroundColor: Colors.lightBlueAccent,
        progressIndicatorValueColor:
        const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        borderRadius: 10.sp);
  }


}
