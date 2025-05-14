import 'package:carl/generated_results_log_recepies/rating_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic>? ai_one_recipes_detail_data;

  const DetailScreen({super.key, this.ai_one_recipes_detail_data});

  @override
  Widget build(BuildContext context) {
    // Extract nutritional data with fallbacks
    final calories =
        ai_one_recipes_detail_data?['Calories']?.toString() ?? 'N/A';
    final proteins =
        ai_one_recipes_detail_data?['Proteins']?.toString() ?? 'N/A';
    final carbohydrates =
        ai_one_recipes_detail_data?['Carbohydrates']?.toString() ?? 'N/A';
    final fats = ai_one_recipes_detail_data?['Fats']?.toString() ?? 'N/A';
    final saturatedFats =
        ai_one_recipes_detail_data?['Saturated Fats']?.toString() ?? 'N/A';
    final salt = ai_one_recipes_detail_data?['Salt']?.toString() ?? 'N/A';
    final dietaryFiber =
        ai_one_recipes_detail_data?['Dietary Fiber']?.toString() ?? 'N/A';
    final recipeName =
        ai_one_recipes_detail_data?['Recipe Name']?.toString() ?? 'N/A';

    return Column(
      children: [
        SizedBox(
          height:
              36.h, // Adjusted to fit within 45.h, leaving space for the footer
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 7.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              RegExp(r'\d+').stringMatch(calories) ?? '',
                              style: GoogleFonts.roboto(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0A0615),
                              ),
                            ),
                            Text(
                              'Kcal',
                              style: GoogleFonts.roboto(
                                fontSize: 20.sp,
                                color: Color(0xff0A0615),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                proteins,
                                style: GoogleFonts.roboto(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Proteins',
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: Color(0xff0A0615),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                carbohydrates,
                                style: GoogleFonts.roboto(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Carbohydrates',
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: Color(0xff0A0615),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                fats,
                                style: GoogleFonts.roboto(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Fats',
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: Color(0xff0A0615),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nutritional details',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildNutritionRow('Calories (Kcal)', calories),
                  _buildNutritionRow('Proteins', proteins),
                  _buildNutritionRow('Carbohydrates', carbohydrates),
                  _buildNutritionRow('Fats', fats),
                  _buildNutritionRow(
                      'of which saturated fatty acids', saturatedFats),
                  _buildNutritionRow('Salt', salt),
                  _buildNutritionRow('Dietary Fiber', dietaryFiber),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 1.h),
          height: 9.h,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 198, 196, 196),
                spreadRadius: 1,
                blurRadius: 6,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RatingReview(recipeName: recipeName);
                    },
                  ),
                );
              },
              child: Text(
                'Give Feedback',
                style: GoogleFonts.roboto(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0A0615),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.roboto(fontSize: 16)),
          Text(value, style: GoogleFonts.roboto(fontSize: 16)),
        ],
      ),
    );
  }
}
