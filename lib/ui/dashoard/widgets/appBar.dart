import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar appBarDashboard(AppProvider appProvider) {
  return AppBar(
    backgroundColor: AppConfig.colors.themeColor,
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Text(
      appProvider.selectedDashBoardIndex == 0 ? "Home" : "Favorite",
      style: latoBlack.copyWith(
          fontSize: 18.sp, color: AppConfig.colors.whiteColor),
    ),
  );
}