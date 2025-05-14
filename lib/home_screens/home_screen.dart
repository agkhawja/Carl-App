// ignore_for_file: unused_field, unused_element, avoid_print, use_build_context_synchronously, prefer_final_fields, deprecated_member_use, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:carl/home_screens/Question_One_Screen.dart';
import 'package:carl/onboarding_screens/activity_level_screen.dart';
import 'package:carl/onboarding_screens/alcohlic_beverges.dart';
import 'package:carl/onboarding_screens/body_compostion_goal.dart';
import 'package:carl/onboarding_screens/dietary_restrictions_allergies.dart';
import 'package:carl/onboarding_screens/dietary_supplements.dart';
import 'package:carl/onboarding_screens/dob_screen.dart';
import 'package:carl/onboarding_screens/eat_out_per_week.dart';
import 'package:carl/onboarding_screens/eating_your_meals.dart';
import 'package:carl/onboarding_screens/gender_selection_screen.dart';
import 'package:carl/onboarding_screens/height_selection_screen.dart';
import 'package:carl/onboarding_screens/meals_consume_daily.dart';
import 'package:carl/onboarding_screens/preparing_your_meals_daily.dart';
import 'package:carl/onboarding_screens/primary_goal.dart';
import 'package:carl/onboarding_screens/priority_in_well_being.dart';
import 'package:carl/onboarding_screens/risk.dart';
import 'package:carl/onboarding_screens/sleep_quality_screen.dart';
import 'package:carl/onboarding_screens/sport_practice_screen.dart';
import 'package:carl/onboarding_screens/stress_level.dart';
import 'package:carl/onboarding_screens/sugary_drinks.dart';
import 'package:carl/onboarding_screens/weight_selection_screen.dart';
import 'package:http/http.dart' as http;
import 'package:carl/api/api_service.dart';
// import 'package:carl/home_screens/ask_nutri_ai.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // For bottom navigation bar
  final List<String> _likedFoods = ['Avocado', 'Salmon', 'Sweet Potato'];
  final List<String> _avoidFoods = ['Bell Peppers', 'Blue Cheese'];
  final List<bool> _dietPreferences = [
    true,
    false,
    false,
    false,
    false,
    false,
    false
  ]; // Vegetarian selected
  bool _isTodaySelected =
      true; // State to track the selected tab (Today or Yesterday)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Tapped on index: $index');
  }

  String _userId = 'Unknown';
  Map<String, dynamic>? _userData; // Store API response
  bool _isLoading = false; // Loading state
  String? _errorMessage; // Error message for API or userId fetch
  int _nullCount = 0; // Store the count of null values

  @override
  void initState() {
    super.initState();
    print('Hassn bHai init State Chal rhi ha');
    _fetchUserIdAndData(); // Fetch userId and API data
    _loadUserData();
  }

  // Fetch userId and then call the API
  Future<void> _fetchUserIdAndData() async {
    setState(() {
      _isLoading = true; // Show loading state
      _errorMessage = null; // Reset error message
      _nullCount = 0; // Reset null count
    });

    try {
      // Step 1: Fetch userId
      String userId = await _getUserId();
      setState(() {
        _userId = userId; // Update userId
      });
      print('User ID: $_userId');

      // Step 2: Call the API with the fetched userId
      var response = await ApiService().getAllUserData(context);
      setState(() {
        _userData = response; // Store the API response
        // Step 3: Count the number of null values in the response
        _nullCount = _userData!.entries
            .where((entry) =>
                entry.value == null ||
                entry.value is List && (entry.value as List).isEmpty)
            .length;
      });
      print('API Response: $_userData');
      print('Number of null values: $_nullCount'); // Debug: Print the count
      Logger logger = Logger();
      print('All User Data');
      logger.d(_userData);
      print('All User Data');
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load user data: $e'; // Set error message
      });
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading state
      });
    }
  }

  // Fetch userId from SharedPreferences
  Future<String> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson == null) {
      return 'Unknown';
    }
    Map<String, dynamic> user = json.decode(userJson);
    return user['id']?.toString() ?? 'Unknown';
  }

  // Fetch username from the 'user' object in SharedPreferences
  Future<String> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson == null) {
      return 'User';
    }
    Map<String, dynamic> user = json.decode(userJson);
    return user['username'] ?? 'User';
  }

  String? expandedMeal;
  void _toggleExpand(String meal) {
    setState(() {
      expandedMeal = expandedMeal == meal ? null : meal;
    });
  }

  String? _expandedMealKey;
  String? imageUrl;
  String username = '';
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> userMap = json.decode(userJson);
      setState(() {
        username = userMap['username'] ?? '';
        if (userMap['profile_image'] != null &&
            userMap['profile_image']['url'] != null) {
          imageUrl = userMap['profile_image']['url'];
        } else {
          imageUrl = null;
        }
      });
    }
  }

  Future<bool> _imageExists(String url) async {
    if (url.isEmpty) return false;

    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error checking image existence: $e');
      return false;
    }
  }

  Widget _buildUserAvatar() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Construct proper URL
      final fullUrl = imageUrl!.startsWith('http')
          ? imageUrl!
          : 'https://c502-39-60-230-244.ngrok-free.app${imageUrl!.startsWith('/') ? imageUrl! : '/$imageUrl'}';

      debugPrint('Loading profile image from: $fullUrl');

      return CircleAvatar(
        radius: 6.5.w,
        backgroundColor: Colors.grey[300],
        backgroundImage: NetworkImage(fullUrl),
        onBackgroundImageError: (e, stack) {
          debugPrint('Failed to load profile image: $e');
        },
      );
    } else {
      return CircleAvatar(
        radius: 6.5.w,
        backgroundColor: Colors.grey[300],
        child: Text(
          username.isNotEmpty ? username[0].toUpperCase() : '',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    }
  }

// Add this method to your _HomeScreenState class
  String? _getFirstNullField() {
    if (_userData == null) return null;

    // Check each field in order of priority (you can adjust the order as needed)
    final fieldsToCheck = [
      'dob',
      'gender',
      'height',
      'weight',
      'primary_goal',
      'sport_do_you_practice',
      'body_composition_goal',
      'priority_in_well_being',
      'risks',
      'dietary_restrictions_or_allergies',
      'meals_consume_daily',
      'alcohalic_beverages',
      'time_spend_eating_your_meals_daily',
      'time_spend_preparing_meals_daily',
      'eat_out_per_week',
      'sugary_drinks',
      'dietary_suplements',
      'daily_stress_level',
      'sleep_quality',
      'activity_level',
    ];

    for (var field in fieldsToCheck) {
      if (_userData![field] == null ||
          _userData![field] is List && (_userData![field] as List).isEmpty) {
        return field;
      }
    }

    return null; // All fields are completed
  }

  // Add this method to your _HomeScreenState class
  Widget? _getScreenForField(String fieldName) {
    final fieldValue = _userData![fieldName];

    switch (fieldName) {
      case 'primary_goal':
        return PrimaryGoal(
          initialPrimaryGoal: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'sport_do_you_practice':
        return SportPracticeScreen(
          initialSportPractice: fieldValue is List
              ? fieldValue.cast<String>()
              : [fieldValue.toString()],
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'body_composition_goal':
        return BodyCompostionGoal(
          initialBodyCompositionGoal: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'priority_in_well_being':
        return PriorityInWellBeing(
          initialPriorityInWellBeing: fieldValue is List
              ? fieldValue.cast<String>()
              : [fieldValue.toString()],
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'risks':
        return Risk(
          initialRisks: fieldValue is List
              ? fieldValue.cast<String>()
              : [fieldValue.toString()],
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'dietary_restrictions_or_allergies':
        return DietaryRestrictionsAllergies(
          initialDietaryRestrictions: fieldValue is List
              ? fieldValue.cast<String>()
              : [fieldValue.toString()],
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'meals_consume_daily':
        return MealsConsumeDaily(
          initialMealsConsumeDaily: fieldValue is List
              ? fieldValue.cast<String>()
              : [fieldValue.toString()],
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'alcohalic_beverages':
        return AlcohlicBeverges(
          initialAlcoholicBeverages: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'time_spend_eating_your_meals_daily':
        return EatingYourMeals(
          initialEatingYourMeals: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'time_spend_preparing_meals_daily':
        return PreparingYourMealsDaily(
          initialPreparingYourMealsDaily: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'eat_out_per_week':
        return EatOutPerWeek(
          initialEatOutPerWeek: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'sugary_drinks':
        return SugaryDrinks(
          initialSugaryDrinks: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'dietary_suplements':
        return DietarySupplements(
          initialDietarySupplements: fieldValue is List
              ? fieldValue.cast<String>()
              : [fieldValue.toString()],
          eatOutPerWeek: _userData!['eat_out_per_week'],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'daily_stress_level':
        return StressLevel(
          initialStressLevel: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'sleep_quality':
        return SleepQualityScreen(
          initialSleepQuality: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'activity_level':
        return ActivityLevelSelectionScreen(
          initialActivityLevel: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'dob':
        return BirthdaySelectionScreen(
          initialDate: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'gender':
        return GenderSelectionScreen(
          initialGender: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
          // 'dob',
          // 'gender',
          // 'height',
          // 'weight',
          // 'primary_goal',
          // 'sport_do_you_practice',
          // 'body_composition_goal',
          // 'priority_in_well_being',
          // 'risks',
          // 'dietary_restrictions_or_allergies',
          // 'meals_consume_daily',
          // 'alcohalic_beverages',
          // 'time_spend_eating_your_meals_daily',
          // 'time_spend_preparing_meals_daily',
          // 'eat_out_per_week',
          // 'sugary_drinks',
          // 'dietary_suplements',
          // 'daily_stress_level',
          // 'sleep_quality',
          // 'activity_level',
        );

      case 'height':
        return HeightSelectionScreen(
          initialHeight: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      case 'weight':
        return WeightSelectionScreen(
          initialWeight: fieldValue,
          eatOutPerWeek: _userData!['eat_out_per_week'],
          initialDietarySupplements: _userData!['dietary_suplements'] != null
              ? (_userData!['dietary_suplements'] as List).cast<String>()
              : [],
          timeSpendPreparingYourMealsDaily:
              _userData!['time_spend_preparing_meals_daily'],
          selectedActivity: _userData!['activity_level'],
          selectedAlcoholicBeverages: _userData!['alcohalic_beverages'],
          selectedBodyCompositionGoal: _userData!['body_composition_goal'],
          selectedDailyStressLevel: _userData!['daily_stress_level'],
          selectedDate: _userData!['dob'],
          selectedDietaryRestrictions:
              _userData!['dietary_restrictions_or_allergies'] != null
                  ? (_userData!['dietary_restrictions_or_allergies'] as List)
                      .cast<String>()
                  : [],
          selectedEatingYourMeals:
              _userData!['time_spend_eating_your_meals_daily'],
          selectedGender: _userData!['gender'],
          selectedHeight: _userData!['height'],
          selectedLifeStyleAndSleepQuality: _userData!['sleep_quality'],
          selectedMeals: _userData!['meals_consume_daily'] != null
              ? (_userData!['meals_consume_daily'] as List).cast<String>()
              : [],
          selectedPrimaryGoal: _userData!['primary_goal'],
          selectedPrioritiesinWellBeing: _userData!['priority_in_well_being'] !=
                  null
              ? (_userData!['priority_in_well_being'] as List).cast<String>()
              : [],
          selectedRisks: _userData!['risks'] != null
              ? (_userData!['risks'] as List).cast<String>()
              : [],
          selectedTypesofSportsPracticed:
              _userData!['sport_do_you_practice'] != null
                  ? (_userData!['sport_do_you_practice'] as List).cast<String>()
                  : [],
          selectedWeight: _userData!['weight'],
          sugaryDrinks: _userData!['sugary_drinks'],
        );

      default:
        return null;
    }
  }

  DateTime _selectedDate = DateTime.now(); // Store the selected date
  // Function to show the calendar
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff707070), // Calendar header color
              onPrimary: Colors.white, // Text color on header
              onSurface: Colors.black, // Text color for dates
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xff707070), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // TODO: Fetch meal data for the selected date from API
        // For now, we'll keep the mock data
        // Example: _fetchMealData(picked);
      });
    }
  }

  // Show the nutrition details dialog
  void _showNutritionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today's Nutrition",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    // Daily Summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Summary',
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '1850 / 2000 kcal',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(10),
                      value: 1850 / 2000,
                      backgroundColor: const Color(0xffDCDCDC),
                      color: const Color(0xff707070),
                      minHeight: 1.2.h,
                    ),
                    SizedBox(height: 2.h),
                    // Nutrition Circles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNutritionCircle('Protein', '120g', 0.65),
                        _buildNutritionCircle('Carbs', '200g', 0.80),
                        _buildNutritionCircle('Lipids', '55g', 0.45),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Meals',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    // Breakfast
                    ExpansionTile(
                      title: Text(
                        'Breakfast',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      initiallyExpanded: true,
                      collapsedIconColor: Colors.black,
                      iconColor: Colors.black,
                      children: [
                        _buildMealItem(
                            'Greek Yogurt', '130 cal', '15g', '8g', '4g'),
                        _buildMealItem(
                            'Blueberries', '85 cal', '1g', '21g', '0g'),
                        _buildMealItem('Granola', '120 cal', '3g', '20g', '5g'),
                      ],
                    ),
                    // Lunch
                    ExpansionTile(
                      title: Text(
                        'Lunch',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      collapsedIconColor: Colors.black,
                      iconColor: Colors.black,
                      children: [
                        _buildMealItem(
                            'Grilled Chicken', '450 cal', '40g', '5g', '10g'),
                        _buildMealItem('Salad', '150 cal', '2g', '15g', '8g'),
                      ],
                    ),
                    // Dinner
                    ExpansionTile(
                      title: Text(
                        'Dinner',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      collapsedIconColor: Colors.black,
                      iconColor: Colors.black,
                      children: [
                        _buildMealItem(
                            'Steamed Fish', '300 cal', '25g', '0g', '5g'),
                        _buildMealItem('Veggies', '100 cal', '2g', '15g', '1g'),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    // Close Button
                    Center(
                      child: SizedBox(
                        width: 88.5.w,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Close',
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget for each meal item (e.g., Greek Yogurt, Blueberries)
  Widget _buildMealItem(
      String name, String calories, String protein, String carbs, String fats) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                calories,
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Proteins: $protein',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  color: const Color(0xffA2A2A2),
                ),
              ),
              Text(
                'Calories: $carbs',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  color: const Color(0xffA2A2A2),
                ),
              ),
              Text(
                'Fats: $fats',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  color: const Color(0xffA2A2A2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Row(
                  children: [
                    FutureBuilder<bool>(
                      future: _imageExists(imageUrl != null &&
                              imageUrl!.isNotEmpty
                          ? (imageUrl!.startsWith('http')
                              ? imageUrl!
                              : "https://c502-39-60-230-244.ngrok-free.app${imageUrl!.startsWith('/') ? imageUrl : '/$imageUrl'}")
                          : ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // 🛜 While checking, show shimmer
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: CircleAvatar(
                              radius: 6.5.w,
                              backgroundColor: Colors.grey[300],
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data == true) {
                          // ✅ Image exists, show image
                          return CircleAvatar(
                            radius: 6.5.w,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(
                              "https://c502-39-60-230-244.ngrok-free.app$imageUrl",
                            ),
                          );
                        } else {
                          // 🚫 Image not found, show username initial
                          return CircleAvatar(
                            radius: 6.5.w,
                            backgroundColor: Colors.grey[300],
                            child: Text(
                              username.isNotEmpty
                                  ? username[0].toUpperCase()
                                  : '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      // Wrap in Expanded to prevent overflow
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back!',
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp, color: Color(0xff000000)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          FutureBuilder<String>(
                            future: _getUsername(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  'Loading...',
                                  style: GoogleFonts.roboto(
                                    fontSize: 18.5.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error',
                                  style: GoogleFonts.roboto(
                                    fontSize: 18.5.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              } else {
                                return Text(
                                  snapshot.data ?? 'User',
                                  style: GoogleFonts.roboto(
                                    fontSize: 18.5.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Image.asset(
                      'assests/home_screen/bell_icon.png',
                      // height: 22.sp,
                      // width: 22.sp,
                    ),
                  ],
                ),
              ),

              // Profile Completion Section
              // Replace your current Profile Completion Section with this:
              "${100 - (5 * _nullCount)}" == "100"
                  ? SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: GestureDetector(
                        onTap: () {
                          if (_isLoading)
                            return; // Don't allow clicks while loading

                          final firstNullField = _getFirstNullField();
                          if (firstNullField == null) {
                            // All fields are completed
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Your profile is already complete!')),
                            );
                            return;
                          }

                          final screen = _getScreenForField(firstNullField);
                          if (screen != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => screen),
                            ).then((_) {
                              // Refresh data when returning from the onboarding screen
                              _fetchUserIdAndData();
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Error: Unknown field $firstNullField')),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F1F1F),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Complete your profile',
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3.w, vertical: 0.3.h),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            '${100 - (5 * _nullCount)}% Complete',
                                            style: GoogleFonts.roboto(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.h),
                                    LinearProgressIndicator(
                                      borderRadius: BorderRadius.circular(10),
                                      value:
                                          (1 / 100) * (100 - (5 * _nullCount)),
                                      backgroundColor: Color(0xffFFFFFF),
                                      color: Color(0xff707070),
                                      minHeight: 1.h,
                                    ),
                                    SizedBox(height: 1.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Complete profile',
                                          style: GoogleFonts.roboto(
                                              color: Color(0xffFFFFFF),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '$_nullCount steps remaining',
                                          style: GoogleFonts.roboto(
                                              color: Color(0xffFFFFFF),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

              // Let's Cook Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A4A4A),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff404B52),
                          Color(0xff979797),
                        ]),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 50.w,
                              child: Text(
                                maxLines: 3,
                                "Let's cook your breakfast/lunch/dinner",
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            SizedBox(
                              width: 50.w,
                              child: Text(
                                maxLines: 3,
                                'AI-generated recipes customized to your taste and diet.',
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 14.5.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return QuestionOneScreen();
                                  },
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 1.2.h),
                              ),
                              child: Text(
                                'Create Now!',
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 14.5.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Container(
                        color: Colors.transparent, // Placeholder if image fails
                        child: Image.asset(
                          scale: 1,
                          'assests/home_screen/delicious-food.png', // Replace with actual image path
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                                child: Text('Image not found',
                                    style:
                                        GoogleFonts.roboto(fontSize: 12.sp)));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // // What would you like to cook today? Section
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 5.w),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         padding: EdgeInsets.all(3.w),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(15),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(0.2),
              //               spreadRadius: 2,
              //               blurRadius: 5,
              //             ),
              //           ],
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               'What would you like to cook today?',
              //               style: GoogleFonts.roboto(
              //                   fontSize: 16.sp,
              //                   color: Color(0xff1F1F1F),
              //                   fontWeight: FontWeight.w500),
              //               overflow: TextOverflow.ellipsis,
              //             ),
              //             SizedBox(height: 0.5.h),
              //             Text(
              //               'Select on recipe for your next meal?',
              //               style: GoogleFonts.roboto(
              //                   fontSize: 13.5.sp,
              //                   color: Color(0xff707070),
              //                   fontWeight: FontWeight.w500),
              //               overflow: TextOverflow.ellipsis,
              //             ),
              //             SizedBox(height: 1.h),
              //             _buildRecipeCard(
              //               'Grilled Chicken Salad',
              //               '380 kcal - 15 min',
              //               ['Low Carb', 'High Protein'],
              //               'assests/home_screen/chicken_salad.png', // Replace with actual image path
              //             ),
              //             const Divider(),
              //             _buildRecipeCard(
              //               'Grilled Chicken Salad',
              //               '380 kcal - 15 min',
              //               ['Low Carb', 'High Protein'],
              //               'assests/home_screen/chicken_salad.png', // Replace with actual image path
              //             ),
              //             const Divider(),
              //             _buildRecipeCard(
              //               'Sweet Potato',
              //               '420 kcal - 20 min',
              //               ['Plant-based', 'Fiber-rich'],
              //               'assests/home_screen/chicken_salad.png', // Replace with actual image path
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
// Meal Summary Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Meal Summary',
                                style: GoogleFonts.roboto(
                                    fontSize: 16.5.sp,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () => _selectDate(context),
                                  icon: Icon(
                                    Icons.calendar_month_outlined,
                                    color: Color(0xff707070),
                                  )),
                              GestureDetector(
                                onHorizontalDragEnd: (details) {
                                  setState(() {
                                    _isTodaySelected =
                                        details.primaryVelocity! > 0;
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    _isTodaySelected = !_isTodaySelected;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.5.h, horizontal: 1.w),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildTabButton(
                                          'Yesterday', !_isTodaySelected),
                                      SizedBox(width: 2.w),
                                      _buildTabButton(
                                          'Today', _isTodaySelected),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xffE5E9EF)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.w),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 1.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: Color(0xffF9FAFB),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: _buildMealSummaryRow(
                                    mealKey: 'breakfast',
                                    meal: 'Breakfast',
                                    status: 'Completed',
                                    time: '08:30 AM',
                                    foods: [
                                      {
                                        'name': 'Oatmeal with berries',
                                        'calories': '320 kcal'
                                      },
                                      {
                                        'name': 'Greek yogurt',
                                        'calories': '100 kcal'
                                      },
                                    ],
                                    isCompleted: true,
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.w),
                                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                                  decoration: BoxDecoration(
                                    color: Color(0xffF9FAFB),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: _buildMealSummaryRow(
                                    mealKey: 'lunch',
                                    meal: 'Lunch',
                                    status: 'Completed',
                                    time: '12:45',
                                    foods: [
                                      {
                                        'name': 'Grilled chicken',
                                        'calories': '450 kcal'
                                      },
                                      {'name': 'Salad', 'calories': '150 kcal'},
                                    ],
                                    isCompleted: true,
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.w),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 1.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: Color(0xffF9FAFB),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: _buildMealSummaryRow(
                                    mealKey: 'dinner',
                                    meal: 'Dinner',
                                    status: 'Upcoming',
                                    time: '07:00',
                                    foods: [
                                      {
                                        'name': 'Steamed fish',
                                        'calories': '300 kcal'
                                      },
                                      {
                                        'name': 'Veggies',
                                        'calories': '100 kcal'
                                      },
                                    ],
                                    isCompleted: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // My Nutrition Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Today’s Nutrition',
                                style: GoogleFonts.roboto(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              InkWell(
                                onTap: () {
                                  _showNutritionDialog(
                                      context); // Open dialog on tap
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'View Details',
                                    style: GoogleFonts.roboto(
                                        color: Colors.white, fontSize: 14.sp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Calories',
                                style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '1450 / 2000 kcal',
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(10),
                            value: 1450 / 2000,
                            backgroundColor: Color(0xffDCDCDC),
                            color: Color(0xff707070),
                            minHeight: 1.h,
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildNutritionCircle('Protein', '120g', 0.65),
                              _buildNutritionCircle('Carbs', '200g', 0.80),
                              _buildNutritionCircle('Lipids', '55g', 0.45),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // AI Nutritionist Section
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'AI Nutritionist',
              //         style: GoogleFonts.roboto(
              //             fontSize: 18.sp, fontWeight: FontWeight.bold),
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       SizedBox(height: 2.h),
              //       Container(
              //         padding: EdgeInsets.all(3.w),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(15),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(0.2),
              //               spreadRadius: 2,
              //               blurRadius: 5,
              //             ),
              //           ],
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               'Your personal AI Nutrition assistant is ready to answer questions and provide guidance tailored to your goals.',
              //               style: GoogleFonts.roboto(
              //                   fontSize: 14.sp, color: Colors.grey),
              //               overflow: TextOverflow.ellipsis,
              //             ),
              //             SizedBox(height: 2.h),
              //             ElevatedButton(
              //               onPressed: () {
              //                 Navigator.push(context, MaterialPageRoute(
              //                   builder: (context) {
              //                     return AskNutriAi();
              //                   },
              //                 ));
              //                 print('Ask Nutri AI tapped');
              //               },
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: Colors.black,
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(20),
              //                 ),
              //                 padding: EdgeInsets.symmetric(vertical: 1.5.h),
              //                 minimumSize: Size(double.infinity, 0),
              //               ),
              //               child: Text(
              //                 'Ask Nutri AI',
              //                 style: GoogleFonts.roboto(
              //                     color: Colors.white, fontSize: 16.sp),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // My Pantry Section
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'My Pantry',
              //         style: GoogleFonts.roboto(
              //             fontSize: 18.sp, fontWeight: FontWeight.bold),
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       SizedBox(height: 2.h),
              //       Container(
              //         padding: EdgeInsets.all(3.w),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(15),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(0.2),
              //               spreadRadius: 2,
              //               blurRadius: 5,
              //             ),
              //           ],
              //         ),
              //         child: Column(
              //           children: [
              //             _buildPantryItem(
              //                 'Spinach',
              //                 '1 bunch',
              //                 'Vegetables',
              //                 'assets/spinach.png',
              //                 true), // Replace with actual image path
              //             _buildPantryItem(
              //                 'Chicken Breast',
              //                 '1 lb',
              //                 'Chicken',
              //                 'assets/chicken_breast.png',
              //                 true), // Replace with actual image path
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Food Preferences Section
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Food Preferences',
              //         style: GoogleFonts.roboto(
              //             fontSize: 18.sp, fontWeight: FontWeight.bold),
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       SizedBox(height: 2.h),
              //       Container(
              //         padding: EdgeInsets.all(3.w),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(15),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(0.2),
              //               spreadRadius: 2,
              //               blurRadius: 5,
              //             ),
              //           ],
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               'Foods you like',
              //               style: GoogleFonts.roboto(
              //                   fontSize: 16.sp, fontWeight: FontWeight.bold),
              //               overflow: TextOverflow.ellipsis,
              //             ),
              //             SizedBox(height: 1.h),
              //             TextField(
              //               decoration: InputDecoration(
              //                 hintText: 'Search foods you enjoy',
              //                 hintStyle: GoogleFonts.roboto(
              //                     fontSize: 14.sp, color: Colors.grey),
              //                 prefixIcon: Icon(Icons.search, size: 20.sp),
              //                 border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(30),
              //                   borderSide: BorderSide.none,
              //                 ),
              //                 filled: true,
              //                 fillColor: Colors.grey[200],
              //               ),
              //             ),
              //             SizedBox(height: 1.h),
              //             Wrap(
              //               spacing: 2.w,
              //               children: _likedFoods
              //                   .map((food) => Chip(
              //                         label: Text(food,
              //                             style: GoogleFonts.roboto(
              //                                 fontSize: 14.sp)),
              //                         deleteIcon:
              //                             const Icon(Icons.close, size: 16),
              //                         onDeleted: () {
              //                           setState(() {
              //                             _likedFoods.remove(food);
              //                           });
              //                         },
              //                       ))
              //                   .toList(),
              //             ),
              //             SizedBox(height: 2.h),
              //             Text(
              //               'Foods to avoid',
              //               style: GoogleFonts.roboto(
              //                   fontSize: 16.sp, fontWeight: FontWeight.bold),
              //               overflow: TextOverflow.ellipsis,
              //             ),
              //             SizedBox(height: 1.h),
              //             TextField(
              //               decoration: InputDecoration(
              //                 hintText: 'Search foods to avoid',
              //                 hintStyle: GoogleFonts.roboto(
              //                     fontSize: 14.sp, color: Colors.grey),
              //                 prefixIcon: Icon(Icons.search, size: 20.sp),
              //                 border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(30),
              //                   borderSide: BorderSide.none,
              //                 ),
              //                 filled: true,
              //                 fillColor: Colors.grey[200],
              //               ),
              //             ),
              //             SizedBox(height: 1.h),
              //             Wrap(
              //               spacing: 2.w,
              //               children: _avoidFoods
              //                   .map((food) => Chip(
              //                         label: Text(food,
              //                             style: GoogleFonts.roboto(
              //                                 fontSize: 14.sp)),
              //                         deleteIcon:
              //                             const Icon(Icons.close, size: 16),
              //                         onDeleted: () {
              //                           setState(() {
              //                             _avoidFoods.remove(food);
              //                           });
              //                         },
              //                       ))
              //                   .toList(),
              //             ),
              //             SizedBox(height: 1.h),
              //             Text(
              //               'Mark items with the allergen icon to exclude them completely',
              //               style: GoogleFonts.roboto(
              //                   fontSize: 12.sp, color: Colors.grey),
              //               overflow: TextOverflow.ellipsis,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Diet Preferences Section
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Diet Preference',
              //         style: GoogleFonts.roboto(
              //             fontSize: 18.sp, fontWeight: FontWeight.bold),
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       SizedBox(height: 2.h),
              //       Container(
              //         padding: EdgeInsets.all(3.w),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(15),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(0.2),
              //               spreadRadius: 2,
              //               blurRadius: 5,
              //             ),
              //           ],
              //         ),
              //         child: SingleChildScrollView(
              //           scrollDirection: Axis.horizontal,
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Row(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   _buildDietCheckbox('Vegetarian', 0),
              //                   _buildDietCheckbox('Vegan', 1),
              //                 ],
              //               ),
              //               Row(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   _buildDietCheckbox('Gluten Free', 2),
              //                   _buildDietCheckbox('Dairy Free', 3),
              //                 ],
              //               ),
              //               Row(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   _buildDietCheckbox('Keto', 4),
              //                   _buildDietCheckbox('Low Carb', 5),
              //                 ],
              //               ),
              //               Row(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   _buildDietCheckbox('Low Sodium', 6),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // SizedBox(height: 10.h), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(
      String title, String details, List<String> tags, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            color: Colors.grey[300], // Placeholder if image fails
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                    child: Text('Image not found',
                        style: GoogleFonts.roboto(fontSize: 12.sp)));
              },
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1F1F1F)),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  details,
                  style: GoogleFonts.roboto(
                      fontSize: 13.5.sp,
                      color: Color(0xff707070),
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  children: tags
                      .map((tag) => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.3.h),
                            decoration: BoxDecoration(
                              color: Color(0xff000000),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.roboto(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffFFFFFF)),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildMealSummaryRow({
    required String mealKey,
    required String meal,
    required String status,
    required String time,
    required List<Map<String, String>> foods,
    required bool isCompleted,
  }) {
    final isExpanded = _expandedMealKey == mealKey;
    final isUpcoming = status == 'Upcoming';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.h),
                      child: Icon(
                        Icons.circle,
                        size: 14.sp,
                        color: isCompleted
                            ? Color(0xff1F1F1F)
                            : isUpcoming
                                ? Color(0xff646464)
                                : Color(0xff646464),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    SizedBox(
                      width: 20.w,
                      child: Text(
                        meal,
                        style: GoogleFonts.roboto(
                            fontSize: 15.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      // width: 20.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.7.h),
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.black : Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            isCompleted
                                ? Icon(Icons.verified_outlined,
                                    color: Colors.white, size: 15.sp)
                                : Icon(Icons.access_time_rounded,
                                    color: Colors.white, size: 15.sp),
                            SizedBox(width: 1.w),
                            Text(
                              status,
                              style: GoogleFonts.roboto(
                                fontSize: 13.5.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _expandedMealKey = isExpanded ? null : mealKey;
                        });
                      },
                      child: Icon(
                        isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),
                if (isExpanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: foods
                        .map(
                          (food) => Padding(
                            padding: EdgeInsets.only(top: 0.8.h, left: 1.w),
                            child: Column(
                              children: [
                                if (food == foods[0])
                                  Divider(
                                    color: Color(0xffDCDCDC),
                                  ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      food['name'] ?? '',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.sp,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3.w, vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        food['calories'] ?? '',
                                        style: GoogleFonts.roboto(
                                          fontSize: 13.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCircle(String label, String value, double progress) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 16.w, // Reduced width
                height: 16.w, // Reduced height
                child: CircularProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFFD8D8D8),
                  color: const Color(0xFF5E5E5E),
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round, // Rounded ends
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    value,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPantryItem(String name, String quantity, String category,
      String imagePath, bool isLiked) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            color: Colors.grey[300], // Placeholder if image fails
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                    child: Text('Image not found',
                        style: GoogleFonts.roboto(fontSize: 12.sp)));
              },
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.roboto(
                      fontSize: 16.sp, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  quantity,
                  style:
                      GoogleFonts.roboto(fontSize: 14.sp, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  category,
                  style:
                      GoogleFonts.roboto(fontSize: 14.sp, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.blue : Colors.grey,
              size: 20.sp,
            ),
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 20.sp, color: Colors.grey),
            onPressed: () {
              print('Delete $name from pantry');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDietCheckbox(String label, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _dietPreferences[index],
          onChanged: (bool? value) {
            setState(() {
              _dietPreferences[index] = value ?? false;
            });
          },
        ),
        Text(
          label,
          style: GoogleFonts.roboto(fontSize: 14.sp),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
