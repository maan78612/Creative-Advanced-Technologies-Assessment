import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:assessment/ui/dashoard/widgets/appBar.dart';
import 'package:assessment/ui/event/event_list.dart';
import 'package:assessment/ui/favorite/favorite_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  int index;

  DashBoard({Key? key, required this.index}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState(index: index);
}

class _DashBoardState extends State<DashBoard> {
  int index;

  _DashBoardState({required this.index});

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AppProvider>(Get.context!, listen: false)
          .onDashboardTab(index);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, _) {
      return Scaffold(
        backgroundColor: AppConfig.colors.whiteColor,
        appBar: appBarDashboard(appProvider),
        body: _getPage(appProvider.selectedDashBoardIndex),
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: bottomNavigationIcon(
                      appProvider, 0, AppConfig.images.home),
                  label: 'Home',
                  backgroundColor: const Color(0xffF4F2F2)),
              BottomNavigationBarItem(
                  icon: bottomNavigationIcon(
                      appProvider, 1, AppConfig.images.heart),
                  label: 'Favorite',
                  backgroundColor: const Color(0xffF4F2F2)),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: appProvider.selectedDashBoardIndex,
            showUnselectedLabels: true,
            selectedItemColor: AppConfig.colors.themeColor,
            unselectedItemColor: Color(0xffD9D4D5),
            selectedIconTheme: const IconThemeData(color: Colors.black),
            unselectedLabelStyle:
                latoBold.copyWith(fontSize: 12.sp, height: 2.h),
            selectedLabelStyle: latoBold.copyWith(fontSize: 12.sp),
            onTap: appProvider.onDashboardTab,
            elevation: 5),
      );
    });
  }

  ImageIcon bottomNavigationIcon(
      AppProvider appProvider, int index, String image) {
    return ImageIcon(
      AssetImage(image),
      size: 25.sp,
      color: appProvider.selectedDashBoardIndex == index
          ? AppConfig.colors.themeColor
          : Color(0xffD9D4D5),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return EventList();
      case 1:
        return FavoriteScreen();

      default:
        return EventList();
    }
  }
}
