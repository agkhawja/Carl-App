import 'package:carl/auth/otp_forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: Colors.red, width: 1.5),
  );

  final OutlineInputBorder _normalBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: Colors.transparent),
  );

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Invalid email format", style: TextStyle(fontSize: 16.sp)),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Simulate a successful reset email trigger
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Reset link sent to $email",
              style: TextStyle(fontSize: 16.sp)),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return OtpForgotPasswordScreen();
        },
      ));
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
                SizedBox(height: 2.5.h),

                // Top bar + title
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "Forget Password",
                      style: GoogleFonts.ptSerif(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),

                SizedBox(height: 3.h),

                // Image
                Image.asset(
                  'assests/forgot_password.png', // Make sure this matches your asset path
                  height: 28.h,
                ),

                SizedBox(height: 3.h),

                // Title
                Center(
                  child: Text(
                    "Forget Password?",
                    style: TextStyle(
                      fontSize: 18.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),

                // Subtitle
                Center(
                  child: Text(
                    "No worries, we’ll help you reset it in no time",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),

                // Email label
                Text(
                  "Email",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 1.h),

                // Email input
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Email is required'
                      : null,
                  style: TextStyle(fontSize: 16.sp),
                  decoration: InputDecoration(
                    hintText: 'junaidakram@gmail.com',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15.sp),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
                    border: _normalBorder,
                    enabledBorder: _normalBorder,
                    focusedBorder: _normalBorder,
                    errorBorder: _errorBorder,
                    focusedErrorBorder: _errorBorder,
                  ),
                ),

                SizedBox(height: 5.h),

                // Next button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 1.2.h),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 16.5.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        const Icon(Icons.arrow_forward, color: Colors.white),
                      ],
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
