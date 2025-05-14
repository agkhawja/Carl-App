import 'package:carl/auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assests/Splash_Screens/splash_1.png',
      'text':
          'Welcome to Carl – AI-Powered Nutrition! Your smart companion for healthy eating and meal planning.',
    },
    {
      'image': 'assests/Splash_Screens/splash_2.png',
      'text':
          'Personalized Meal Planning  & AI-driven meal plans tailored to your dietary preferences and goals.',
    },
    {
      'image': 'assests/Splash_Screens/splash_3.png',
      'text':
          'Smart Grocery List  Automatically generate shopping lists based on your selected recipes and ingredients.',
    },
  ];

  void _onNextPressed() {
    if (_currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  void _onSkipPressed() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEBEBEB),
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                _onboardingData[_currentIndex]['image']!,
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
            // Foreground Content
            Padding(
              padding: EdgeInsets.all(15.sp),
              child: Column(
                children: [
                  // Top indicator bar
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(
                              horizontal: 1.w, vertical: 4.h),
                          height: 0.5.h,
                          width: _currentIndex == index ? 6.w : 6.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.h),
                            color: _currentIndex == index
                                ? const Color(0xff1F1F1F)
                                : const Color(0xffFFFFFF),
                          ),
                        );
                      }),
                    ),
                  ),
                  // PageView
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _onboardingData.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 45.h),
                              Text(
                                _onboardingData[index]['text']!,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.roboto(
                                  fontSize: 18.5.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Bottom Buttons with Dark Black Background
                  Container(
                    // height: 20.h, // 20% of screen height
                    // color: const Color(0xff1F1F1F), // Dark black color
                    // padding:
                    //     EdgeInsets.symmetric(vertical: 2.h, horizontal: 15.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _onSkipPressed,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Skip',
                                style: GoogleFonts.roboto(
                                  fontSize: 18.5.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                  // backgroundColor: Colors.white
                                ),
                              ),
                              // SizedBox(height: 0.2.h),
                              // SizedBox(
                              //   width: 10.w,
                              //   child: const Divider(
                              //     color: Colors.white,
                              //     thickness: 2,
                              //     height: 5,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _onNextPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xffFFFFFF), // White button for contrast
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.sp),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 0.8.h, horizontal: 4.w),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Next',
                                style: GoogleFonts.roboto(
                                  fontSize: 18.5.sp,
                                  color: const Color(
                                      0xff1F1F1F), // Black text for contrast
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Icon(
                                Icons.arrow_forward,
                                color: const Color(
                                    0xff1F1F1F), // Black icon for contrast
                                size: 17.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
