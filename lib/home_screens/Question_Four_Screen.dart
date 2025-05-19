// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, avoid_print

import 'package:carl/api/api_service.dart';
import 'package:carl/home_screens/explore_recipe.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionFourScreen extends StatefulWidget {
  final String time;
  final String people;
  final String food;
  const QuestionFourScreen({
    super.key,
    required this.time,
    required this.people,
    required this.food,
  });

  @override
  State<QuestionFourScreen> createState() => _QuestionFourScreenState();
}

class _QuestionFourScreenState extends State<QuestionFourScreen> {
  final Map<String, double> _imageData = {
    //{name: abdullah, image: http://q},
    'https://images.unsplash.com/photo-1540420773420-3366772f4999?q=80&w=3084&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D':
        1.0,
    'https://images.unsplash.com/photo-1535229398509-70179087ac75?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D':
        2.0,
    'https://images.unsplash.com/photo-1576021182211-9ea8dced3690?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D':
        1.5,
    'https://images.unsplash.com/photo-1546793665-c74683f339c1?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D':
        2.0,
    'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D':
        1.0,
    'https://images.unsplash.com/photo-1606756790138-261d2b21cd75?q=80&w=3165&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D':
        1.5,
    'https://images.unsplash.com/photo-1610441009633-b6ca9c6d4be2?q=80&w=2600&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D':
        2.0,
    'https://images.unsplash.com/photo-1543362906-acfc16c67564?q=80&w=3165&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D':
        1.0,
    'https://images.unsplash.com/photo-1543364195-bfe6e4932397?q=80&w=3165&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D':
        2.0,
    'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=3110&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D':
        1.0,
    'https://images.unsplash.com/photo-1572357176061-7c96fd2af22f?q=80&w=3135&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D':
        1.5,
  };

  String? _selectedImageUrl;
  var allData;
  var foodPrefsData; // New variable to store food preferences data
  bool _isLoading = true;
  bool _isGenerating = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final Logger logger = Logger(); // Initialize logger

  @override
  void initState() {
    super.initState();
    print('Haasan Bhia Init State Chl rhi ha');
    getAllData();
  }

  @override
  void dispose() {
    _scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
    super.dispose();
  }

  Future<void> getAllData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user');
      if (userJson == null) {
        throw Exception('User data not found in SharedPreferences');
      }

      // Fetch user data
      allData = await ApiService().getAllUserData(context);
      logger.d('User Data: $allData');

      // Fetch food preferences data
      foodPrefsData = await ApiService().foodPrefrenceGetAllData(context);
      logger.d('Food Preferences Data: $foodPrefsData');

      if (foodPrefsData == null ||
          foodPrefsData['data'] == null ||
          foodPrefsData['data'].isEmpty) {
        throw Exception('No food preferences data found');
      }
    } catch (e) {
      print('Error loading data: $e');
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Failed to load data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<MapEntry<String, double>> leftImages = [];
    List<MapEntry<String, double>> rightImages = [];

    _imageData.entries.toList().asMap().forEach((index, entry) {
      if (index % 2 == 0) {
        leftImages.add(entry);
      } else {
        rightImages.add(entry);
      }
    });

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: const Color(0xFFEBEBEB),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: 100.h,
                color: const Color(0xFFEBEBEB),
              ),
              Container(
                height: 13.h,
                decoration: const BoxDecoration(
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
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.only(left: 1.w),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, size: 17.sp),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.only(left: 2.w, right: 2.w),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Do you have a craving for a particular type of cuisine?",
                        style: GoogleFonts.roboto(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: leftImages.length,
                            itemBuilder: (context, index) {
                              String imageUrl = leftImages[index].key;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImageUrl = imageUrl;
                                    });
                                    print('Tapped image URL: $imageUrl');
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 191,
                                        height: 265,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                              child: Text(
                                                'Error loading image',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      if (_selectedImageUrl == imageUrl)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: rightImages.length,
                            itemBuilder: (context, index) {
                              String imageUrl = rightImages[index].key;
                              double height;
                              if (index == 0 ||
                                  index == 2 ||
                                  index == 3 ||
                                  index == 5) {
                                height = 303;
                              } else {
                                height = 159;
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImageUrl = imageUrl;
                                    });
                                    print('Tapped image URL: $imageUrl');
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 184,
                                        height: height,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                              child: Text(
                                                'Error loading image',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      if (_selectedImageUrl == imageUrl)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    child: ElevatedButton(
                      onPressed: _isGenerating
                          ? null
                          : () async {
                              if (_selectedImageUrl == null) {
                                _scaffoldMessengerKey.currentState
                                    ?.showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please select an image first!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (allData == null) {
                                _scaffoldMessengerKey.currentState
                                    ?.showSnackBar(
                                  const SnackBar(
                                    content: Text('User data not loaded yet!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (foodPrefsData == null) {
                                _scaffoldMessengerKey.currentState
                                    ?.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Food preferences not loaded yet!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                _isGenerating = true;
                              });

                              try {
                                final userData = {
                                  "user_data": {
                                    "weight":
                                        allData['weight']?.toString() ?? 'N/A',
                                    "height":
                                        allData['height']?.toString() ?? 'N/A',
                                    "gender":
                                        allData['gender']?.toString() ?? 'N/A',
                                    "dob": allData['dob']?.toString() ?? 'N/A',
                                    "activity_level":
                                        allData['activity_level']?.toString() ??
                                            'N/A',
                                    "sleep_quality":
                                        allData['sleep_quality']?.toString() ??
                                            'N/A',
                                    "daily_stress_level":
                                        allData['daily_stress_level']
                                                ?.toString() ??
                                            'N/A',
                                    "dietary_supplements": _ensureList(
                                        allData['dietary_suplements']),
                                    "sugary_drinks":
                                        allData['sugary_drinks']?.toString() ??
                                            'N/A',
                                    "eat_out_per_week":
                                        allData['eat_out_per_week']
                                                ?.toString() ??
                                            'N/A',
                                    "time_spend_preparing_meals_daily":
                                        widget.time,
                                    "time_spend_eating_your_meals_daily":
                                        allData['time_spend_eating_your_meals_daily']
                                                ?.toString() ??
                                            'N/A',
                                    "alcohalic_beverages":
                                        allData['alcohalic_beverages']
                                                ?.toString() ??
                                            'N/A',
                                    "meals_consume_daily": _ensureList(
                                        allData['meals_consume_daily']),
                                    "dietary_restrictions_or_allergies":
                                        _ensureList(allData[
                                            'dietary_restrictions_or_allergies']),
                                    "risks": _ensureList(allData['risks']),
                                    "priority_in_well_being": _ensureList(
                                        allData['priority_in_well_being']),
                                    "sport_do_you_practice": _ensureList(
                                        allData['sport_do_you_practice']),
                                    "body_composition_goal":
                                        allData['body_composition_goal']
                                                ?.toString() ??
                                            'N/A',
                                    "primary_goal":
                                        allData['primary_goal']?.toString() ??
                                            'N/A'
                                  },
                                  "quick_questions": {
                                    "How_much_time_do_you_have_to_cook":
                                        widget.time,
                                    "How_many_people_did_you_want_to_cook_for":
                                        widget.people,
                                    "How_healthy_do_you_want_your_meal_to_be":
                                        widget.food
                                  },
                                  "food_preferences": {
                                    "foods_you_like": foodPrefsData['data'][0]
                                            ['foods_you_like'] ??
                                        [],
                                    "foods_to_Avoid": foodPrefsData['data'][0]
                                            ['foods_to_Avoid'] ??
                                        [],
                                    "dietary_Preferences": foodPrefsData['data']
                                            [0]['dietary_Preferences'] ??
                                        []
                                  }
                                };

                                final aiRecipesData = await ApiService()
                                    .generateRecipes(userData);

                                if (aiRecipesData == null ||
                                    aiRecipesData.isEmpty) {
                                  _scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'No recipes generated. Please try again.'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                _scaffoldMessengerKey.currentState
                                    ?.showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Recipes generated successfully!'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 1),
                                  ),
                                );

                                await Future.delayed(
                                    const Duration(seconds: 1));

                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExploreRecipe(
                                          ai_recipes_data: aiRecipesData),
                                    ),
                                  );
                                }
                              } catch (e) {
                                _scaffoldMessengerKey.currentState
                                    ?.showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Failed to generate recipes: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    _isGenerating = false;
                                  });
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color(0xff1F1F1F),
                      ),
                      child: _isGenerating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Generate',
                              style: GoogleFonts.roboto(
                                fontSize: 17.sp,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to ensure a value is a list
  List<String> _ensureList(dynamic value) {
    if (value == null) {
      return [];
    }
    if (value is List) {
      return value.cast<String>();
    }
    if (value is String) {
      if (value.toLowerCase() == 'n/a' || value.isEmpty) {
        return [];
      }
      return value.split(',').map((e) => e.trim()).toList();
    }
    return [];
  }
}
