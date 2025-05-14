// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RecipeQuestionnaireBottomSheet extends StatefulWidget {
  @override
  _RecipeQuestionnaireBottomSheetState createState() =>
      _RecipeQuestionnaireBottomSheetState();
}

class _RecipeQuestionnaireBottomSheetState
    extends State<RecipeQuestionnaireBottomSheet> {
  // State variables to store selected options
  String? _selectedTime;
  String? _selectedPeople;
  bool? _prepareLunch;
  String? _selectedHealthiness;
  String? _selectedCuisine;

  // Check if all questions are answered
  bool get _isFormComplete =>
      _selectedTime != null &&
      _selectedPeople != null &&
      _prepareLunch != null &&
      _selectedHealthiness != null &&
      _selectedCuisine != null;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffFFFFFF),
        appBar: AppBar(
          backgroundColor: Color(0xffFFFFFF),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QUESTIONNAIRE',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1F1F1F),
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffE5E9EF), width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 7.h,
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 2.w),
                        decoration: BoxDecoration(
                          color: Color(0xff1F1F1F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'What would you like to cook today?',
                              style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Answer these questions for personalized recommendations',
                              style: GoogleFonts.roboto(
                                fontSize: 13.5.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 1.h),

                            // Question 1: Time to cook
                            _buildQuestionTitle(
                                'How much time do you have to cook?'),
                            _buildOptionRow([
                              '<15 min',
                              '15-30 min',
                              '30-45 min',
                              '45+ min',
                            ], _selectedTime, (value) {
                              setState(() {
                                _selectedTime = value;
                              });
                            }),
                            SizedBox(height: 1.h),
                            Divider(color: Color(0xffDCDCDC), thickness: 1),
                            // Question 2: Number of people
                            _buildQuestionTitle(
                                'How many people are you cooking for?'),
                            _buildOptionRow(['1', '2', '3', '4+'],
                                _selectedPeople?.toString(), (value) {
                              setState(() {
                                _selectedPeople = value;
                              });
                            }),
                            SizedBox(height: 1.h),
                            Divider(color: Color(0xffDCDCDC), thickness: 1),
                            // Question 3: Prepare lunch
                            _buildQuestionTitle(
                                'Would you like to prepare your lunch for tomorrow at the same time?'),
                            _buildOptionRow(
                                ['Yes', 'No'],
                                _prepareLunch == null
                                    ? null
                                    : (_prepareLunch! ? 'Yes' : 'No'), (value) {
                              setState(() {
                                _prepareLunch = value == 'Yes';
                              });
                            }),
                            SizedBox(height: 1.h),
                            Divider(color: Color(0xffDCDCDC), thickness: 1),
                            // Question 4: Healthiness
                            _buildQuestionTitle(
                                'How healthy do you want your meal to be?'),
                            _buildOptionRow([
                              'Very Healthy',
                              'Balanced',
                              'Indulgent',
                              'No preference',
                            ], _selectedHealthiness, (value) {
                              setState(() {
                                _selectedHealthiness = value;
                              });
                            }),
                            SizedBox(height: 1.h),
                            Divider(color: Color(0xffDCDCDC), thickness: 1),
                            // Question 5: Cuisine preference
                            _buildQuestionTitle(
                                'Do you have a preferred type of cuisine?'),
                            _buildOptionRow([
                              'Italian',
                              'Asian',
                              'Mexican',
                              'Mediterranean',
                              'American',
                              'No preference',
                            ], _selectedCuisine, (value) {
                              setState(() {
                                _selectedCuisine = value;
                              });
                            }),

                            SizedBox(height: 3.h),

                            // Buttons: Cancel and Find Recipes
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.black54),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.5.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _isFormComplete
                                        ? () {
                                            // Handle form submission
                                            print('Form submitted:');
                                            print('Time: $_selectedTime');
                                            print('People: $_selectedPeople');
                                            print(
                                                'Prepare Lunch: $_prepareLunch');
                                            print(
                                                'Healthiness: $_selectedHealthiness');
                                            print('Cuisine: $_selectedCuisine');
                                            Navigator.pop(context);
                                            // You can navigate to a recipe results page here
                                          }
                                        : null, // Disable button if form is incomplete
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.5.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: Text(
                                      'Find Recipes',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper to build question titles
  Widget _buildQuestionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: Color(0xff1F1F1F),
        ),
      ),
    );
  }

  // Helper to build option rows with selectable buttons
  Widget _buildOptionRow(
      List<String> options, String? selectedOption, Function(String) onSelect) {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: options.map((option) {
        bool isSelected = selectedOption == option;
        return GestureDetector(
          onTap: () {
            onSelect(option);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black87 : Colors.white,
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              option,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
