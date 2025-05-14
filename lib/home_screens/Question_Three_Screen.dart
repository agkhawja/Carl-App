// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print

import 'package:carl/home_screens/Question_Four_Screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionThreeScreen extends StatefulWidget {
  final String time;
  final String people;
  const QuestionThreeScreen(
      {super.key, required this.time, required this.people});
  @override
  _QuestionThreeScreenState createState() => _QuestionThreeScreenState();
}

class _QuestionThreeScreenState extends State<QuestionThreeScreen> {
  int selectedIndex = 0;

  final List<String> options = [
    "I want to manage healthy",
    "Never mind",
    "I want to make a little detour",
  ];

  void _onNextPressed() {
    String selectedValue = options[selectedIndex];
    print("Selected: $selectedValue");
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return QuestionFourScreen(
            time: widget.time, people: widget.people, food: selectedValue);
      },
    ));
    // You can also navigate or pass value to another screen here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 100.h,
              color: Color(0xFFEBEBEB),
            ),
            Container(
                height: 30.h,
                decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)))),
            Padding(
              padding: EdgeInsets.all(15.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, size: 18.sp)),
                  SizedBox(height: 2.h),
                  Text("How healthy do you want your meal to be?",
                      style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  SizedBox(height: 0.h),
                  Center(
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Center(
                        child: Image.asset('assests/Healthy_Meal_Screen.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  ...List.generate(options.length, (index) {
                    bool isSelected = selectedIndex == index;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            children: [
                              if (isSelected)
                                Icon(Icons.check,
                                    color: Colors.white, size: 18.sp),
                              if (isSelected) SizedBox(width: 2.w),
                              Text(
                                options[index],
                                style: GoogleFonts.roboto(
                                  fontSize: 16.sp,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  Spacer(),
                  Center(
                    child: SizedBox(
                      width: 90.w,
                      height: 6.5.h,
                      child: ElevatedButton(
                        onPressed: _onNextPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: GoogleFonts.roboto(
                                fontSize: 17.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(Icons.arrow_forward,
                                color: Colors.white, size: 18.sp),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
