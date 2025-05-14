import 'package:carl/onboarding_screens/weight_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HeightSelectionScreen extends StatefulWidget {
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
  final String? initialHeight; // Added for initial height value
  final String? initialUnit; // Added for initial unit (cm/ft)

  const HeightSelectionScreen({
    super.key,
    this.selectedGender,
    this.selectedDate,
    this.initialHeight, // Initialize these
    this.initialUnit,
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
  State<HeightSelectionScreen> createState() => _HeightSelectionScreenState();
}

class _HeightSelectionScreenState extends State<HeightSelectionScreen> {
  bool isCentimeter = true;
  double heightValue = 168;
  String unit = "cm";
  final TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values if provided
    if (widget.initialHeight != null && widget.initialHeight!.isNotEmpty) {
      try {
        // Handle unit preference first
        if (widget.initialUnit != null) {
          isCentimeter = widget.initialUnit!.toLowerCase() == 'cm';
          unit = isCentimeter ? "cm" : "ft";
        }

        // Parse the height value
        heightValue = double.tryParse(widget.initialHeight!) ??
            (isCentimeter ? 168 : 5.5);

        // Update controller with parsed value
        heightController.text = heightValue.toString();
      } catch (e) {
        print('Error parsing initial height: $e');
        // Fallback to default values
        heightValue = isCentimeter ? 168 : 5.5;
        heightController.text = heightValue.toString();
      }
    } else {
      // Default values
      heightController.text = isCentimeter ? '168' : '5.5';
    }
  }

  @override
  void dispose() {
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEBEBEB),
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
                      value: 0.15,
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
                          return WeightSelectionScreen(
                            selectedDate: widget.selectedDate,
                            selectedGender: widget.selectedGender,
                            selectedHeight: widget.selectedHeight,
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
                            selectedWeight: widget.selectedWeight,
                            sugaryDrinks: widget.sugaryDrinks,
                            initialWeight: widget.selectedWeight,
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
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select height",
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
                  _unitButton("Feet", !isCentimeter),
                  _unitButton("Centimetre", isCentimeter),
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
                        controller: heightController,
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
                            heightValue = double.tryParse(value) ?? 0;
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
                      "Selected Height: $heightValue ${isCentimeter ? 'cm' : 'ft'}");
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return WeightSelectionScreen(
                        selectedDate: widget.selectedDate,
                        selectedGender: widget.selectedGender,
                        selectedHeight: heightValue.toString(),
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
                            widget.initialDietarySupplements,
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
                        selectedWeight: widget.selectedWeight,
                        sugaryDrinks: widget.sugaryDrinks,
                        initialWeight: widget.selectedWeight,
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
            isCentimeter = label == "Centimetre";
            unit = isCentimeter ? "cm" : "ft";
            // Convert value when changing units
            heightValue = isCentimeter
                ? (heightValue * 30.48)
                : // ft to cm
                (heightValue / 30.48); // cm to ft
            heightController.text =
                heightValue.toStringAsFixed(isCentimeter ? 0 : 1);
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
