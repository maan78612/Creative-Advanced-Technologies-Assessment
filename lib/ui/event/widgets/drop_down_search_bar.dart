/* Temporary for showing search on Google map*/

import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/model_classes/categories_model.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:assessment/provider/text_form_provider.dart';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class searchDropDown extends StatefulWidget {
  @override
  _searchDropDownState createState() => new _searchDropDownState();
}

class _searchDropDownState extends State<searchDropDown> {
  GlobalKey<AutoCompleteTextFieldState<Categories>> key = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  bool fillColor = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, TextFormProvider>(
        builder: (context, appProvider, textFormProvider, _) {
      return Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 12.sp,
            right: 12.sp,
            bottom: 12.sp),
        child: Row(
          children: [
            Expanded(
              child: AutoCompleteTextField<Categories>(
                key: key,
                controller: textFormProvider.textEditingController,
                suggestions: appProvider.categoryList,
                style: latoRegular.copyWith(fontSize: 16.sp),
                clearOnSubmit: true,
                decoration: InputDecoration(
                  hintText: 'Search',
                  filled: true,
                  hintStyle: latoBold.copyWith(
                      fontSize: 16.sp, color: AppConfig.colors.grey),
                  fillColor: AppConfig.colors.fillColor,
                  suffixIcon: (textFormProvider.searchField.isNotEmpty)
                      ? GestureDetector(
                          onTap: () {
                            textFormProvider.clearSearchText();
                          },
                          child: Icon(
                            Icons.cancel,
                            color: AppConfig.colors.whiteColor,
                            size: 14.sp,
                          ),
                        )
                      : null,
                  contentPadding: const EdgeInsets.all(0.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                    borderSide:
                        BorderSide(color: AppConfig.colors.enableBorderColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                    borderSide:
                        BorderSide(color: AppConfig.colors.fieldBorderColor),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: AppConfig.colors.fieldBorderColor),
                  ),
                  prefixIcon: Image.asset(
                    AppConfig.images.search,
                    scale: 3.sp,
                    width: 13.w,
                    height: 13.h,
                    fit: BoxFit.scaleDown,
                    color: AppConfig.colors.whiteColor,
                  ),
                ),
                itemBuilder: (context, item) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    textFormProvider.search();
                  });

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item.title,
                      style: latoRegular.copyWith(
                          fontSize: 14.sp, color: AppConfig.colors.themeColor),
                    ),
                  );
                },
                itemFilter: (item, query) {
                  return item.title
                      .toLowerCase()
                      .startsWith(query.toLowerCase());
                },
                itemSorter: (a, b) {
                  return a.title.compareTo(b.title);
                },
                itemSubmitted: (item) async {
                  if (!appProvider.selectedCategories.contains(item) &&
                      item.title.isNotEmpty) {
                    appProvider.addTAgs(item);
                    textFormProvider.textEditingController.clear();
                  }
                  // textFormProvider.onEditComplete();
                },
              ),
            ),
            SizedBox(width: 10.sp),
            ElevatedButton(
              onPressed: () {
                appProvider.searchByID();
              },
              child: Text(
                "search",
                style: latoBold.copyWith(
                    fontSize: 12.sp, color: AppConfig.colors.whiteColor),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.sp))),
                foregroundColor: AppConfig.colors.whiteColor,
                backgroundColor: AppConfig.colors.blue,
              ),
            )
          ],
        ),
      );
    });
  }
}

class LocationStatic {
  late double lat;
  late double long;
  late String address;

  LocationStatic(
      {required this.lat, required this.long, required this.address});
}
