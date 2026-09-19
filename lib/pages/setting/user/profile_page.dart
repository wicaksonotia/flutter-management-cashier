import 'package:cashier_management/controllers/login_controller.dart';
import 'package:cashier_management/pages/setting/user/widget/profile_header_card.dart';
import 'package:cashier_management/pages/setting/user/widget/profile_section.dart';
import 'package:cashier_management/pages/setting/user/widget/profile_text_field.dart';
import 'package:cashier_management/utils/background_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final LoginController _loginController;

  @override
  void initState() {
    super.initState();

    _loginController = Get.find<LoginController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loginController.checkProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: BackgroundForm(
          headerTitle: 'Profile',
          container: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth =
            constraints.maxWidth > 800 ? 760 : double.infinity;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            110,
            20,
            32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileHeaderCard(
                    nameController: _loginController.namaController,
                  ),
                  const SizedBox(height: 18),
                  ProfileSection(
                    title: 'Personal Information',
                    subtitle: 'Manage your personal information',
                    icon: Icons.person_outline_rounded,
                    child: Column(
                      children: [
                        ProfileTextField(
                          controller: _loginController.namaController,
                          label: 'Name',
                          hint: 'Enter your name',
                          icon: Icons.person_outline_rounded,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        ProfileTextField(
                          controller: _loginController.noTelponController,
                          label: 'Phone Number',
                          hint: 'Enter your phone number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  ProfileSection(
                    title: 'Address',
                    subtitle: 'Update your current address',
                    icon: Icons.location_on_outlined,
                    child: ProfileTextField(
                      controller: _loginController.alamatController,
                      label: 'Address',
                      hint: 'Enter your address',
                      icon: Icons.location_on_outlined,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSaveButton(),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Make sure your information is correct',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          _loginController.updateProfileProcess();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_rounded,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
