import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';

class SelectTableListPage<T> extends StatelessWidget {
  final String title;
  final RxBool isLoading;
  final List<T> items;
  final String Function(T) titleBuilder;
  final String Function(T)? subtitleBuilder;
  final bool Function(T) isSelected;
  final Future<void> Function(T) onItemTap;

  const SelectTableListPage({
    super.key,
    required this.title,
    required this.isLoading,
    required this.items,
    required this.titleBuilder,
    this.subtitleBuilder,
    required this.isSelected,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: MySizes.fontSizeHeader,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (isLoading.value) {
          return ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.white,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          separatorBuilder: (_, __) => Divider(
            thickness: .5,
            color: Colors.grey.shade300,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              onTap: () async {
                await onItemTap(item);
              },
              title: Text(
                titleBuilder(item),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: (subtitleBuilder != null &&
                      subtitleBuilder!(item).trim().isNotEmpty)
                  ? Text(
                      subtitleBuilder!(item),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: MySizes.fontSizeSm,
                      ),
                    )
                  : null,
              trailing: Icon(
                Icons.check_circle,
                color:
                    isSelected(item) ? MyColors.primary : Colors.grey.shade300,
              ),
            );
          },
        );
      }),
    );
  }
}
