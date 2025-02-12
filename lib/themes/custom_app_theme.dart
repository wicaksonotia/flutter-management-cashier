import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  /// Home
  static const TextStyle homeAppBar = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: MyColors.darkTextColor,
  );
  static const TextStyle homeProductName = TextStyle(
    color: MyColors.lightTextColor,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle homeProductModel = TextStyle(
      color: MyColors.lightTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 22);
  static const TextStyle homeProductPrice = TextStyle(
      color: MyColors.lightTextColor,
      fontWeight: FontWeight.w400,
      fontSize: 16);
  static const TextStyle homeMoreText = TextStyle(
      fontSize: 22, color: MyColors.darkTextColor, fontWeight: FontWeight.bold);
  static const TextStyle homeGridNewText = TextStyle(
    color: MyColors.lightTextColor,
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );
  static const TextStyle homeGridNameAndModel = TextStyle(
    color: MyColors.darkTextColor,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle homeGridPrice = TextStyle(
    color: MyColors.darkTextColor,
    fontWeight: FontWeight.bold,
  );

  /// Profile
  static const TextStyle profileAppBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: MyColors.darkTextColor,
  );
  static const TextStyle profileRepeatedListTileTitle = TextStyle(
      fontWeight: FontWeight.bold, color: MyColors.darkTextColor, fontSize: 18);
  static const TextStyle profileDevName =
      TextStyle(fontSize: 22, fontWeight: FontWeight.w800);
}
