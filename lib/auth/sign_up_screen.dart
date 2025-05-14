// ignore_for_file: use_build_context_synchronously

import 'package:carl/api/api_service.dart';
import 'package:carl/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: Colors.red, width: 1.5),
  );

  final OutlineInputBorder _normalBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: Colors.transparent),
  );
  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Passwords do not match!",
              style: TextStyle(fontSize: 16.sp),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Creating account...",
              style: TextStyle(fontSize: 16.sp),
            ),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 10),
          ),
        );

        // Make API call
        var response = await ApiService().signUpviaEmailPassword(
          context,
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );

        // Clear loading indicator
        ScaffoldMessenger.of(context).clearSnackBars();

        print('Response in validateAndSubmit: $response');

        // Handle API response
        if (response.containsKey('jwt') && response.containsKey('user')) {
          // Success case
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Account created successfully!",
                style: TextStyle(fontSize: 16.sp),
              ),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to LoginScreen after success
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          });
        } else if (response.containsKey('error')) {
          // Error cases
          final error = response['error'];
          String errorMessage =
              error['message'] ?? "An error occurred during signup";

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: TextStyle(fontSize: 16.sp),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          // Unexpected response format
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Unexpected response format from server: $response",
                style: TextStyle(fontSize: 16.sp),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Clear loading indicator
        ScaffoldMessenger.of(context).clearSnackBars();

        // Handle unexpected exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "An unexpected error occurred: $e",
              style: TextStyle(fontSize: 16.sp),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _selectedLanguage;
  Widget _buildLanguageDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedLanguage,
      items: ['French', 'English', 'Franco'].map((language) {
        return DropdownMenuItem(
          value: language,
          child: Text(language, style: TextStyle(fontSize: 16.sp)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedLanguage = value;
        });
      },
      validator: (value) => value == null ? 'Please select a language' : null,
      style: TextStyle(fontSize: 16.sp, color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Select Language',
        hintStyle: TextStyle(fontSize: 16.sp),
        contentPadding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 5.w),
        filled: true,
        fillColor: Colors.white,
        border: _normalBorder,
        enabledBorder: _normalBorder,
        focusedBorder: _normalBorder,
        errorBorder: _errorBorder,
        focusedErrorBorder: _errorBorder,
      ),
      dropdownColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 2.h),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Kalleís",
                    style: GoogleFonts.ptSerif(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 2.5.h),
                Text(
                  'Create Account',
                  style: GoogleFonts.ptSans(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff1F1F1F),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Provide Your Info',
                  style: TextStyle(fontSize: 15.sp, color: Color(0xff707070)),
                ),
                SizedBox(height: 3.h),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'Full name',
                  validator: (value) =>
                      value!.isEmpty ? "Full name required" : null,
                ),
                SizedBox(height: 2.h),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Email required";
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),
                _buildLanguageDropdown(),
                SizedBox(height: 2.h),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20.sp,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Password required" : null,
                ),
                SizedBox(height: 2.h),
                _buildTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20.sp,
                    ),
                    onPressed: () => setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Confirm your password" : null,
                ),
                SizedBox(height: 2.h),
                Text.rich(
                  TextSpan(
                    text: 'By signing up, you agree to our ',
                    style: TextStyle(
                        color: Color(0xff404B52),
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp),
                    children: [
                      TextSpan(
                        text: 'Terms of use',
                        style: TextStyle(
                            color: Color(0xff2D5591),
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: TextStyle(
                            color: Color(0xff404B52),
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                            color: Color(0xff2D5591),
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.sp),
                ),
                SizedBox(height: 3.h),
                ElevatedButton(
                  onPressed: _validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontSize: 17.sp, color: Colors.white),
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(fontSize: 15.sp)),
                    SizedBox(width: 1.w),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ), (route) => false);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16.sp),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 5.w),
        filled: true,
        fillColor: Colors.white,
        border: _normalBorder,
        enabledBorder: _normalBorder,
        focusedBorder: _normalBorder,
        errorBorder: _errorBorder,
        focusedErrorBorder: _errorBorder,
      ),
    );
  }
}
