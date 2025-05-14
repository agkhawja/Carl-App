import 'package:carl/onboarding_screens/dob_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GenderSelectionScreen extends StatefulWidget {
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
  final String? initialGender;
  const GenderSelectionScreen(
      {super.key,
      this.initialGender,
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
      this.initialDietarySupplements});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? selectedGender;

  void _onNextPressed() {
    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a value first to proceed")),
      );
    } else {
      print("selectedGender: $selectedGender");
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return BirthdaySelectionScreen(
            selectedGender: selectedGender,
            eatOutPerWeek: widget.eatOutPerWeek,
            initialDate: widget.selectedDate,
            initialDietarySupplements: widget.initialDietarySupplements,
            selectedActivity: widget.selectedActivity,
            selectedAlcoholicBeverages: widget.selectedAlcoholicBeverages,
            selectedBodyCompositionGoal: widget.selectedBodyCompositionGoal,
            selectedDailyStressLevel: widget.selectedDailyStressLevel,
            selectedDate: widget.selectedDate,
            selectedDietaryRestrictions: widget.initialDietarySupplements,
            selectedEatingYourMeals: widget.selectedEatingYourMeals,
            selectedHeight: widget.selectedHeight,
            timeSpendPreparingYourMealsDaily:
                widget.timeSpendPreparingYourMealsDaily,
            selectedLifeStyleAndSleepQuality:
                widget.selectedLifeStyleAndSleepQuality,
            selectedMeals: widget.selectedMeals,
            selectedPrimaryGoal: widget.selectedPrimaryGoal,
            selectedPrioritiesinWellBeing: widget.selectedPrioritiesinWellBeing,
            selectedRisks: widget.selectedRisks,
            selectedTypesofSportsPracticed:
                widget.selectedTypesofSportsPracticed,
            selectedWeight: widget.selectedWeight,
            sugaryDrinks: widget.sugaryDrinks,
          );
        },
      ));
    }
  }

  Widget _genderButton(String gender) {
    final bool isSelected = selectedGender == gender;
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedGender = gender;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 7.w),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black12),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected)
                Icon(Icons.check, color: Colors.white, size: 16.sp),
              if (isSelected) SizedBox(width: 2.w),
              Text(
                gender.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Auto-select the initial value if provided
    if (widget.initialGender != null) {
      selectedGender = widget.initialGender;
    }
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
                      value: 0.05,
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
                          return BirthdaySelectionScreen(
                            selectedGender: widget.selectedGender,
                            eatOutPerWeek: widget.eatOutPerWeek,
                            initialDate: widget.selectedDate,
                            initialDietarySupplements:
                                widget.initialDietarySupplements,
                            selectedActivity: widget.selectedActivity,
                            selectedAlcoholicBeverages:
                                widget.selectedAlcoholicBeverages,
                            selectedBodyCompositionGoal:
                                widget.selectedBodyCompositionGoal,
                            selectedDailyStressLevel:
                                widget.selectedDailyStressLevel,
                            selectedDate: widget.selectedDate,
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
        padding: EdgeInsets.only(left: 5.5.w, bottom: 5.h, right: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose gender",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 1.h),
            Text("Choose 1 option",
                style: TextStyle(color: Colors.grey, fontSize: 15.sp)),
            SizedBox(height: 5.h),
            Row(
              children: [
                _genderButton("Male"),
                SizedBox(width: 4.w),
                _genderButton("Female"),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: _onNextPressed,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.8.h),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Next",
                        style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                    SizedBox(width: 2.w),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18.sp),
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
