import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/currency.dart';
import 'package:flutter/material.dart';

List upcomingTransactions = [
  [
    const Icon(
      Icons.diamond,
      color: Colors.red,
      size: 40,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 10, 16),
    "Luxury"
  ],
  [
    const Icon(
      Icons.logo_dev,
      color: Colors.blue,
      size: 40,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 10, 17),
    "Software"
  ],
  [
    const Icon(
      Icons.polymer,
      color: Colors.blue,
      size: 40,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 10, 18),
    "Tooling"
  ],
  [
    const Icon(
      Icons.anchor,
      size: 40,
      color: Colors.green,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 10, 22),
    "Vacation/Travel"
  ],
  [
    const Icon(
      Icons.music_note,
      color: Colors.purple,
      size: 40,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 10, 23),
    "Education"
  ],
  [
    const Icon(
      Icons.face,
      color: Colors.purple,
      size: 40,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 10, 24),
    "Makeup"
  ],
  [
    const Icon(
      Icons.music_note,
      color: Colors.purple,
      size: 40,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 10, 23),
    "Education"
  ],
];

List pastTransactions = [
  [
    const Icon(
      Icons.download,
      color: MyColors.green,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 9, 16),
    "Gaji"
  ],
  [
    const Icon(
      Icons.upload,
      color: MyColors.red,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 9, 16),
    "Gaji"
  ],
  [
    const Icon(
      Icons.download,
      color: MyColors.green,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 9, 16),
    "Gaji"
  ],
  [
    const Icon(
      Icons.download,
      color: MyColors.green,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 9, 16),
    "Gaji"
  ],
  [
    const Icon(
      Icons.upload,
      color: MyColors.red,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 9, 16),
    "Gaji"
  ],
  [
    const Icon(
      Icons.download,
      color: MyColors.green,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 9, 16),
    "Gaji"
  ],
  [
    const Icon(
      Icons.download,
      color: MyColors.green,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 9, 16),
    "Gaji"
  ],
  [
    const Icon(
      Icons.upload,
      color: MyColors.red,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 9, 16),
    "Gaji"
  ],
  [
    const Icon(
      Icons.download,
      color: MyColors.green,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 9, 16),
    "Gaji"
  ],
  [
    const Icon(
      Icons.download,
      color: MyColors.green,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 9, 16),
    "Gaji"
  ],
  [
    const Icon(
      Icons.upload,
      color: MyColors.red,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 9, 16),
    "Gaji"
  ],
  [
    const Icon(
      Icons.download,
      color: MyColors.green,
    ),
    CurrencyFormat.convertToIdr(10000, 0),
    DateTime(2022, 9, 16),
    "Gaji"
  ],
];
List<Map<String, String>> tipeKategori = [
  {"id": "1", "nama": "PEMASUKAN"},
  {"id": "2", "nama": "PENGELUARAN"},
];
List<String> dropDownKategori = ["PEMASUKAN", "PENGELUARAN"];
List<String> dropDownKategoriSearch = ["All", "PEMASUKAN", "PENGELUARAN"];
List<String> dropDownTransactionCategories = ["makan", "minum", "mandi"];
