import 'package:carousel_slider/carousel_slider.dart';
import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/currency.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BranchSaldo extends StatelessWidget {
  const BranchSaldo({super.key});

  @override
  Widget build(BuildContext context) {
    final TotalPerTypeController totalPerTypeController =
        Get.find<TotalPerTypeController>();

    return Obx(() {
      if (totalPerTypeController.isLoading.value) {
        return SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(15),
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 16,
                        color: Colors.white,
                      ),
                      const Gap(10),
                      Container(
                        width: 120,
                        height: 24,
                        color: Colors.white,
                      ),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 60,
                                height: 14,
                                color: Colors.white,
                              ),
                              const Gap(8),
                              Container(
                                width: 60,
                                height: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 60,
                                height: 14,
                                color: Colors.white,
                              ),
                              const Gap(8),
                              Container(
                                width: 60,
                                height: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: totalPerTypeController.resultItem.length,
              itemBuilder: (context, index, realIdx) {
                return buildContainerSlider(index, totalPerTypeController);
              },
              options: CarouselOptions(
                reverse: true,
                initialPage: 0,
                height: 130,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  totalPerTypeController.indexSlider.value = index;
                },
              ),
            ),
            const Gap(10),
            Obx(() => buildIndicator(totalPerTypeController)),
          ],
        );
      }
    });
  }

  AnimatedSmoothIndicator buildIndicator(
      TotalPerTypeController totalPerTypeController) {
    return AnimatedSmoothIndicator(
      activeIndex: totalPerTypeController.indexSlider.value,
      count: totalPerTypeController.resultItem.length,
      effect: const ExpandingDotsEffect(
        dotHeight: 8,
        dotWidth: 8,
        activeDotColor: MyColors.primary,
        dotColor: MyColors.grey,
      ),
    );
  }

  Container buildContainerSlider(
      int index, TotalPerTypeController totalPerTypeController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: index.isOdd
              ? [MyColors.oddGradientPrimary, MyColors.oddGradientSecondary]
              : [MyColors.evenGradientPrimary, MyColors.evenGradientSecondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Saldo",
                    style: TextStyle(
                      fontSize: MySizes.fontSizeSm,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    CurrencyFormat.convertToIdr(
                      totalPerTypeController
                              .resultItem[index].details!.balance ??
                          0,
                      0,
                    ),
                    style: const TextStyle(
                      fontSize: MySizes.fontSizeXl,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                totalPerTypeController.resultItem[index].cabang ?? "",
                style: const TextStyle(
                  fontSize: MySizes.fontSizeMd,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const Gap(5),
                      const Text(
                        "Pemasukan",
                        style: TextStyle(
                          fontSize: MySizes.fontSizeSm,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    CurrencyFormat.convertToIdr(
                      totalPerTypeController
                              .resultItem[index].details!.income ??
                          0,
                      0,
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const Gap(5),
                      const Text(
                        "Pengeluaran",
                        style: TextStyle(
                          fontSize: MySizes.fontSizeSm,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    CurrencyFormat.convertToIdr(
                      totalPerTypeController
                              .resultItem[index].details!.expense ??
                          0,
                      0,
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
