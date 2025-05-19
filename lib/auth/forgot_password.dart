import 'package:carl/api/api_service.dart';
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
  bool _isLoading = false; // Track loading state

  final OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: Colors.red, width: 1.5),
  );

  final OutlineInputBorder _normalBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: Colors.transparent),
  );

  void _showSnackBar(String message, {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.roboto(fontSize: 16.sp),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleNext() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      // Validate email format
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        _showSnackBar("Invalid email format");
        return;
      }

      // Prevent multiple API calls
      if (_isLoading) return;

      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Call API
        final response = await ApiService().emailSendOtp(context, email);

        setState(() {
          _isLoading = false; // Hide loading indicator
        });

        // Handle API response
        if (response.containsKey('error')) {
          // API or network error
          final error = response['error'];
          _showSnackBar(
            error['message'] ?? 'An error occurred. Please try again.',
          );
        } else {
          // Success case
          final receivedEmail = response['received_email'] ?? email;
          final otpCode = response['code'] ?? '';
          _showSnackBar(
            "OTP sent to $receivedEmail",
            backgroundColor: Colors.green,
          );

          // Navigate to OTP screen, passing email and OTP (if needed)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpForgotPasswordScreen(
                email: email,
              ),
            ),
          );
        }
      } catch (e) {
        // Unexpected error
        setState(() {
          _isLoading = false;
        });
        _showSnackBar("Unexpected error: $e");
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assests/forgot_password.png', // Ensure path is correct
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          // Foreground content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Top bar + title
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 15.w),
                        Text(
                          "Forget Password",
                          style: GoogleFonts.roboto(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 47.h),
                    // Title
                    Center(
                      child: Text(
                        "Forget Password?",
                        style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    // Subtitle
                    Center(
                      child: Text(
                        "No worries, we’ll help you reset it in no time",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          color: const Color(0xffDCDCDC),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    // Email label
                    Text(
                      "Email",
                      style: GoogleFonts.roboto(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    // Email input
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                      style: GoogleFonts.roboto(fontSize: 16.sp),
                      decoration: InputDecoration(
                        errorStyle: GoogleFonts.roboto(
                          color: Colors.red,
                          fontSize: 17.sp,
                        ),
                        hintText: 'junaidakram@gmail.com',
                        hintStyle: GoogleFonts.roboto(
                          color: const Color(0xff404B52),
                          fontSize: 15.5.sp,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 1.8.h,
                        ),
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
                        onPressed: _isLoading
                            ? null
                            : _handleNext, // Disable button when loading
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 1.2.h,
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Next",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16.5.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  const Icon(Icons.arrow_forward,
                                      color: Colors.white),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
