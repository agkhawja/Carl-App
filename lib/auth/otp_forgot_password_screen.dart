import 'package:carl/auth/password_reset_screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpForgotPasswordScreen extends StatefulWidget {
  const OtpForgotPasswordScreen({super.key});

  @override
  State<OtpForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<OtpForgotPasswordScreen> {
  String _otpCode = '';
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _otpController = TextEditingController();

  late final PinTheme defaultPinTheme;
  late final PinTheme focusedPinTheme;
  late final PinTheme submittedPinTheme;

  @override
  void initState() {
    super.initState();

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
  }

  void _onCompleted(String pin) {
    setState(() {
      _otpCode = pin;
    });
  }

  void _onSubmit() {
    if (_otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid 6-digit code."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP Verified"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return PasswordResetScreen();
        },
      ));
      // You can trigger API call or navigation here
    }
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
              style: TextStyle(
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
                  style: TextStyle(
                    color: const Color(0xff2D5591),
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  "Enter a 6 digit code we have sent to your email.",
                  style: TextStyle(
                    fontSize: 15.sp,
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
                SizedBox(height: 2.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Resend Code Clicked"),
                          backgroundColor: Colors.black54,
                        ),
                      );
                    },
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _onSubmit,
                    icon: Icon(Icons.arrow_forward,
                        color: Colors.white, size: 20.sp),
                    label: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 1.4.h),
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
