import 'package:carl/onboarding_screens/sport_practice_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrimaryGoal extends StatefulWidget {
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
  final String? initialPrimaryGoal;
  const PrimaryGoal(
      {super.key,
      this.selectedGender,
      this.selectedDate,
      this.selectedHeight,
      this.selectedWeight,
      this.selectedActivity,
      this.selectedLifeStyleAndSleepQuality,
      this.selectedDailyStressLevel,
      this.initialPrimaryGoal,
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
      this.initialDietarySupplements});

  @override
  State<PrimaryGoal> createState() => _ActivityLevelSelectionScreenState();
}

class _ActivityLevelSelectionScreenState extends State<PrimaryGoal> {
  String? selectedActivity;

  final List<String> activityLevels = [
    "Improve athletic performance",
    "Physical transformation (fat loss, muscle gain, body recomposition)",
    "General health & well-being",
  ];
  @override
  void initState() {
    super.initState();
    // Auto-select the initial value if provided
    if (widget.initialPrimaryGoal != null) {
      selectedActivity = widget.initialPrimaryGoal;
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
                      value: 0.40,
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
                          return SportPracticeScreen(
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
                            initialSportPractice:
                                widget.selectedTypesofSportsPracticed,
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
              "What is your primary goal?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Select Choice",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ...activityLevels.map((level) {
              bool isSelected = selectedActivity == level;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedActivity = level;
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
                          const SizedBox(width: 24), // Keeps spacing consistent
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
                onPressed: () {
                  if (selectedActivity == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select your primary goal."),
                      ),
                    );
                  } else {
                    print("Selected primary goal: $selectedActivity");
                    // Go to next screen
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return SportPracticeScreen(
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
                          selectedPrimaryGoal: selectedActivity,
                          selectedPrioritiesinWellBeing:
                              widget.selectedPrioritiesinWellBeing,
                          selectedRisks: widget.selectedRisks,
                          selectedTypesofSportsPracticed:
                              widget.selectedTypesofSportsPracticed,
                          sugaryDrinks: widget.sugaryDrinks,
                          initialSportPractice:
                              widget.selectedTypesofSportsPracticed,
                        );
                      },
                    ));
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
