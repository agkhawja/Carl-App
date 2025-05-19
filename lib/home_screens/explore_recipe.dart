// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, non_constant_identifier_names, avoid_print, prefer_iterable_wheretype, unnecessary_type_check, unused_element

import 'dart:convert';
import 'package:carl/api/api_service.dart';
import 'package:carl/generated_results_log_recepies/recipe_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ExploreRecipe extends StatefulWidget {
  final Map<String, dynamic>? ai_recipes_data;
  const ExploreRecipe({
    super.key,
    this.ai_recipes_data,
  });

  @override
  _ExploreRecipeState createState() => _ExploreRecipeState();
}

class _ExploreRecipeState extends State<ExploreRecipe> {
  int _currentRecipeIndex = 0;
  List<Map<String, dynamic>> _recipes = [];
  List<Map<String, dynamic>> _recipeImages = [];
  bool _isLoadingImages = true;
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    Logger logger = Logger();
    print('Start of Data');
    logger.d(widget.ai_recipes_data);
    print('End of Data');

    // Handle the API response structure
    if (widget.ai_recipes_data != null) {
      _recipes = widget.ai_recipes_data!.values
          .where((recipe) => recipe is Map)
          .map((recipe) => (recipe as Map).cast<String, dynamic>())
          .toList();
      print('Parsed recipes: $_recipes');
    }

    // Fetch recipe images
    _fetchRecipeImages();
  }

  Future<void> _fetchRecipeImages() async {
    setState(() {
      _isLoadingImages = true;
    });
    try {
      final List<Map<String, dynamic>> images =
          await ApiService().getAIRecipesImages(context);
      print('Raw images response: $images');
      print('Images type: ${images.runtimeType}');
      if (mounted) {
        setState(() {
          _recipeImages = images;
          _isLoadingImages = false;
        });
        print('Recipe images loaded: $_recipeImages');
      }
    } catch (e) {
      print('Error fetching recipe images: $e');
      if (mounted) {
        setState(() {
          _isLoadingImages = false;
        });
        _messengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('Unable to load recipe images. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure _currentRecipeIndex is within bounds
    if (_recipes.isNotEmpty && _currentRecipeIndex >= _recipes.length) {
      _currentRecipeIndex = 0;
    }

    Map<String, dynamic>? currentRecipe;
    if (_recipes.isNotEmpty) {
      print("_currentRecipeIndex: $_currentRecipeIndex");
      print("currentRecipe $_recipes");

      currentRecipe = _recipes[_currentRecipeIndex];
      print("hassan:=>........${currentRecipe['Recipe Title']}");
    }

    // Find matching image for current recipe
    String? recipeImageData;
    final recipeName = currentRecipe?['Recipe Name'] as String?;
    if (recipeName != null) {
      final matchingImage = _recipeImages.firstWhere(
        (img) =>
            img['recipe_name']?.toString().trim().toLowerCase() ==
            recipeName.toLowerCase().trim(),
        orElse: () => {},
      );
      recipeImageData = matchingImage['image'] as String?;
      print('Matched image for $recipeName: $recipeImageData');
    }

    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
        backgroundColor: const Color(0xFFEBEBEB),
        appBar: AppBar(
          backgroundColor: const Color(0xffFFFFFF),
          automaticallyImplyLeading: true,
          title: Text(
            "Explore Recipes",
            style: GoogleFonts.roboto(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 100.h,
                  color: const Color(0xFFEBEBEB),
                ),
                Container(
                  height: 24.h,
                  decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        currentRecipe != null &&
                                currentRecipe['Recipe Name'] != null
                            ? currentRecipe['Recipe Name']
                            : 'No Recipe Available',
                        style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff0A0615),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        textAlign: TextAlign.center,
                        currentRecipe != null &&
                                currentRecipe['Recipe Title'] != null
                            ? currentRecipe['Recipe Title']
                            : 'No Description Available',
                        style: GoogleFonts.roboto(
                          color: const Color(0xff707070),
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () {
                          if (currentRecipe == null) {
                            _messengerKey.currentState?.showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'No recipe data available to navigate'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }
                          Logger logger = Logger();
                          logger.d(currentRecipe);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return RecipeScreen(
                                ai_one_recipes_detail_data: currentRecipe,
                                recipe_Image: recipeImageData,
                              );
                            },
                          ));
                        },
                        child: Center(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: _buildRecipeImage(recipeImageData),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _IconTile(
                            Icons.ramen_dining,
                            currentRecipe != null &&
                                    currentRecipe['Recipe Difficulty'] != null
                                ? currentRecipe['Recipe Difficulty']
                                : 'N/A',
                          ),
                          _IconTile(
                            Icons.euro,
                            currentRecipe != null &&
                                    currentRecipe['Budget Category'] != null
                                ? currentRecipe['Budget Category']
                                : 'N/A',
                          ),
                          _IconTile(
                            Icons.star,
                            currentRecipe != null &&
                                    currentRecipe['Rating'] != null
                                ? currentRecipe['Rating']
                                : 'N/A',
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => FeedbackDialog(
                              onSubmit: _showSnackBar,
                            ),
                          );
                        },
                        child: Text(
                          "Not to your liking? Press here",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            _recipes.length > 3 ? 3 : _recipes.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentRecipeIndex = index;
                              });
                            },
                            child: _Dot(index == _currentRecipeIndex),
                          );
                        }),
                      ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeImage(String? recipeImageData) {
    const String staticImagePath =
        'assests/generated_results_log_recepies/recipe_dish.png';
    final double imageHeight = 65.sp;

    // Show shimmer while loading
    if (_isLoadingImages) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: imageHeight,
          width: double.infinity,
          color: Colors.white,
        ),
      );
    }

    // If no matching image or image data is null, show static image
    if (recipeImageData == null) {
      return Image.asset(
        staticImagePath,
        height: imageHeight,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Static image failed to load: $error');
          return const Text('Image failed to load');
        },
      );
    }

    // Decode base64 image
    try {
      final imageBytes = base64Decode(recipeImageData);
      return ClipRRect(
        borderRadius: BorderRadius.circular(500),
        child: Image.memory(
          imageBytes,
          height: 75.sp,
          width: 75.sp,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            print('Base64 image failed to load: $error');
            return Image.asset(
              staticImagePath,
              height: imageHeight,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Text('Image failed to load');
              },
            );
          },
        ),
      );
    } catch (e) {
      print('Error decoding base64 image: $e');
      return Image.asset(
        staticImagePath,
        height: imageHeight,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Text('Image failed to load');
        },
      );
    }
  }

  void _showSnackBar(String message) {
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconTile(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18.h,
      child: Column(
        children: [
          Container(
            height: 9.h,
            width: 9.h,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;

  const _Dot(this.isActive);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      width: isActive ? 9.w : 5.w,
      height: 0.7.h,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : const Color(0xffD1D1D1),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class FeedbackDialog extends StatefulWidget {
  final Function(String) onSubmit;

  FeedbackDialog({required this.onSubmit});

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitFeedback() async {
    final feedback = _controller.text.trim();
    if (feedback.isEmpty) {
      widget.onSubmit('Please provide some feedback');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final response = await ApiService().feedbackRatingApi(
      context,
      feedback_before_cooking: feedback,
    );

    if (!mounted) {
      print('Dialog widget is not mounted, skipping UI update');
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (response.containsKey('error')) {
      final error = response['error'];
      widget.onSubmit(
          'Failed to submit: ${error['message']} (Status: ${error['status']})');
    } else {
      widget.onSubmit('Thank you for your feedback!');
      Navigator.of(context).pop();
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your Feedback helps us\nbetter tailor recipes to your preference',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Why didn’t any of the recipes appeal to you?',
              style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    '“I don’t like spicy food” or “I’m allergic to some ingredients”',
                hintStyle: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff979797)),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0xffD9D9D9)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.roboto(
                          color: Color(0xff979797), fontSize: 16.6.sp),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isSubmitting
                        ? CircularProgressIndicator(
                            color: Colors.blue, strokeWidth: 2)
                        : Text(
                            'Submit',
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 16.6.sp),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
