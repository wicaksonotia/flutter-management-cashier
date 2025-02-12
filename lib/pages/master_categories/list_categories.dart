import 'package:financial_apps/controllers/category_controller.dart';
import 'package:financial_apps/pages/master_categories/select_box.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCategories extends StatelessWidget {
  ListCategories({super.key});
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => categoryController.isLoading.value
          ? Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chips(),
                    SelectBoxSearch(),
                    // const MultiSelectHome(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .8,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 5),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: categoryController.resultData.length,
                        itemBuilder: (context, int index) {
                          return Card(
                            color: Colors.white,
                            elevation: 3,
                            child: ListTile(
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: MyColors.primary,
                                    onPressed: () => categoryController
                                        .updateCategory(categoryController
                                            .resultData[index].id),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: MyColors.red,
                                    onPressed: () => categoryController
                                        .deleteCategory(categoryController
                                            .resultData[index].id),
                                  ),
                                ],
                              ),
                              leading:
                                  categoryController.resultData[index].type ==
                                          "Pemasukan"
                                      ? const Icon(
                                          Icons.download,
                                          color: MyColors.green,
                                        )
                                      : const Icon(
                                          Icons.upload,
                                          color: MyColors.red,
                                        ),
                              title: Text(
                                categoryController.resultData[index].name,
                                style: const TextStyle(color: MyColors.primary),
                              ),
                              // leading: categoryController[index][0],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final String label;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool selected;
  final Function(bool selected) onSelect;

  const CustomChip({
    Key? key,
    required this.label,
    this.color,
    this.width,
    this.height,
    this.margin,
    this.selected = false,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      duration: const Duration(milliseconds: 300),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: selected
            ? (color ?? Colors.green)
            : theme.unselectedWidgetColor.withOpacity(.12),
        borderRadius: BorderRadius.all(Radius.circular(selected ? 25 : 10)),
        border: Border.all(
          color: selected
              ? (color ?? Colors.green)
              : theme.colorScheme.onSurface.withOpacity(.38),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(selected ? 25 : 10)),
        onTap: () => onSelect(!selected),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              left: 9,
              right: 9,
              bottom: 7,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
