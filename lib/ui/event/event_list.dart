import 'dart:convert';

import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/model_classes/categories_model.dart';
import 'package:assessment/model_classes/image_data_model.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:assessment/ui/event/widgets/categories.dart';
import 'package:assessment/ui/event/widgets/customTags.dart';
import 'package:assessment/ui/event/widgets/drop_down_search_bar.dart';
import 'package:assessment/ui/global_widget/event_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<AppProvider>(context, listen: false).onInit();
    });

    super.initState();
  }

  // @override
  // void dispose() {
  //   Provider.of<AppProvider>(context, listen: false).onDispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return ModalProgressHUD(
        inAsyncCall: appProvider.isLoading,
        child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Column(
              children: [
                appBarCustom(),
                Wrap(
                  children: List.generate(appProvider.selectedCategories.length,
                      (index) {
                    Categories cat = appProvider.selectedCategories[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: AppTagsCustom(
                        tag: cat.title,
                        onDeleted: () {
                          appProvider.removeTAgs(cat);
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 10.sp),
                if (appProvider.categoryList.isNotEmpty) CategoriesGridView(),
                SizedBox(height: 10.sp),

                Expanded(
                  child: ListView.builder(
                    controller: appProvider.scrollController,
                    itemCount:
                        appProvider.cocoExplorerData.imagesByID?.length ?? 0,
                    itemBuilder: (_, index) {
                      /* make single instance of Image Data*/
                      ImageObjectModel imageObjectModel = ImageObjectModel(
                          imageData:
                              appProvider.cocoExplorerData.imagesByID![index],
                          imagesCaptions: appProvider
                              .cocoExplorerData.imagesCaptions!
                              .where((element) =>
                                  element.imageId ==
                                  appProvider
                                      .cocoExplorerData.imagesByID![index].id)
                              .toList(),
                          imagesSegment: appProvider
                              .cocoExplorerData.imagesSegment!
                              .where((element) =>
                                  element.imageId ==
                                  appProvider
                                      .cocoExplorerData.imagesByID![index].id)
                              .toList());

                      return eventCard(
                          imageObjectModel: imageObjectModel,
                          appProvider: appProvider);
                    },
                  ),
                ),
                if (appProvider.isLoadMoreRunning == true)
                  Padding(
                    padding: EdgeInsets.only(top: 5.sp, bottom: 20.sp),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // When nothing else to load
                if (appProvider.hasNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    color: AppConfig.colors.themeColor,
                    child: Center(
                      child: Text(
                        'You have fetched all of the content',
                        style: latoRegular.copyWith(fontSize: 14.sp),
                      ),
                    ),
                  ),

                SizedBox(height: 10.sp),
              ],
            )),
      );
    });
  }

  PreferredSize appBarCustom() {
    return PreferredSize(
        preferredSize: Size.fromHeight(85.h), child: SearchBarDropDown());
  }
}
