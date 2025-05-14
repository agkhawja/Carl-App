// ignore_for_file: use_build_context_synchronously

import 'package:carl/api/api_service.dart';
import 'package:carl/auth/forgot_password.dart';
import 'package:carl/onboarding_screens/onboarding_screen_1.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  final OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: Colors.red, width: 1.5),
  );

  final OutlineInputBorder _normalBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: Colors.transparent),
  );

  void _validateAndLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Logging in...",
            style: TextStyle(fontSize: 16.sp),
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 10),
        ),
      );

      try {
        // Make API call
        var response = await ApiService().signInviaEmailPassword(
          context,
          email,
          password,
        );

        // Clear loading indicator
        ScaffoldMessenger.of(context).clearSnackBars();

        print('Login Response in validateAndLogin: $response');

        // Handle API response
        if (response.containsKey('jwt') && response.containsKey('user')) {
          // Save data to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt', response['jwt']);
          await prefs.setString(
              'user',
              json.encode(
                  response['user'])); // Convert user object to JSON string

          // Success case
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Login successful",
                style: TextStyle(fontSize: 16.sp),
              ),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to home screen or dashboard after successful login
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => OnboardingScreen1(),
              ),
              (route) => false,
            );
          });
        } else if (response.containsKey('error')) {
          // Error cases
          final error = response['error'];
          String errorMessage =
              error['message'] ?? "An error occurred during login";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 5.h),
                Center(
                  child: Text(
                    "Kalleís",
                    style: GoogleFonts.ptSerif(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "Login",
                  style: TextStyle(
                    color: const Color(0xFF2D5591),
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "Access Your Account",
                  style:
                      TextStyle(color: Colors.grey.shade700, fontSize: 15.sp),
                ),
                SizedBox(height: 4.h),

                // Email
                Text(
                  "Email",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email required';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 16.sp),
                  decoration: InputDecoration(
                    hintText: 'junaidakram@gmail.com',
                    hintStyle: TextStyle(fontSize: 15.sp, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: _normalBorder,
                    enabledBorder: _normalBorder,
                    focusedBorder: _normalBorder,
                    errorBorder: _errorBorder,
                    focusedErrorBorder: _errorBorder,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
                  ),
                ),
                SizedBox(height: 2.h),

                // Password
                Text(
                  "Password",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 16.sp),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '********',
                    hintStyle: TextStyle(fontSize: 15.sp),
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
                    border: _normalBorder,
                    enabledBorder: _normalBorder,
                    focusedBorder: _normalBorder,
                    errorBorder: _errorBorder,
                    focusedErrorBorder: _errorBorder,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
                  ),
                ),

                SizedBox(height: 4.h),

                // Log In Button
                SizedBox(
                  width: 100.w,
                  height: 6.5.h,
                  child: ElevatedButton(
                    onPressed: _validateAndLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.5.h),

                // Forgot Password
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ForgotPasswordScreen();
                        },
                      ));
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
