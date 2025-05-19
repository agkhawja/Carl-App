// ignore_for_file: avoid_print, non_constant_identifier_names, library_private_types_in_public_api

import 'dart:convert';
import 'dart:typed_data';

import 'package:carl/generated_results_log_recepies/ingredients_screen.dart';
import 'package:carl/generated_results_log_recepies/recipe_detail_screen.dart';
import 'package:carl/generated_results_log_recepies/steps_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RecipeScreen extends StatefulWidget {
  final String? recipe_Image;
  final Map<String, dynamic>? ai_one_recipes_detail_data;
  const RecipeScreen(
      {super.key, this.ai_one_recipes_detail_data, this.recipe_Image});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int _selectedTab = 0; // 0: Ingredients, 1: Steps, 2: Detail
  Uint8List? imageBytes;
  @override
  void initState() {
    super.initState();
    imageBytes = base64Decode(widget.recipe_Image ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 100.h,
              color: Color(0xffF7F7F7),
            ),
            Container(
              height: 25.h,
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ai_one_recipes_detail_data?['Recipe Name'] ??
                            'N/A',
                        style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff0A0615),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.ai_one_recipes_detail_data?['Recipe Title'] ??
                            'N/A',
                        style: GoogleFonts.roboto(
                          color: Color(0xff707070),
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: widget.recipe_Image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(500),
                                  child: Image.memory(
                                    imageBytes ?? Uint8List(0),
                                    height: 75.sp,
                                    width: 75.sp,
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      print(
                                          'Base64 image failed to load: $error');
                                      return Image.asset(
                                        "assests/generated_results_log_recepies/recipe_dish.png",
                                        height: 65.sp,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Text(
                                              'Image failed to load');
                                        },
                                      );
                                    },
                                  ),
                                )
                              : Image.asset(
                                  'assests/generated_results_log_recepies/recipe_dish.png',
                                  height: 65.sp,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        widget.ai_one_recipes_detail_data?[
                                'Short Description'] ??
                            'N/A',
                        style: GoogleFonts.roboto(
                          fontSize: 15.5.sp,
                          color: Color(0xff0A0615),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Tab Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTabButton('Ingredients', 0),
                      _buildTabButton('Steps', 1),
                      _buildTabButton('Detail', 2),
                    ],
                  ),
                ),
                // Tab Content with constrained height
                SizedBox(
                  height: 45.h, // Adjust based on available space
                  child: _buildTabContent(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _selectedTab == index ? Colors.black : Color(0xff57636C),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.roboto(
                color: _selectedTab == index ? Colors.white : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return IngredientsScreen(
          ai_one_recipes_detail_data: widget.ai_one_recipes_detail_data,
        );
      case 1:
        return StepsScreen(
          ai_one_recipes_detail_data: widget.ai_one_recipes_detail_data,
        );
      case 2:
        return DetailScreen(
          ai_one_recipes_detail_data: widget.ai_one_recipes_detail_data,
        );
      default:
        return IngredientsScreen(
          ai_one_recipes_detail_data: widget.ai_one_recipes_detail_data,
        );
    }
  }
}
