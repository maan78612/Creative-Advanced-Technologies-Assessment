import 'dart:async';
import 'dart:convert';

import 'package:assessment/constants/categoryConstantData.dart';
import 'package:assessment/hive/hive_services.dart';
import 'package:assessment/model_classes/categories_model.dart';
import 'package:assessment/model_classes/data_model.dart';
import 'package:assessment/model_classes/error_response.dart';
import 'package:assessment/model_classes/event_model.dart';
import 'package:assessment/services/api_services.dart';
import 'package:assessment/utilities/show_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  EventModelClass? events;
  bool isLoading = false;

  void startLoader() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoader() {
    isLoading = false;
    notifyListeners();
  }

  /* GET Category DATA*/

/*     API Call For Data */
  COCOExplorerData cocoExplorerData = COCOExplorerData();

  Future<void> searchByID() async {
    List<int> catIDs = [];
    startLoader();
    selectedCategories.forEach((element) {
      catIDs.add(element.id);
    });

    dynamic res = await APIServices.search(catIDs);
    if (res is ErrorResponse) {
      print("Error Response is ${res.errorDescription}");
    } else {
      print(res);
      cocoExplorerData = res;
      print("DATA 2 IS");
      print(cocoExplorerData.imagesByID?.length);
      print(cocoExplorerData.imagesSegment?.length);
      print(cocoExplorerData.imagesCaptions?.length);
    }
    stopLoader();

    notifyListeners();
  }

  /*========================= Favorite Events =================================*/

  List<Events> favoriteEvents = [];

  Future<void> tabFavIcon(Events event) async {
    bool checkFav = checkFavEvent(event);
    if (checkFav) {
      await removeFav(event);
    } else {
      await addFav(event);
    }

    notifyListeners();
  }

  Future<void> addFav(Events event) async {
    ShowMessage.snackBar(
        "Added to Favorite", "This Event has been added to favorite", false);

    favoriteEvents.add(event);
    await insertFavoriteToHive();
  }

  Future<void> removeFav(Events event) async {
    ShowMessage.snackBar("Removed from Favorite",
        "This Event has been removed from favorite", false);

    favoriteEvents.removeWhere((element) => element.id == event.id);
    await insertFavoriteToHive();
  }

  Future<void> insertFavoriteToHive() async {
    await HiveServices.insertString(
        HiveServices.favoriteList, (json.encode(favoriteEvents)));
    await getFavoriteList();
  }

  bool checkFavEvent(Events eventToBeChecked) {
    bool isFav = false;

    for (Events event in favoriteEvents) {
      if (eventToBeChecked.id == event.id) {
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
      favoriteEvents = List<Events>.from(
          json.decode(favHiveData).map((model) => Events.fromJson(model)));

      print(
          "length of Favorite Events items from hive is ${favoriteEvents.length}");
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
    selectedCategories.remove(tag);
    ShowMessage.toast("Tag Removed");
    print("tag length is ${selectedCategories.length}");
    notifyListeners();
  }

  void addTAgs(Categories tag) {
    selectedCategories.add(tag);
    ShowMessage.toast("Tag added");
    print("tag length is ${selectedCategories.length}");
    notifyListeners();
  }
}
