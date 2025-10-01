import 'package:flutter/material.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAccountTile(
                name: "Darrell Steward",
                email: "darrellsteward@gmail.com",
                avatarUrl: "https://i.pravatar.cc/100?img=1",
                isActive: true,
                isMain: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.settings, size: 18),
                    label: const Text("Manage Account"),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: const Text("Sign out"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildAccountTile(
                name: "Savannah Nguyen",
                email: "savannah.e.t.nguy@gmail.com",
                avatarUrl: "https://i.pravatar.cc/100?img=2",
              ),
              _buildAccountTile(
                name: "Cody Fisher",
                email: "codyfisher.y@gmail.com",
                avatarUrl: "https://i.pravatar.cc/100?img=3",
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.add, color: Colors.white),
                ),
                title: const Text("Add account"),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTile({
    required String name,
    required String email,
    required String avatarUrl,
    bool isActive = false,
    bool isMain = false,
  }) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
          if (isActive)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(email),
      onTap: () {},
    );
  }
}
