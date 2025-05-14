import 'package:carl/onboarding_screens/height_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BirthdaySelectionScreen extends StatefulWidget {
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
  final String? initialDate; // Added this parameter for initial date

  const BirthdaySelectionScreen({
    super.key,
    this.selectedGender,
    this.initialDate,
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
    this.initialDietarySupplements, // Initialize this parameter
  });

  @override
  State<BirthdaySelectionScreen> createState() =>
      _BirthdaySelectionScreenState();
}

class _BirthdaySelectionScreenState extends State<BirthdaySelectionScreen> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    // Auto-select the initial date if provided
    if (widget.initialDate != null && widget.initialDate!.isNotEmpty) {
      try {
        selectedDate = DateTime.parse(widget.initialDate!);
      } catch (e) {
        print('Error parsing initial date: $e');
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String getFormattedDate() {
    if (selectedDate == null) return '';
    return DateFormat('yyyy-MM-dd').format(selectedDate!);
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
                      value: 0.10,
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
                          return HeightSelectionScreen(
                            selectedGender: widget.selectedGender,
                            selectedDate: widget.selectedDate ?? '',
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
                            selectedHeight: widget.selectedHeight,
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
                            initialHeight: widget.selectedHeight,
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
              "Select date of birth",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Compulsory",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        getFormattedDate().isEmpty
                            ? "Select date"
                            : getFormattedDate(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Icon(Icons.calendar_today_outlined,
                        color: Colors.grey),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select your date of birth")),
                    );
                  } else {
                    print('selectedDate: $selectedDate');
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return HeightSelectionScreen(
                          selectedGender: widget.selectedGender,
                          selectedDate: selectedDate.toString(),
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
                          selectedHeight: widget.selectedHeight,
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
                          initialHeight: widget.selectedHeight,
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
            )
          ],
        ),
      ),
    );
  }
}
