import 'package:cashier_management/controllers/login_controller.dart';
import 'package:cashier_management/utils/background_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Container(
          color: Colors.grey.shade50, // Set your desired background color here
          child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: BackgroundForm(
                headerTitle: 'Change Password',
                container: containerPage(),
              )),
        ),
      ),
    );
  }

  Container containerPage() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 120, 20, 0),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Change Password",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          const Text(
            "Update your password below.",
          ),
          const Gap(25),
          TextField(
            controller: _loginController.currentController,
            decoration: InputDecoration(
              labelText: "Current Password *",
              border: const OutlineInputBorder(),
              suffixIcon: InkWell(
                onTap: () {
                  _loginController.showCurrentPassword();
                },
                child: Icon(
                  _loginController.isPasswordCurrentVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: const Color(0xFF5C5F65),
                ),
              ),
            ),
            obscureText: !_loginController.isPasswordCurrentVisible.value,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _loginController.newController,
            decoration: InputDecoration(
              labelText: "New Password *",
              border: const OutlineInputBorder(),
              suffixIcon: InkWell(
                onTap: () {
                  _loginController.showNewPassword();
                },
                child: Icon(
                  _loginController.isPasswordNewVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: const Color(0xFF5C5F65),
                ),
              ),
            ),
            obscureText: !_loginController.isPasswordNewVisible.value,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _loginController.confirmController,
            decoration: InputDecoration(
              labelText: "Confirm Password *",
              border: const OutlineInputBorder(),
              suffixIcon: InkWell(
                onTap: () {
                  _loginController.showConfirmPassword();
                },
                child: Icon(
                  _loginController.isPasswordConfirmVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: const Color(0xFF5C5F65),
                ),
              ),
            ),
            obscureText: !_loginController.isPasswordConfirmVisible.value,
          ),
          const Gap(20),
          const Text(
            "After changing your password, you will be logged out 👍",
            textAlign: TextAlign.center,
          ),
          const Gap(50),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _loginController.changePasswordProcess();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: MySizes.fontSizeMd,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
