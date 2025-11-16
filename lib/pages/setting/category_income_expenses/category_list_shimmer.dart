import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryListShimmer extends StatelessWidget {
  const CategoryListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 8,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Colors.grey.shade300),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListTile(
            leading: Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            title: Container(
              height: 14,
              width: 120,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
