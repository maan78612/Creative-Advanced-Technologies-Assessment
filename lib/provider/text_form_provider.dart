import 'package:assessment/provider/app_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TextFormProvider extends ChangeNotifier {
  TextEditingController textEditingController = TextEditingController();

  String searchField = "";

  void search() {
    searchField = textEditingController.text.toLowerCase();
    if (kDebugMode) {
      print("search value is $searchField");
    }
    notifyListeners();
  }



  void clearSearchText() {
    FocusManager.instance.primaryFocus?.unfocus();
    searchField = "";
    textEditingController.clear();

    notifyListeners();
  }
}
