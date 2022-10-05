/* Temporary for showing search on Google map*/

import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/model_classes/categories_model.dart';
import 'package:assessment/provider/app_provider.dart';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchBarDropDown extends StatelessWidget {
  GlobalKey<AutoCompleteTextFieldState<Categories>> searchGlobalKey =
      GlobalKey();
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, _) {
      return Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10.sp,
            left: 12.sp,
            right: 12.sp,
            bottom: 12.sp),
        child: Row(
          children: [
            Expanded(
              child: AutoCompleteTextField<Categories>(
                key: searchGlobalKey,
                controller: _textEditingController,
                suggestions: appProvider.categoryList,
                style: latoRegular.copyWith(fontSize: 16.sp),
                clearOnSubmit: true,
                decoration: InputDecoration(
                  hintText: 'Search',
                  filled: true,
                  hintStyle: latoBold.copyWith(
                      fontSize: 16.sp, color: AppConfig.colors.grey),
                  fillColor: AppConfig.colors.fillColor,
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
                    _textEditingController.clear();
                  }
                  // textFormProvider.onEditComplete();
                },
              ),
            ),
            SizedBox(width: 10.sp),
            ElevatedButton(
              onPressed: () {
                appProvider.getImagesID();
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
