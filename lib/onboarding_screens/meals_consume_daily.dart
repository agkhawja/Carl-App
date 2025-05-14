// ignore_for_file: unused_local_variable

import 'package:carl/onboarding_screens/alcohlic_beverges.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MealsConsumeDaily extends StatefulWidget {
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
  final List<String>? initialMealsConsumeDaily;
  const MealsConsumeDaily(
      {super.key,
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
      this.initialMealsConsumeDaily,
      this.selectedMeals,
      this.selectedAlcoholicBeverages,
      this.selectedEatingYourMeals,
      this.timeSpendPreparingYourMealsDaily,
      this.eatOutPerWeek,
      this.sugaryDrinks,
      this.initialDietarySupplements});

  @override
  State<MealsConsumeDaily> createState() => _MealsConsumeDailyState();
}

class _MealsConsumeDailyState extends State<MealsConsumeDaily> {
  final List<String> meals = [
    "Breakfast",
    "Lunch",
    "Diner",
    "Collations",
  ];
  final List<String> selectedMeals = [];
  @override
  void initState() {
    super.initState();
    // Auto-select the initial values if provided
    if (widget.initialMealsConsumeDaily != null &&
        widget.initialMealsConsumeDaily!.isNotEmpty) {
      // Convert API values to match our options (case-insensitive)
      for (var restriction in widget.initialMealsConsumeDaily!) {
        final matchingOption = meals.firstWhere(
          (option) => option.toLowerCase() == restriction.toLowerCase(),
          orElse: () => restriction,
        );
        if (meals.contains(matchingOption)) {
          selectedMeals.add(matchingOption);
        }
      }

      // // Handle "None" selection - clear others if "None" is selected
      // if (selectedMeals.contains("None")) {
      //   selectedMeals.clear();
      //   selectedMeals.add("None");
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      value: 0.70,
                      backgroundColor: Colors.grey[300],
                      color: Colors.black,
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AlcohlicBeverges(
                            selectedActivity: widget.selectedActivity,
                            selectedDailyStressLevel:
                                widget.selectedDailyStressLevel,
                            selectedDate: widget.selectedDate,
                            selectedGender: widget.selectedGender,
                            selectedHeight: widget.selectedHeight,
                            selectedLifeStyleAndSleepQuality:
                                widget.selectedLifeStyleAndSleepQuality,
                            selectedWeight: widget.selectedWeight,
                            eatOutPerWeek: widget.eatOutPerWeek,
                            initialDietarySupplements:
                                widget.initialDietarySupplements,
                            selectedAlcoholicBeverages:
                                widget.selectedAlcoholicBeverages,
                            selectedBodyCompositionGoal:
                                widget.selectedBodyCompositionGoal,
                            selectedDietaryRestrictions:
                                widget.selectedDietaryRestrictions,
                            selectedEatingYourMeals:
                                widget.selectedEatingYourMeals,
                            timeSpendPreparingYourMealsDaily:
                                widget.timeSpendPreparingYourMealsDaily,
                            selectedMeals: widget.selectedMeals,
                            selectedPrimaryGoal: widget.selectedPrimaryGoal,
                            selectedPrioritiesinWellBeing:
                                widget.selectedPrioritiesinWellBeing,
                            selectedRisks: widget.selectedRisks,
                            selectedTypesofSportsPracticed:
                                widget.selectedTypesofSportsPracticed,
                            sugaryDrinks: widget.sugaryDrinks,
                            initialAlcoholicBeverages:
                                widget.selectedAlcoholicBeverages,
                          );
                        },
                      ));
                    },
                    child: Text("Skip",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp)),
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
              "Which meals do you consume daily?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Select Choice", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth;
                double chipWidth = 120; // estimated width per option
                int chipsPerRow = (maxWidth / chipWidth).floor();

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: meals.map((meal) {
                    final isSelected = selectedMeals.contains(meal);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedMeals.remove(meal);
                          } else {
                            selectedMeals.add(meal);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected)
                              const Icon(Icons.check, color: Colors.white)
                            else
                              const SizedBox(width: 24),
                            const SizedBox(width: 12),
                            Text(
                              meal,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedMeals.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select at least one meal."),
                      ),
                    );
                  } else {
                    print("Selected meals: $selectedMeals");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlcohlicBeverges(
                          selectedActivity: widget.selectedActivity,
                          selectedDailyStressLevel:
                              widget.selectedDailyStressLevel,
                          selectedDate: widget.selectedDate,
                          selectedGender: widget.selectedGender,
                          selectedHeight: widget.selectedHeight,
                          selectedLifeStyleAndSleepQuality:
                              widget.selectedLifeStyleAndSleepQuality,
                          selectedWeight: widget.selectedWeight,
                          eatOutPerWeek: widget.eatOutPerWeek,
                          initialDietarySupplements:
                              widget.initialDietarySupplements,
                          selectedAlcoholicBeverages:
                              widget.selectedAlcoholicBeverages,
                          selectedBodyCompositionGoal:
                              widget.selectedBodyCompositionGoal,
                          selectedDietaryRestrictions:
                              widget.selectedDietaryRestrictions,
                          selectedEatingYourMeals:
                              widget.selectedEatingYourMeals,
                          timeSpendPreparingYourMealsDaily:
                              widget.timeSpendPreparingYourMealsDaily,
                          selectedMeals: selectedMeals,
                          selectedPrimaryGoal: widget.selectedPrimaryGoal,
                          selectedPrioritiesinWellBeing:
                              widget.selectedPrioritiesinWellBeing,
                          selectedRisks: widget.selectedRisks,
                          selectedTypesofSportsPracticed:
                              widget.selectedTypesofSportsPracticed,
                          sugaryDrinks: widget.sugaryDrinks,
                          initialAlcoholicBeverages:
                              widget.selectedAlcoholicBeverages,
                        ),
                      ),
                    );
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
