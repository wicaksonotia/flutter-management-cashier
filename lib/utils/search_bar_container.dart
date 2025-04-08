import 'package:financial_apps/controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarContainer extends StatelessWidget {
  SearchBarContainer({super.key});
  final CategoryController _categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 50,
        child: TextField(
          cursorColor: Colors.black54,
          controller: _categoryController.searchBarController,
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
            suffixIcon: _categoryController.isEmptyValueSearchBar.value
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _categoryController.searchBarController.clear();
                      _categoryController.isEmptyValueSearchBar.value = true;
                      _categoryController.processSearch('');
                    },
                  ),
          ),
          onChanged: (value) {
            _categoryController.searchBarController.text = value.toUpperCase();
            _categoryController.searchBarController.selection =
                TextSelection.fromPosition(
              TextPosition(
                  offset: _categoryController.searchBarController.text.length),
            );
            if (value.isNotEmpty) {
              _categoryController.isEmptyValueSearchBar.value = false;
            } else {
              _categoryController.isEmptyValueSearchBar.value = true;
            }
          },
          onSubmitted: (value) {
            _categoryController.processSearch(value);
          },
        ),
      ),
    );
  }
}
