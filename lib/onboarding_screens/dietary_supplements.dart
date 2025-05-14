import 'package:carl/api/api_service.dart';
import 'package:carl/home_screens/home_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DietarySupplements extends StatefulWidget {
  final String? selectedGender;
  final String? selectedDate;
  final String? selectedHeight;
  final String? selectedWeight;
  final String? selectedActivity;
  final String? selectedLifeStyleAndSleepQuality;
  final String? selectedDailyStressLevel;
  final String? selectedPrimaryGoal;
  final List<String>? selectedTypesofSportsPracticed;
  final String? selectedBodyCompositionGoal;
  final List<String>? selectedPrioritiesinWellBeing;
  final List<String>? selectedRisks;
  final List<String>? selectedDietaryRestrictions;
  final List<String>? selectedMeals;
  final String? selectedAlcoholicBeverages;
  final String? selectedEatingYourMeals;
  final String? timeSpendPreparingYourMealsDaily;
  final String? eatOutPerWeek;
  final String? sugaryDrinks;
  final List<String>? initialDietarySupplements;

  const DietarySupplements({
    super.key,
    this.selectedGender,
    this.selectedDate,
    this.selectedHeight,
    this.selectedWeight,
    this.selectedActivity,
    this.selectedLifeStyleAndSleepQuality,
    this.selectedDailyStressLevel,
    this.selectedPrimaryGoal,
    this.selectedTypesofSportsPracticed,
    this.selectedBodyCompositionGoal,
    this.selectedPrioritiesinWellBeing,
    this.selectedRisks,
    this.selectedDietaryRestrictions,
    this.selectedMeals,
    this.selectedAlcoholicBeverages,
    this.selectedEatingYourMeals,
    this.timeSpendPreparingYourMealsDaily,
    this.eatOutPerWeek,
    this.sugaryDrinks,
    this.initialDietarySupplements,
  });

  @override
  State<DietarySupplements> createState() => _DietarySupplementsState();
}

class _DietarySupplementsState extends State<DietarySupplements> {
  final List<String> selectedActivities = [];
  final List<String> activityLevels = [
    "No",
    "Multivitamins",
    "Protein powders (whey, plant-based, casein, etc.)",
    "Omega-3 (EPA/DHA)",
    "Creatine",
    "Magnesium",
    "Vitamin D",
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.initialDietarySupplements != null &&
        widget.initialDietarySupplements!.isNotEmpty) {
      for (var supplement in widget.initialDietarySupplements!) {
        final matchingOption = activityLevels.firstWhere(
          (option) => option.toLowerCase() == supplement.toLowerCase(),
          orElse: () => supplement,
        );
        if (activityLevels.contains(matchingOption)) {
          selectedActivities.add(matchingOption);
        }
      }
      if (selectedActivities.contains("No")) {
        selectedActivities.clear();
        selectedActivities.add("No");
      }
    }
  }

  void showBottomSheetOnce() {
    if (_isBottomSheetShown) return;
    _isBottomSheetShown = true;

    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.white,
      context: _scaffoldKey.currentContext ?? context,
      builder: (context) {
        try {
          return SizedBox(
            height: 100.h,
            width: 100.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 2.h),
                Image.asset(
                  'assests/tick_onboarding.png',
                  width: 25.w,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Image failed to load');
                  },
                ),
                SizedBox(height: 2.h),
                Text(
                  textAlign: TextAlign.center,
                  'Everything is set up let\'s head up to the home screen.',
                  style: GoogleFonts.merriweather(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 25.w),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HomeMainScreen()),
                      );
                    },
                    child: Text(
                      'Go to Dashboard',
                      style: GoogleFonts.merriweather(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } catch (e) {
          print('Error in bottom sheet: $e');
          return const Center(child: Text('Error loading bottom sheet'));
        }
      },
    ).whenComplete(() {
      _isBottomSheetShown = false;
    });
  }

  bool _isBottomSheetShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFEAEAEA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Column(
          children: [
            SizedBox(height: 5.h),
            Container(
              color: const Color(0xffEBEBEB),
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new,
                        size: 16.sp, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 1.0,
                      backgroundColor: Colors.grey[300],
                      color: Colors.black,
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Do you take dietary supplements? If yes, which ones?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Select one or more choices",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ...activityLevels.map((level) {
              bool isSelected = selectedActivities.contains(level);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (level == "No") {
                        selectedActivities.clear();
                        selectedActivities.add(level);
                      } else {
                        selectedActivities.remove("No");
                        if (isSelected) {
                          selectedActivities.remove(level);
                        } else {
                          selectedActivities.add(level);
                        }
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(Icons.check, color: Colors.white)
                        else
                          const SizedBox(width: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            level,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedActivities.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select at least one option."),
                      ),
                    );
                  } else {
                    print("Selected dietary supplements: $selectedActivities");
                    try {
                      final result = await ApiService().updateProfile(
                        context,
                        selectedGender: widget.selectedGender,
                        selectedDate: widget.selectedDate,
                        selectedHeight: widget.selectedHeight,
                        selectedWeight: widget.selectedWeight,
                        selectedActivity: widget.selectedActivity,
                        selectedLifeStyleAndSleepQuality:
                            widget.selectedLifeStyleAndSleepQuality,
                        selectedDailyStressLevel:
                            widget.selectedDailyStressLevel,
                        selectedPrimaryGoal: widget.selectedPrimaryGoal,
                        selectedTypesofSportsPracticed:
                            widget.selectedTypesofSportsPracticed,
                        selectedBodyCompositionGoal:
                            widget.selectedBodyCompositionGoal,
                        selectedPrioritiesinWellBeing:
                            widget.selectedPrioritiesinWellBeing,
                        selectedRisks: widget.selectedRisks,
                        selectedDietaryRestrictions:
                            widget.selectedDietaryRestrictions,
                        selectedMeals: widget.selectedMeals,
                        selectedAlcoholicBeverages:
                            widget.selectedAlcoholicBeverages,
                        selectedEatingYourMeals: widget.selectedEatingYourMeals,
                        timeSpendPreparingYourMealsDaily:
                            widget.timeSpendPreparingYourMealsDaily,
                        eatOutPerWeek: widget.eatOutPerWeek,
                        sugaryDrinks: widget.sugaryDrinks,
                        selectedDietarySupplements: selectedActivities,
                      );
                      if (result.containsKey('error')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Error: ${result['error']['message']}'),
                          ),
                        );
                      } else {
                        print("Bottom sheet should show now");
                        Future.delayed(Duration.zero, () {
                          showBottomSheetOnce();
                        });
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('API Error: $e'),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Next",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
