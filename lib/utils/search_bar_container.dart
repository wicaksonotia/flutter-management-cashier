import 'package:financial_apps/controllers/search_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarContainer extends StatelessWidget {
  SearchBarContainer({super.key});
  final SearchBarController searchBarController =
      Get.find<SearchBarController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 50, // Set the desired height here
        child: TextField(
          cursorColor: Colors.black54,
          controller: searchBarController.searchTextFieldController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black26),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black26),
            ),
            hintText: "Search category",
            hintStyle: const TextStyle(color: Colors.black26),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: searchBarController.isEmptyValue.value
                ? null
                : IconButton(
                    icon: const Icon(
                      Icons.clear,
                      size: 25,
                    ),
                    onPressed: () {
                      searchBarController.searchTextFieldController.clear();
                      searchBarController.isEmptyValue.value = true;
                    },
                  ),
          ),
          onChanged: (value) {
            value.isEmpty
                ? searchBarController.isEmptyValue.value = true
                : searchBarController.isEmptyValue.value = false;
          },
        ),
      ),
    );
  }
}
