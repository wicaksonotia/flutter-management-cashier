import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selamat Datang,',
                style: TextStyle(
                  fontSize: MySizes.fontSizeSm,
                  color: Colors.black54,
                ),
              ),
              FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 28,
                      width: 120,
                      child: LinearProgressIndicator(),
                    );
                  }
                  final prefs = snapshot.data;
                  final kios = prefs?.getString('kios') ?? '';
                  return Text(
                    kios,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  );
                },
              ),
            ],
          ),
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(
                'assets/profileImage.webp'), // Replace with your asset path
          ),
        ],
      ),
    );
  }
}
