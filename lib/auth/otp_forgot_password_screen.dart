// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'package:carl/api/api_service.dart';
import 'package:carl/auth/password_reset_screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpForgotPasswordScreen extends StatefulWidget {
  final String email;
  const OtpForgotPasswordScreen({super.key, required this.email});

  @override
  State<OtpForgotPasswordScreen> createState() =>
      _OtpForgotPasswordScreenState();
}

class _OtpForgotPasswordScreenState extends State<OtpForgotPasswordScreen> {
  String _otpCode = '';
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false; // Track loading state
  Timer? _timer; // Timer for countdown
  int _secondsRemaining = 300; // 5 minutes in seconds
  bool _isResendDisabled = true; // Disable resend during countdown

  late final PinTheme defaultPinTheme;
  late final PinTheme focusedPinTheme;
  late final PinTheme submittedPinTheme;

  @override
  void initState() {
    super.initState();

    // Initialize PinTheme
    defaultPinTheme = PinTheme(
      width: 12.w,
      height: 6.5.h,
      textStyle: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
    );

    focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green, width: 2),
      ),
    );

    submittedPinTheme = focusedPinTheme.copyWith(
      decoration: focusedPinTheme.decoration!.copyWith(
        color: Colors.green.withOpacity(0.1),
      ),
    );

    // Start the 5-minute countdown timer
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 300; // Reset to 5 minutes
    _isResendDisabled = true;
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        setState(() {
          _isResendDisabled = false;
          timer.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  String _formatTimer(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

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

  void _onCompleted(String pin) {
    setState(() {
      _otpCode = pin;
    });
  }

  Future<void> _onSubmit() async {
    if (_otpCode.length != 6) {
      _showSnackBar("Please enter a valid 6-digit code.");
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response =
          await ApiService().emailVerifyOtp(context, widget.email, _otpCode);

      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      if (response.containsKey('error')) {
        // API or network error
        final error = response['error'];
        _showSnackBar(
          error['message'] ?? 'Failed to verify OTP. Please try again.',
        );
      } else {
        // Success case
        _showSnackBar(
          "OTP verified successfully!",
          backgroundColor: Colors.green,
        );

        // Navigate to PasswordResetScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordResetScreen(
              email: widget.email,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar("Unexpected error: $e");
    }
  }

  Future<void> _onResend() async {
    if (_isLoading || _isResendDisabled) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService().emailSendOtp(context, widget.email);

      setState(() {
        _isLoading = false;
      });

      if (response.containsKey('error')) {
        final error = response['error'];
        _showSnackBar(
          error['message'] ?? 'Failed to resend OTP. Please try again.',
        );
      } else {
        _otpController.clear();
        setState(() {
          _otpCode = '';
        });
        _startTimer(); // Reset and restart the timer
        _showSnackBar(
          "New OTP sent to ${widget.email}",
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar("Unexpected error: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer to prevent memory leaks
    _focusNode.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return Scaffold(
          backgroundColor: const Color(0xFFEBEBEB),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Colors.black),
            title: Text(
              "Forget Password",
              style: GoogleFonts.roboto(
                fontSize: 19.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Code",
                  style: GoogleFonts.roboto(
                    color: const Color(0xff2D5591),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  "Enter the 6-digit code sent to ${widget.email}.",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4.h),
                Pinput(
                  controller: _otpController,
                  focusNode: _focusNode,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  showCursor: true,
                  onCompleted: _onCompleted,
                  onChanged: (value) {
                    setState(() => _otpCode = value);
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 3.h),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Time remaining: ${_isResendDisabled ? _formatTimer(_secondsRemaining) : 'Expired'}",
                    style: GoogleFonts.roboto(
                      fontSize: 17.sp,
                      color: _isResendDisabled ? Color(0xff2D5591) : Colors.red,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed:
                        _isLoading || _isResendDisabled ? null : _onResend,
                    child: Text(
                      "Resend",
                      style: GoogleFonts.roboto(
                        fontSize: 17.sp,
                        color: _isLoading || _isResendDisabled
                            ? Colors.grey[400]
                            : Color(0xff707070),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 25.w,
                    height: 4.5.h,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onSubmit,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          // vertical: 1.4.h,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Next",
                                  style: GoogleFonts.roboto(
                                    fontSize: 17.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(Icons.arrow_forward,
                                    color: Colors.white, size: 18.sp),
                              ],
                            ),
                      // icon:
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
