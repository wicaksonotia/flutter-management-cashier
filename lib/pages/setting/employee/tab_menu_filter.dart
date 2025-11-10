import 'dart:ui';
import 'package:flutter/material.dart';

class LokasiFilterPage extends StatefulWidget {
  const LokasiFilterPage({super.key});

  @override
  State<LokasiFilterPage> createState() => _LokasiFilterPageState();
}

class _LokasiFilterPageState extends State<LokasiFilterPage>
    with SingleTickerProviderStateMixin {
  bool isDropdownOpen = false;
  String selectedLokasi = "Lokasi";
  List<String> lokasiList = [
    "Jabodetabek",
    "Jawa Timur",
    "DI Yogyakarta",
    "Sulawesi Selatan",
    "Kalimantan Selatan",
    "DKI Jakarta",
    "Jawa Barat",
    "Jawa Tengah",
    "Riau",
    "Banten",
  ];

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    _scaleAnimation = Tween<double>(begin: 0.98, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  void toggleDropdown() {
    setState(() {
      isDropdownOpen = !isDropdownOpen;
      if (isDropdownOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            /// --- HEADER & LIST ---
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleDropdown,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange, width: 1),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Text(
                                selectedLokasi,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              Icon(
                                isDropdownOpen
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                /// --- LIST SIMULASI DI BAWAH ---
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (_, i) => ListTile(
                      title: Text("Pegawai ${i + 1}"),
                      subtitle: const Text("Username / Phone"),
                      leading: const CircleAvatar(
                        backgroundImage:
                            NetworkImage("https://i.pravatar.cc/100?img=1"),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// --- BACKDROP BLUR ---
            if (isDropdownOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: toggleDropdown,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
              ),

            /// --- FLOATING DROPDOWN (SLIDE UP FROM BELOW BUTTON) ---
            Positioned(
              top: 90, // muncul dari bawah tombol
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// --- PILIHAN LOKASI ---
                            Container(
                              constraints: const BoxConstraints(maxHeight: 320),
                              padding: const EdgeInsets.all(12),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: lokasiList.map((lokasi) {
                                    bool isSelected = lokasi == selectedLokasi;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedLokasi = lokasi;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.orange.shade100
                                              : Colors.white,
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.orange
                                                : Colors.grey.shade400,
                                            width: 1.2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          lokasi,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.orange.shade800
                                                : Colors.black87,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),

                            /// --- FOOTER BUTTON ---
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedLokasi = "Lokasi";
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.orange),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Atur Ulang",
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: toggleDropdown,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        "Pakai",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
