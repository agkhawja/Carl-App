// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, deprecated_member_use

import 'package:carl/home_screens/Question_Three_Screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionTwoScreen extends StatefulWidget {
  final String time;
  const QuestionTwoScreen({super.key, required this.time});
  @override
  _QuestionTwoScreenState createState() => _QuestionTwoScreenState();
}

class _QuestionTwoScreenState extends State<QuestionTwoScreen> {
  double no_of_people = 1;

  final List<String> options = [
    "I have all the time in the world",
    "No more than an hour",
    "Less than 30 minutes",
  ];

  void _onNextPressed() {
    double selectedValue = no_of_people;
    print("Selected People: $selectedValue");
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return QuestionThreeScreen(
          time: widget.time,
          people: selectedValue.toString(),
        );
      },
    ));
    // You can also navigate or pass value to another screen here
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    Text("How many people did you want to cook for?",
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
                          child: Image.asset(
                              'assests/No_of_People_Cooking_For.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Center(
                      child: Text(
                          "Only indicate the number of people at the table",
                          style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87)),
                    ),
                    SizedBox(height: 5.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.black, // Selected area
                            inactiveTrackColor:
                                Color(0xffC8CCCF), // Unselected area
                            thumbColor: Colors.black,
                            overlayColor: Colors.black.withOpacity(0.2),
                            trackHeight: 0.5,
                          ),
                          child: Slider(
                            thumbColor: Colors.white,

                            value: no_of_people,
                            min: 1,
                            max: 50,
                            divisions: 49, // (max - min)
                            label: no_of_people.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                no_of_people = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Column(
                          children: [
                            Text(
                              '${no_of_people.round()}',
                              style: GoogleFonts.roboto(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'People',
                              style: GoogleFonts.roboto(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
      ),
    );
  }
}
