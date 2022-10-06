import 'dart:async';
import 'dart:convert';
import 'package:assessment/constants/categoryConstantData.dart';
import 'package:assessment/hive/hive_services.dart';
import 'package:assessment/model_classes/categories_model.dart';
import 'package:assessment/model_classes/data_model.dart';
import 'package:assessment/model_classes/error_response.dart';
import 'package:assessment/model_classes/image_data_model.dart';
import 'package:assessment/services/api_services.dart';
import 'package:assessment/utilities/show_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool isLoading = false;

  void startLoader() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoader() {
    isLoading = false;
    notifyListeners();
  }

  /*=================================== Dashboard =============================*/

  int selectedDashBoardIndex = 0;

  /* DashBoard indexing*/
  void onDashboardTab(int index) {
    if (selectedDashBoardIndex != index) {
      selectedDashBoardIndex = index;

      if (kDebugMode) {
        print("DashBoard index is $selectedDashBoardIndex");
      }
    }

    notifyListeners();
  }

  /*=================================== GET  DATA=============================*/

/*     API Call For Data */
  late COCOExplorerData cocoExplorerData = COCOExplorerData.fromJson(({}));

  // At the beginning, we fetch the first 20 posts
  int _pageIndex = 0;

  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int perPageItemLimit = 10;

  // There is next page or not
  bool hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool isLoadMoreRunning = false;
  ScrollController scrollController = ScrollController();

  onInit() {
    print("onInit");
    scrollController = ScrollController()..addListener(getImagesData);
    notifyListeners();
  }

  onDispose() {
    print("onDispose");
    scrollController.removeListener(getImagesData);

    notifyListeners();
  }

  List<int> imagesIDs = [];

  Future<void> getImagesID() async {
    /* In this function first we are get all images ID*/
    cocoExplorerData.imagesByID = [];
    cocoExplorerData.imagesSegment = [];
    cocoExplorerData.imagesCaptions = [];
    hasNextPage = true;
    isLoadMoreRunning = false;
    _pageIndex = 0;
    List<int> catIDs = [];
    startLoader();
    selectedCategories.forEach((element) {
      catIDs.add(element.id);
    });

    dynamic res = await APIServices.getImageIDsByCategoryID(catIDs);
    if (res is ErrorResponse) {
      ShowMessage.inDialog(res.errorDescription??"", true);
      stopLoader();
    } else {
      imagesIDs = List<int>.from(res);
      print("length of ImagesID is");
      print(imagesIDs.length);

      /* sent images ID to load data chunk we want*/

      await getImagesData(isFirst: true);

      stopLoader();

      notifyListeners();
    }
  }

  Future<void> getImagesData({bool isFirst = false}) async {
    /*================To get the scroll position================*/
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;

    /*===================== If there is next page & no loading and scroll
        position is on end then call API Function ==========================*/
    hasNextPage=true;
    if ((hasNextPage == true &&
            isLoadMoreRunning == false &&
            maxScroll == currentScroll) ||
        isFirst == true) {
      /*=================Calculating and indexing Images ID array to call number of data in group of 10=============*/
      int reminder = imagesIDs.length.remainder(perPageItemLimit);
      int lastPageItems = (reminder == 0) ? perPageItemLimit : reminder;
      print("Reminder is $reminder");
      print("lastPageItems is $lastPageItems");
      double totalPages = imagesIDs.length / perPageItemLimit;
      int currentPageItemLength =
          (totalPages.toInt()) != _pageIndex ? perPageItemLimit : lastPageItems;
      print("totalPages is $totalPages");
      print("currentPage index is $_pageIndex");
      print("currentPageItemLength is $currentPageItemLength");

      int startIndex = _pageIndex * currentPageItemLength;
      int endIndex = startIndex + currentPageItemLength - 1;
      print("startIndex ${startIndex}");
      print("endIndex ${endIndex}");
      /*==========================================================================================================*/
      isLoadMoreRunning =
          !isFirst; // if we are calling first time or hit search then no need to show bottom loader
      notifyListeners(); // Display a progress indicator at the bottom

      if (_pageIndex > totalPages.toInt()) {
        // This means there is no more data
        // and therefore, we will not send another GET request
        hasNextPage = false;
        isLoadMoreRunning = false;
      } else {
        _pageIndex += 1; // Increase _page by 1

        List<int> selectedImagesID = [];
        for (int i = startIndex; i <= endIndex; i++) {
          selectedImagesID.add(imagesIDs[i]);
        }
        dynamic res =
            await APIServices.search(selectedImagesID, cocoExplorerData);

        print("search response is $res");
        if (res is ErrorResponse) {
          ShowMessage.inDialog(res.errorDescription??"", true);
          stopLoader();
          isLoadMoreRunning = false;
          print("Error Response is ${res.errorDescription}");
        } else {
          print("DATA IS");
          print(cocoExplorerData.imagesByID?.length);
          print(cocoExplorerData.imagesSegment?.length);
          print(cocoExplorerData.imagesCaptions?.length);
          isLoadMoreRunning = false;
        }
      }
    }

    notifyListeners();
  }

  /*========================= Favorite Events =================================*/

  List<ImageObjectModel> favoriteImageObjects = [];

  Future<void> tabFavIcon(ImageObjectModel imageObject) async {
    bool checkFav = checkFavImageObject(imageObject);
    if (checkFav) {
      await removeFav(imageObject);
    } else {
      await addFav(imageObject);
    }

    notifyListeners();
  }

  Future<void> addFav(ImageObjectModel imageObject) async {
    ShowMessage.snackBar(
        "Added to Favorite", "This Event has been added to favorite", false);

    favoriteImageObjects.add(imageObject);
    await insertFavoriteToHive();
  }

  Future<void> removeFav(ImageObjectModel imageObject) async {
    ShowMessage.snackBar("Removed from Favorite",
        "This Event has been removed from favorite", false);

    favoriteImageObjects.removeWhere(
        (element) => element.imageData.id == imageObject.imageData.id);
    await insertFavoriteToHive();
  }

  Future<void> insertFavoriteToHive() async {
    await HiveServices.insertString(
        HiveServices.favoriteList, (json.encode(favoriteImageObjects)));
    await getFavoriteList();
  }

  bool checkFavImageObject(ImageObjectModel imageObject) {
    bool isFav = false;

    for (ImageObjectModel favImageObject in favoriteImageObjects) {
      if (imageObject.imageData.id == favImageObject.imageData.id) {
        isFav = true;
        break;
      }
    }
    return isFav;
  }

  Future<void> getFavoriteList() async {
    String? favHiveData =
        await HiveServices.getString(HiveServices.favoriteList);
    if (favHiveData != null) {
      print("Get hive data");
      print(json.decode(favHiveData).toString());
      favoriteImageObjects = List<ImageObjectModel>.from(json
          .decode(favHiveData)
          .map((model) => ImageObjectModel.fromJson(model)));

      print(
          "length of Favorite Events items from hive is ${favoriteImageObjects.length}");
    }
  }

/*========================== Categories =====================================*/

  List<Categories> categoryList = [];

  Categories? selectedCategory;

  Future<void> fetchAllCategories() async {
    categoryList = catToId.entries
        .map((entry) => Categories(
            image:
                'https://cocodataset.org/images/cocoicons/${entry.value}.jpg',
            id: entry.value,
            title: entry.key,
            createdAt: DateTime.now()))
        .toList();

    if (kDebugMode) {
      print("length of all Categories are ${categoryList.length}");
    }
  }

  /*============================SET TAGS===============================*/

  /*  Set tags*/

  List<Categories> selectedCategories = [];

  void removeTAgs(Categories tag) {
    bool isExist = checkTag(tag);
    if (isExist) {
      selectedCategories.remove(tag);
      ShowMessage.toast("Tag Removed");
      print("tag length is ${selectedCategories.length}");
    }
    notifyListeners();
  }

  void addTAgs(Categories tag) {
    bool isExist = checkTag(tag);
    if (isExist == false) {
      selectedCategories.add(tag);
      ShowMessage.toast("Tag added");
      print("tag length is ${selectedCategories.length}");
    }

    notifyListeners();
  }

  bool checkTag(Categories tag) {
    bool isTag = false;

    for (Categories cat in selectedCategories) {
      if (cat.id == tag.id) {
        isTag = true;
        break;
      }
    }
    return isTag;
  }
}
