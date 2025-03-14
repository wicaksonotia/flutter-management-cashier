import 'package:financial_apps/utils/currency.dart';
import 'package:financial_apps/utils/sizes.dart';
import 'package:flutter/cupertino.dart';

class Price extends StatelessWidget {
  const Price({
    super.key,
    required this.dataPrice,
    required this.warna,
  });

  final int dataPrice;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Rp ',
            style: TextStyle(
              color: warna,
              fontSize: MySizes.fontSizeMd,
            ),
          ),
          TextSpan(
            text: CurrencyFormat.convertToIdr(dataPrice, 0),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MySizes.fontSizeXl,
              color: warna,
            ),
          ),
        ],
      ),
    );
  }
}
