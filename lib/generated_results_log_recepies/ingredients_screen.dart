import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Ingredient {
  final String name;
  final String quantity;
  final String imageUrl;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.imageUrl,
  });
}

class IngredientsScreen extends StatefulWidget {
  final Map<String, dynamic>? ai_one_recipes_detail_data;

  const IngredientsScreen({this.ai_one_recipes_detail_data});

  @override
  _IngredientsScreenState createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  late List<IngredientState> _ingredientStates;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _ingredientStates = _parseIngredients(widget.ai_one_recipes_detail_data);
  }

  @override
  void dispose() {
    // Ensure any active snackbars are removed before disposal
    _scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
    super.dispose();
  }

  static List<IngredientState> _parseIngredients(Map<String, dynamic>? data) {
    List<IngredientState> ingredientStates = [];
    if (data == null || !data.containsKey('Ingredients')) {
      print('Data or Ingredients key is null');
      return ingredientStates;
    }

    final ingredientsList = data['Ingredients'] as List<dynamic>?;
    if (ingredientsList == null) {
      print('Ingredients list is null');
      return ingredientStates;
    }

    final placeholderImages = [
      'assests/generated_results_log_recepies/dish_1.png',
      'assests/generated_results_log_recepies/dish_2.png',
      'assests/generated_results_log_recepies/dish_3.png',
      'assests/generated_results_log_recepies/dish_4.png',
    ];

    int imageIndex = 0;
    for (var ingredientEntry in ingredientsList) {
      if (ingredientEntry is Map<String, dynamic>) {
        // Extract primary ingredient
        final primaryData =
            ingredientEntry['Ingredient (Primary)'] as Map<String, dynamic>?;
        if (primaryData != null) {
          final name = primaryData['name']?.toString() ?? 'Unknown';
          final quantity = primaryData['quantity']?.toString() ?? 'N/A';
          final imageUrl =
              placeholderImages[imageIndex % placeholderImages.length];
          print('Parsed primary: $name, $quantity');

          // Extract alternatives
          final alternativesList =
              ingredientEntry['Alternatives'] as List<dynamic>? ?? [];
          print('Alternatives list: $alternativesList');

          final List<Ingredient> alternatives = [];
          for (var alt in alternativesList) {
            if (alt is Map<String, dynamic>) {
              final altName = alt['name']?.toString() ?? 'Unknown';
              final altQuantity = alt['quantity']?.toString() ?? 'N/A';
              print('Parsed alternative: $altName, $altQuantity');
              alternatives.add(Ingredient(
                name: altName,
                quantity: altQuantity,
                imageUrl: imageUrl,
              ));
            } else {
              print('Invalid alternative entry: $alt');
            }
          }

          print('Final alternatives count: ${alternatives.length}');
          ingredientStates.add(IngredientState(
            primary:
                Ingredient(name: name, quantity: quantity, imageUrl: imageUrl),
            alternatives: alternatives,
            currentIndex: 0,
          ));
          imageIndex++;
        } else {
          print('Primary ingredient data is null');
        }
      } else {
        print('Invalid ingredient entry: $ingredientEntry');
      }
    }
    print('Total ingredient states: ${ingredientStates.length}');
    return ingredientStates;
  }

  void _switchIngredient(int index) {
    if (!mounted) return;
    if (_ingredientStates[index].alternatives.isEmpty) {
      if (mounted) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('No alternative available'),
            backgroundColor: Colors.grey,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }
    setState(() {
      _ingredientStates[index].currentIndex =
          (_ingredientStates[index].currentIndex + 1) %
              (_ingredientStates[index].alternatives.length + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: SizedBox(
        height: 40.h,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (_ingredientStates.isEmpty)
                      Center(
                        child: Text(
                          'No ingredients available',
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    else
                      ..._ingredientStates.asMap().entries.map((entry) {
                        final index = entry.key;
                        final state = entry.value;
                        final currentIngredient = state.currentIndex == 0
                            ? state.primary
                            : state.alternatives[state.currentIndex - 1];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 1.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  currentIngredient.imageUrl,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: Center(
                                        child: Text(
                                          'Image not found',
                                          style: TextStyle(color: Colors.grey),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 35.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentIngredient.name,
                                      // overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      currentIngredient.quantity,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => _switchIngredient(index),
                                child: Image.asset(
                                  'assests/generated_results_log_recepies/refresh_icon.png',
                                  width: 24.sp,
                                  height: 24.sp,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.refresh,
                                      color: Colors.grey,
                                      size: 24,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
              // Container(
              //   padding: EdgeInsets.only(bottom: 1.h),
              //   height: 9.h,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     boxShadow: [
              //       BoxShadow(
              //         color: Color.fromARGB(255, 198, 196, 196),
              //         spreadRadius: 1,
              //         blurRadius: 6,
              //       ),
              //     ],
              //     color: Colors.white,
              //     borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(35),
              //       topRight: Radius.circular(35),
              //     ),
              //   ),
              //   child: Center(
              //     child: Text(
              //       'Cooking Completed',
              //       style: GoogleFonts.roboto(
              //         fontSize: 17.sp,
              //         fontWeight: FontWeight.bold,
              //         color: Color(0xff0A0615),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class IngredientState {
  final Ingredient primary;
  final List<Ingredient> alternatives;
  int currentIndex;

  IngredientState({
    required this.primary,
    required this.alternatives,
    this.currentIndex = 0,
  });

  Ingredient get current {
    return currentIndex == 0 ? primary : alternatives[currentIndex - 1];
  }
}
