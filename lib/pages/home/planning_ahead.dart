import 'package:financial_apps/pages/transaction/transaction_page.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/currency.dart';
import 'package:financial_apps/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PlanningAhead extends StatelessWidget {
  const PlanningAhead({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Planning Ahead",
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => TransactionPage())));
                    },
                    child: Text(
                      CurrencyFormat.convertToIdr(2000000, 0),
                      style: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  )
                ],
              )
            ],
          ),
        ),
        const Gap(15),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: SizedBox(
            height: 120,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: upcomingTransactions.length,
                itemBuilder: (context, int index) {
                  return SizedBox(
                    height: 50,
                    width: 120,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              upcomingTransactions[index][0],
                              Text(
                                upcomingTransactions[index][1],
                                style: const TextStyle(
                                    color: MyColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "In ${upcomingTransactions[index][2].difference(DateTime.now()).inDays.toString()} days",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
