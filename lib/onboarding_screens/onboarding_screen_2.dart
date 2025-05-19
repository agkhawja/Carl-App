// ignore_for_file: use_super_parameters

import 'package:carl/home_screens/home_main_screen.dart';
import 'package:carl/onboarding_screens/gender_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assests/Personlized_Nutrition.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Column(
                children: [
                  // Flexible spacer to push content to bottom
                  const Spacer(flex: 3),
                  // Text Content
                  Center(
                    child: Text(
                      'Personalized Nutrition',
                      style: GoogleFonts.roboto(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h), // Minimal spacing for readability
                  Text(
                    'Your journey to healthier eating',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: const Color(0xffE7E7E7),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 2.h), // Minimal spacing
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      'We\'d like to know more about you to recommend recipes tailored to your nutrition goals and preferences.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 17.sp,
                        color: const Color(0xffE7E7E7),
                        height: 1.3,
                      ),
                    ),
                  ),
                  // Spacer to push buttons to bottom
                  SizedBox(height: 5.h),
                  // Buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Column(
                      children: [
                        // Get Started Button
                        Container(
                          width: double.infinity,
                          height: 6.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xff1F1F1F),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const GenderSelectionScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Get Started',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 2.h), // Minimal spacing between buttons
                        // Answer Later Button
                        Container(
                          width: double.infinity,
                          height: 6.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xff707070),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeMainScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Answer Later',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
