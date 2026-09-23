import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class BackgroundForm extends StatelessWidget {
  const BackgroundForm({
    super.key,
    required this.headerTitle,
    required this.container,
  });

  final String headerTitle;
  final Widget container;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: [
            // ============================================================
            // HEADER BACKGROUND
            // ============================================================
            Container(
              height: 300,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [
                    MyColors.primary,
                    MyColors.primaryDark,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),

            // ============================================================
            // DECORATION
            // ============================================================
            Positioned(
              top: -100,
              left: -50,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white.withAlpha(
                    (0.2 * 255).toInt(),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 50,
              right: -60,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white.withAlpha(
                    (0.2 * 255).toInt(),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 70,
              right: -40,
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.primary,
                ),
              ),
            ),

            // ============================================================
            // TITLE
            // ============================================================
            Positioned(
              top: 60,
              left: 80,
              right: 20,
              child: Text(
                headerTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            // ============================================================
            // CONTENT
            // ============================================================
            container,

            // ============================================================
            // BACK BUTTON
            // ============================================================
            Positioned(
              top: 50,
              left: 20,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
