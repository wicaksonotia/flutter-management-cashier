import 'package:financial_apps/pages/home/calendar_weekly_view.dart';
import 'package:financial_apps/pages/home/header.dart';
import 'package:financial_apps/pages/home/planning_ahead.dart';
import 'package:financial_apps/pages/home/vertical_list.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        children: const [
          Header(),
          Gap(15),
          PlanningAhead(),
          Gap(15),
          CalendarWeeklyView(),
          VerticalList()
        ],
      ),
    ]));
  }
}
