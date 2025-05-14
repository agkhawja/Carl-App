import 'package:carl/onboarding_screens/activity_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WeightSelectionScreen extends StatefulWidget {
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
  final String? initialWeight; // Added for initial weight value
  final String? initialUnit; // Added for initial unit (kg/lb)

  const WeightSelectionScreen({
    super.key,
    this.selectedGender,
    this.selectedDate,
    this.selectedHeight,
    this.initialWeight, // Initialize these
    this.initialUnit,
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
  State<WeightSelectionScreen> createState() => _WeightSelectionScreenState();
}

class _WeightSelectionScreenState extends State<WeightSelectionScreen> {
  bool isKilogram = true;
  double weightValue = 60;
  String unit = "kg";
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values if provided
    if (widget.initialWeight != null && widget.initialWeight!.isNotEmpty) {
      try {
        // Handle unit preference first
        if (widget.initialUnit != null) {
          isKilogram = widget.initialUnit!.toLowerCase() == 'kg';
          unit = isKilogram ? "kg" : "lb";
        }

        // Parse the weight value
        weightValue =
            double.tryParse(widget.initialWeight!) ?? (isKilogram ? 60 : 132);

        // Update controller with parsed value
        weightController.text = weightValue.toStringAsFixed(1);
      } catch (e) {
        print('Error parsing initial weight: $e');
        // Fallback to default values
        weightValue = isKilogram ? 60 : 132;
        weightController.text = weightValue.toStringAsFixed(1);
      }
    } else {
      // Default values
      weightController.text = isKilogram ? '60' : '132';
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
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
                      value: 0.20,
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
                          return ActivityLevelSelectionScreen(
                            selectedDate: widget.selectedDate.toString(),
                            selectedGender: widget.selectedGender,
                            selectedHeight: widget.selectedHeight,
                            selectedWeight: widget.selectedWeight,
                            eatOutPerWeek: widget.eatOutPerWeek,
                            initialDietarySupplements:
                                widget.initialDietarySupplements,
                            selectedActivity: widget.selectedActivity,
                            selectedAlcoholicBeverages:
                                widget.selectedAlcoholicBeverages,
                            selectedBodyCompositionGoal:
                                widget.selectedBodyCompositionGoal,
                            selectedDailyStressLevel:
                                widget.selectedDailyStressLevel,
                            selectedDietaryRestrictions:
                                widget.selectedDietaryRestrictions,
                            selectedEatingYourMeals:
                                widget.selectedEatingYourMeals,
                            timeSpendPreparingYourMealsDaily:
                                widget.timeSpendPreparingYourMealsDaily,
                            selectedLifeStyleAndSleepQuality:
                                widget.selectedLifeStyleAndSleepQuality,
                            selectedMeals: widget.selectedMeals,
                            selectedPrimaryGoal: widget.selectedPrimaryGoal,
                            selectedPrioritiesinWellBeing:
                                widget.selectedPrioritiesinWellBeing,
                            selectedRisks: widget.selectedRisks,
                            selectedTypesofSportsPracticed:
                                widget.selectedTypesofSportsPracticed,
                            sugaryDrinks: widget.sugaryDrinks,
                            initialActivityLevel: widget.selectedActivity,
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
              "Select weight",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Compulsory",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  _unitButton("Pound", !isKilogram),
                  _unitButton("Kilogram", isKilogram),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: weightController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            weightValue = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print(
                      "Selected Weight: $weightValue ${isKilogram ? 'kg' : 'lb'}");
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ActivityLevelSelectionScreen(
                        selectedDate: widget.selectedDate.toString(),
                        selectedGender: widget.selectedGender,
                        selectedHeight: widget.selectedHeight,
                        selectedWeight: weightValue.toStringAsFixed(1),
                        eatOutPerWeek: widget.eatOutPerWeek,
                        initialDietarySupplements:
                            widget.initialDietarySupplements,
                        selectedActivity: widget.selectedActivity,
                        selectedAlcoholicBeverages:
                            widget.selectedAlcoholicBeverages,
                        selectedBodyCompositionGoal:
                            widget.selectedBodyCompositionGoal,
                        selectedDailyStressLevel:
                            widget.selectedDailyStressLevel,
                        selectedDietaryRestrictions:
                            widget.selectedDietaryRestrictions,
                        selectedEatingYourMeals: widget.selectedEatingYourMeals,
                        timeSpendPreparingYourMealsDaily:
                            widget.timeSpendPreparingYourMealsDaily,
                        selectedLifeStyleAndSleepQuality:
                            widget.selectedLifeStyleAndSleepQuality,
                        selectedMeals: widget.selectedMeals,
                        selectedPrimaryGoal: widget.selectedPrimaryGoal,
                        selectedPrioritiesinWellBeing:
                            widget.selectedPrioritiesinWellBeing,
                        selectedRisks: widget.selectedRisks,
                        selectedTypesofSportsPracticed:
                            widget.selectedTypesofSportsPracticed,
                        sugaryDrinks: widget.sugaryDrinks,
                        initialActivityLevel: widget.selectedActivity,
                      );
                    },
                  ));
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
            )
          ],
        ),
      ),
    );
  }

  Widget _unitButton(String label, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isKilogram = label == "Kilogram";
            unit = isKilogram ? "kg" : "lb";
            // Convert value when changing units
            weightValue = isKilogram
                ? (weightValue * 0.453592)
                : // lb to kg
                (weightValue / 0.453592); // kg to lb
            weightController.text = weightValue.toStringAsFixed(1);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
