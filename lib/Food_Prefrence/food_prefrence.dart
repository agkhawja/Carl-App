// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:carl/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodPreferenceScreen extends StatefulWidget {
  const FoodPreferenceScreen({super.key});

  @override
  State<FoodPreferenceScreen> createState() => _FoodPreferenceScreenState();
}

class _FoodPreferenceScreenState extends State<FoodPreferenceScreen> {
  final TextEditingController likeController = TextEditingController();
  final TextEditingController avoidController = TextEditingController();

  final List<String> likedFoods = [];
  final List<String> avoidFoods = [];

  final List<String> dietaryOptions = [
    'Vegetarian',
    'Vegan',
    'Gluten Free',
    'Dairy Free',
    'Keto',
    'Low Carb',
    'Low Sodium',
  ];
  final List<String> selectedPreferences = [];
  bool isLoading = false;
  bool get isSaveEnabled =>
      likedFoods.isNotEmpty ||
      avoidFoods.isNotEmpty ||
      selectedPreferences.isNotEmpty;

  void addItem(String input, List<String> list) {
    final trimmed = input.trim();
    if (trimmed.isNotEmpty && !list.contains(trimmed)) {
      setState(() {
        list.add(trimmed);
      });
    }
  }

  void removeItem(String item, List<String> list) {
    setState(() {
      list.remove(item);
    });
  }

  void handleSave() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Fetch existing data to determine if PUT or POST is needed
      final allData = await ApiService().foodPrefrenceGetAllData(context);
      bool hasExistingData = false;
      String? documentId;

      if (allData.containsKey('data') &&
          allData['data'] != null &&
          allData['data'].isNotEmpty) {
        // Assuming the API returns a list of preferences, check the first item
        final firstItem = allData['data'][0];
        if (firstItem['foods_you_like']?.isNotEmpty == true ||
            firstItem['foods_to_Avoid']?.isNotEmpty == true ||
            firstItem['dietary_Preferences']?.isNotEmpty == true) {
          hasExistingData = true;
          documentId = firstItem['documentId'];
        }
      }

      Map<String, dynamic> response;
      if (hasExistingData && documentId != null) {
        // Call PUT API if data exists
        response = await ApiService().foodPrefrenceApiputApi(
          context,
          likedFoods,
          avoidFoods,
          selectedPreferences,
          documentId,
        );
      } else {
        // Call POST API if no data exists
        response = await ApiService().foodPrefrenceApi(
          context,
          likedFoods,
          avoidFoods,
          selectedPreferences,
        );
      }

      if (response.containsKey('data') && response['data'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Preferences Saved Successfully",
              style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to Save Preferences: ${response['error']?['message'] ?? 'Unknown error'}",
              style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      print("Liked Foods: $likedFoods");
      print("Avoid Foods: $avoidFoods");
      print("Dietary Preferences: $selectedPreferences");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
            style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      print("Unexpected Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildChips(List<String> items, List<String> listRef) {
    return Wrap(
      spacing: 1.w,
      runSpacing: 1.h,
      children: items.map((item) {
        return Chip(
          label: Text(item, style: GoogleFonts.roboto(color: Colors.white)),
          backgroundColor: Colors.black,
          deleteIconColor: Colors.white,
          onDeleted: () => removeItem(item, listRef),
        );
      }).toList(),
    );
  }

  Widget buildCheckbox(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          activeColor: Colors.black,
          value: selectedPreferences.contains(label),
          onChanged: (val) {
            setState(() {
              if (val!) {
                selectedPreferences.add(label);
              } else {
                selectedPreferences.remove(label);
              }
            });
          },
        ),
        Text(label, style: GoogleFonts.roboto(fontSize: 16.sp)),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  getAllData() async {
    setState(() {
      isLoading = true;
    });
    final Logger logger = Logger();
    try {
      final allData = await ApiService().foodPrefrenceGetAllData(context);
      logger.d('Fetched Food Preferences: $allData');

      if (mounted) {
        setState(() {
          // Clear existing data to avoid duplicates
          likedFoods.clear();
          avoidFoods.clear();
          selectedPreferences.clear();

          // Check if data exists and is non-empty
          if (allData.containsKey('data') &&
              allData['data'] != null &&
              allData['data'].isNotEmpty) {
            final firstItem = allData['data'][0];
            logger.d('First Item: $firstItem');

            // Populate foods_you_like
            if (firstItem['foods_you_like'] is List &&
                firstItem['foods_you_like'].isNotEmpty) {
              final foodsYouLike = <String>[];
              for (var item in firstItem['foods_you_like']) {
                if (item is String && item.isNotEmpty) {
                  foodsYouLike.add(item);
                }
              }
              likedFoods.addAll(foodsYouLike);
              logger.d('Processed foods_you_like: $foodsYouLike');
            }

            // Populate foods_to_Avoid
            if (firstItem['foods_to_Avoid'] is List &&
                firstItem['foods_to_Avoid'].isNotEmpty) {
              final foodsToAvoid = <String>[];
              for (var item in firstItem['foods_to_Avoid']) {
                if (item is String && item.isNotEmpty) {
                  foodsToAvoid.add(item);
                }
              }
              avoidFoods.addAll(foodsToAvoid);
              logger.d('Processed foods_to_Avoid: $foodsToAvoid');
            }

            // Populate dietary_Preferences (only valid options)
            if (firstItem['dietary_Preferences'] is List &&
                firstItem['dietary_Preferences'].isNotEmpty) {
              final validPreferences = <String>[];
              for (var pref in firstItem['dietary_Preferences']) {
                if (pref is String &&
                    dietaryOptions.any((option) =>
                        option.toLowerCase() == pref.toLowerCase())) {
                  // Use the exact dietaryOptions value for consistency
                  validPreferences.add(dietaryOptions.firstWhere(
                      (option) => option.toLowerCase() == pref.toLowerCase()));
                }
              }
              selectedPreferences.addAll(validPreferences);
              logger.d('Processed dietary_Preferences: $validPreferences');
            }

            logger.d(
                'Populated Data - Liked Foods: $likedFoods, Avoid Foods: $avoidFoods, Selected Preferences: $selectedPreferences');
          }

          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to load preferences: $e",
              style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      logger.e('Error fetching food preferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEBEBEB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffEBEBEB),
        elevation: 0,
        title: Text('Food Preference',
            style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foods You Like
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Foods you like",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.sp,
                        color: Color(0xff0A0615),
                      )),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: likeController,
                    onSubmitted: (val) {
                      addItem(val, likedFoods);
                      likeController.clear();
                    },
                    decoration: InputDecoration(
                      hintText: "Search foods your enjoy",
                      hintStyle: GoogleFonts.roboto(),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  buildChips(likedFoods, likedFoods),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Foods to Avoid
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Foods to Avoid",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.sp,
                        color: Color(0xff0A0615),
                      )),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: avoidController,
                    onSubmitted: (val) {
                      addItem(val, avoidFoods);
                      avoidController.clear();
                    },
                    decoration: InputDecoration(
                      hintText: "Search foods to avoid",
                      hintStyle: GoogleFonts.roboto(),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  buildChips(avoidFoods, avoidFoods),
                  SizedBox(height: 1.h),
                  Text(
                      "Mark items with the allergen icon to exclude them completely",
                      style: GoogleFonts.roboto(
                          color: Color(0xff979797), fontSize: 13.5.sp)),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Dietary Preferences
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dietary Preferences",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.sp,
                        color: Color(0xff0A0615),
                      )),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 23.w,
                    runSpacing: 1.h,
                    children: dietaryOptions.map(buildCheckbox).toList(),
                  )
                ],
              ),
            ),
            SizedBox(height: 4.h),

            // Save Button
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: ElevatedButton(
                onPressed: isSaveEnabled ? handleSave : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Save Preferences",
                        style: GoogleFonts.roboto(
                            fontSize: 18.sp, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
