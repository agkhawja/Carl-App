// ignore_for_file: use_build_context_synchronously, unused_element

import 'package:carl/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool currentPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final response = await ApiService().changePasswordApi(
      context,
      currentPasswordController.text.trim(),
      newPasswordController.text.trim(),
      confirmPasswordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (response.containsKey('error')) {
      final error = response['error'];
      showSnackBar(error['message'] ?? 'Unknown error', isError: true);
    } else if (response.containsKey('user')) {
      showSuccessBottomSheet(); // ✅ call it here
    } else {
      showSnackBar('Unexpected error occurred', isError: true);
    }
  }

  void showSuccessBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          height: 70.h,
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, size: 22.sp),
                  )
                ],
              ),
              SizedBox(height: 20.h),
              Image.asset('assests/settings/tick_icon.png'),
              SizedBox(height: 3.h),
              Text(
                'Password changed successfully',
                style: GoogleFonts.roboto(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Change Password",
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              color: const Color(0xff0A0615),
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 2.h),
              passwordField(
                label: "Current Password",
                controller: currentPasswordController,
                isVisible: currentPasswordVisible,
                onToggleVisibility: () {
                  setState(
                      () => currentPasswordVisible = !currentPasswordVisible);
                },
              ),
              passwordField(
                label: "New Password",
                controller: newPasswordController,
                isVisible: newPasswordVisible,
                onToggleVisibility: () {
                  setState(() => newPasswordVisible = !newPasswordVisible);
                },
              ),
              passwordField(
                label: "Confirm New Password",
                controller: confirmPasswordController,
                isVisible: confirmPasswordVisible,
                onToggleVisibility: () {
                  setState(
                      () => confirmPasswordVisible = !confirmPasswordVisible);
                },
              ),
              const Spacer(),
              SizedBox(
                width: 100.w,
                height: 6.5.h,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleChangePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)
                      : Text("Change Password",
                          style: GoogleFonts.roboto(
                              fontSize: 17.sp, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget passwordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.roboto(color: const Color(0xff9299A3)),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: onToggleVisibility,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';

          if (label == "New Password" && value.length < 6) {
            return 'Password must be at least 6 characters';
          }

          if (label == "Confirm New Password" &&
              value != newPasswordController.text.trim()) {
            return 'Passwords do not match';
          }

          return null;
        },
      ),
    );
  }
}
