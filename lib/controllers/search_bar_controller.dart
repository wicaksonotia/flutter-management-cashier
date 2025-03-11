import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarController extends GetxController {
  RxBool isEmptyValue = true.obs;
  final searchTextFieldController = TextEditingController();
}
