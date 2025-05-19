// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, unnecessary_type_check

import 'package:carl/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class GroceryItem {
  final String image;
  String title;
  String subtitle;
  final String category;
  bool isAdded; // Track if item is added to actual grocery
  final Map<String, dynamic>? originalData; // Store original API data
  int alternativeIndex; // Track current alternative index
  final String? documentId; // Store document ID for deletion

  GroceryItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.category,
    this.isAdded = false,
    this.originalData,
    this.alternativeIndex = 0,
    this.documentId,
  });
}

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  List<GroceryItem> smartSuggestions = [];
  List<GroceryItem> actualGrocery = [];
  Map<String, dynamic>? allData;
  bool isLoading = true;
  bool isActualGroceryLoading = true;
  final Logger logger = Logger(); // For debugging

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchActualGroceryData();
  }

  Future<void> _fetchData() async {
    try {
      setState(() => isLoading = true);

      // Fetch user data
      allData = await ApiService().getAllUserData(context);
      if (allData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No user data found. Please try again.")),
        );
        setState(() => isLoading = false);
        return;
      }

      // Fetch previous grocery data
      final actualGroceryResponse =
          await ApiService().getAllActualGroceryData(context);
      List<Map<String, String>> previousGroceryData = [];
      if (actualGroceryResponse != null &&
          actualGroceryResponse['data'] != null) {
        previousGroceryData = (actualGroceryResponse['data'] as List)
            .map((item) => {
                  "grocery_title":
                      item['grocery_title']?.toString() ?? 'Unknown'
                })
            .toList()
            .reversed
            .toList(); // Reverse to match actualGrocery order
        logger.d('Previous Grocery Data: $previousGroceryData');
      }

      // Fetch pantry items
      final pantryResponse = await ApiService().getAllPantryData(context);
      List<Map<String, String>> pantryItems = [];
      if (pantryResponse != null && pantryResponse['data'] != null) {
        pantryItems = (pantryResponse['data'] as List)
            .map((item) =>
                {"Ingredient": item['Ingredient']?.toString() ?? 'Unknown'})
            .toList()
            .reversed
            .toList(); // Reverse to show latest items first
        logger.d('Pantry Items: $pantryItems');
      }

      // Construct userData map
      final userData = {
        "user_data": {
          "weight": allData!['weight']?.toString() ?? 'N/A',
          "height": allData!['height']?.toString() ?? 'N/A',
          "gender": allData!['gender']?.toString() ?? 'N/A',
          "dob": allData!['dob']?.toString() ?? 'N/A',
          "activity_level": allData!['activity_level']?.toString() ?? 'N/A',
          "sleep_quality": allData!['sleep_quality']?.toString() ?? 'N/A',
          "daily_stress_level":
              allData!['daily_stress_level']?.toString() ?? 'N/A',
          "dietary_supplements": _ensureList(allData!['dietary_supplements']),
          "sugary_drinks": allData!['sugary_drinks']?.toString() ?? 'N/A',
          "eat_out_per_week": allData!['eat_out_per_week']?.toString() ?? 'N/A',
          "time_spend_preparing_meals_daily": "More than 60 minutes",
          "time_spend_eating_your_meals_daily":
              allData!['time_spend_eating_your_meals_daily']?.toString() ??
                  'N/A',
          "alcohalic_beverages":
              allData!['alcohalic_beverages']?.toString() ?? 'N/A',
          "meals_consume_daily": _ensureList(allData!['meals_consume_daily']),
          "dietary_restrictions_or_allergies":
              _ensureList(allData!['dietary_restrictions_or_allergies']),
          "risks": _ensureList(allData!['risks']),
          "priority_in_well_being":
              _ensureList(allData!['priority_in_well_being']),
          "sport_do_you_practice":
              _ensureList(allData!['sport_do_you_practice']),
          "body_composition_goal":
              allData!['body_composition_goal']?.toString() ?? 'N/A',
          "primary_goal": allData!['primary_goal']?.toString() ?? 'N/A'
        },
        "pantry_items": pantryItems,
        "previous_grocery_data": previousGroceryData,
      };

      // Fetch AI-generated grocery suggestions
      final groceryResponse =
          await ApiService().generateGrocerythroughAIApi(userData);
      if (groceryResponse == null || groceryResponse['Grocery list'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch grocery list.")),
        );
        setState(() => isLoading = false);
        return;
      }

      setState(() {
        smartSuggestions = (groceryResponse['Grocery list'] as List)
            .map((item) => GroceryItem(
                  image: 'assests/Pantry/fruit_category_image.jpg',
                  title: item['recommended'] as String,
                  subtitle: item['benefit'] as String,
                  category: 'Generated',
                  originalData: item,
                  alternativeIndex: 0,
                ))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchActualGroceryData() async {
    try {
      setState(() => isActualGroceryLoading = true);
      final groceryData = await ApiService().getAllActualGroceryData(context);
      if (groceryData != null && groceryData['data'] != null) {
        setState(() {
          actualGrocery = (groceryData['data'] as List)
              .map((data) => GroceryItem(
                    image: 'assests/Pantry/fruit_category_image.jpg',
                    title: data['grocery_title'] as String,
                    subtitle: data['grocery_quantity'] as String,
                    category: 'Actual',
                    documentId: data['documentId'] as String?,
                  ))
              .toList()
              .reversed
              .toList(); // Reverse to show newest items first
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch actual grocery data.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching actual grocery: $e")),
      );
    } finally {
      setState(() => isActualGroceryLoading = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchActualGroceryData();
  }

  Future<void> addToPantry(GroceryItem item) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 2.h),
            Text("Adding to pantry..."),
          ],
        ),
      ),
    );

    try {
      // Call pantryAddIngredients API
      final addResponse = await ApiService().pantryAddIngredients(
        context,
        item.title,
        item.subtitle,
      );

      // Log response for debugging
      logger.d("pantryAddIngredients Response: $addResponse");

      // Check if addResponse is a Map with a 'data' field
      bool addSuccess = addResponse != null &&
          (addResponse is Map) &&
          addResponse.containsKey('data');

      if (!addSuccess) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add ${item.title} to pantry.")),
        );
        return;
      }

      // Call deleteActualGrocery API if add was successful
      if (item.documentId != null) {
        final deleteResponse = await ApiService().deleteActualGrocery(
          groceryDocumentId: item.documentId!,
        );

        // Log response for debugging
        logger.d("deleteActualGrocery Response: $deleteResponse");

        // Check if deleteResponse is a bool and true
        bool deleteSuccess = deleteResponse == true;

        if (!deleteSuccess) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Failed to delete ${item.title} from grocery.")),
          );
          return;
        }
      }

      // Refresh grocery data
      await _fetchActualGroceryData();

      // Close loading dialog
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${item.title} added to pantry successfully!")),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  List<dynamic> _ensureList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value;
    return [value];
  }

  Future<void> addItemToGrocery(GroceryItem item) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Add Quantity",
          style:
              GoogleFonts.roboto(fontSize: 17.sp, fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quantity',
                  style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
              SizedBox(height: 0.5.h),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  hintText: 'e.g., 500 g',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xffD9D9D9)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            width: 33.w,
            decoration: BoxDecoration(
              color: Color(0xffEBEBEB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                quantityController.clear();
                Navigator.pop(context);
              },
              child: Text("Cancel",
                  style: GoogleFonts.roboto(
                      color: Color(0xff000000), fontSize: 15.sp)),
            ),
          ),
          Container(
            width: 33.w,
            decoration: BoxDecoration(
              color: Color(0xff000000),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero),
              onPressed: () async {
                final quantity = quantityController.text.trim();
                if (quantity.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a quantity.")),
                  );
                  return;
                }

                final response =
                    await ApiService().addAISuggestedGroceryToActualGrocery(
                  context,
                  grocery_title: item.title,
                  grocery_quantity: quantity,
                );

                // Log response for debugging
                logger.d(
                    "addAISuggestedGroceryToActualGrocery Response: $response");

                // Check if response is a Map with a 'data' field
                bool success = response != null &&
                    (response is Map) &&
                    response.containsKey('data');

                if (success) {
                  await _fetchActualGroceryData();
                  final suggestionIndex =
                      smartSuggestions.indexWhere((s) => s.title == item.title);
                  if (suggestionIndex != -1) {
                    setState(() {
                      smartSuggestions[suggestionIndex].isAdded = true;
                    });
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("${item.title} added successfully!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to add ${item.title}.")),
                  );
                }
                quantityController.clear();
                Navigator.pop(context);
              },
              child: Text("Add to Grocery",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  void removeItemFromGrocery(GroceryItem item) async {
    try {
      if (item.documentId != null) {
        final response = await ApiService()
            .deleteActualGrocery(groceryDocumentId: item.documentId!);
        // Log response for debugging
        logger.d("deleteActualGrocery Response: $response");
        // Check if response is a bool and true
        bool success = response == true;
        if (success) {
          setState(() {
            actualGrocery
                .removeWhere((groceryItem) => groceryItem.title == item.title);
            // Update isAdded for smartSuggestions
            final suggestionIndex =
                smartSuggestions.indexWhere((s) => s.title == item.title);
            if (suggestionIndex != -1) {
              smartSuggestions[suggestionIndex].isAdded = false;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${item.title} removed successfully!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to remove ${item.title}.")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error removing item: $e")),
      );
    }
  }

  void cycleAlternative(GroceryItem item) {
    setState(() {
      final original = item.originalData;
      if (original == null || original['alternatives'] == null) return;

      final alternatives = original['alternatives'] as List;
      if (alternatives.isEmpty) return;

      final currentTitle = item.title;
      item.alternativeIndex =
          (item.alternativeIndex + 1) % (alternatives.length + 1);
      if (item.alternativeIndex == alternatives.length) {
        item.title = original['recommended'] as String;
        item.subtitle = original['benefit'] as String;
      } else {
        final alt = alternatives[item.alternativeIndex] as Map<String, dynamic>;
        item.title = alt['item'] as String;
        item.subtitle = alt['benefit'] as String;
      }

      // Reset isAdded if the title changes, but keep it true if the new title is already in actualGrocery
      if (item.title != currentTitle) {
        item.isAdded =
            actualGrocery.any((groceryItem) => groceryItem.title == item.title);
      }
    });
  }

  List<GroceryItem> get filteredActualGrocery {
    final query = searchController.text.toLowerCase();
    return actualGrocery
        .where((item) => item.title.toLowerCase().contains(query))
        .toList();
  }

  void showAddIngredientDialog() {
    nameController.clear();
    quantityController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Add New Grocery",
          style:
              GoogleFonts.roboto(fontSize: 17.sp, fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Grocery Name',
                  style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
              SizedBox(height: 0.5.h),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Tomatoes',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xffD9D9D9)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Text('Quantity',
                  style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
              SizedBox(height: 0.5.h),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  hintText: 'e.g., 500 g',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xffD9D9D9)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            width: 33.w,
            decoration: BoxDecoration(
              color: Color(0xffEBEBEB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                nameController.clear();
                quantityController.clear();
                Navigator.pop(context);
              },
              child: Text("Cancel",
                  style: GoogleFonts.roboto(
                      color: Color(0xff000000), fontSize: 15.sp)),
            ),
          ),
          Container(
            width: 33.w,
            decoration: BoxDecoration(
              color: Color(0xff000000),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero),
              onPressed: () async {
                final name = nameController.text.trim();
                final quantity = quantityController.text.trim();
                if (name.isEmpty || quantity.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill all fields.")),
                  );
                  return;
                }

                final response =
                    await ApiService().addAISuggestedGroceryToActualGrocery(
                  context,
                  grocery_title: name,
                  grocery_quantity: quantity,
                );

                // Log response for debugging
                logger.d(
                    "addAISuggestedGroceryToActualGrocery Response: $response");

                // Check if response is a Map with a 'data' field
                bool success = response != null &&
                    (response is Map) &&
                    response.containsKey('data');

                if (success) {
                  await _fetchActualGroceryData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Grocery item added successfully!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to add grocery item.")),
                  );
                }

                nameController.clear();
                quantityController.clear();
                Navigator.pop(context);
              },
              child: Text("Add to Grocery",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return SizedBox(
      height: 14.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(right: 3.w),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 74.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 39.sp,
                      height: 39.sp,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: Container(
                              width: 30.w,
                              height: 17.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Container(
                              width: 20.w,
                              height: 15.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 15.w,
                                  height: 3.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Container(
                                  width: 23.sp,
                                  height: 23.sp,
                                  color: Colors.grey,
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActualGroceryShimmer() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40.sp,
                    height: 40.sp,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40.w,
                          height: 17.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 0.5.h),
                        Container(
                          width: 30.w,
                          height: 15.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 29.w,
                              height: 2.h,
                              color: Colors.grey,
                            ),
                            Container(
                              width: 24.sp,
                              height: 24.sp,
                              color: Colors.grey,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Grocery List',
          style: GoogleFonts.roboto(
              fontSize: 20.sp,
              color: Colors.black,
              fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade200, blurRadius: 5)
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search Actual Grocery',
                  hintStyle: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff404B52)),
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Smart Suggestions",
                  style: GoogleFonts.roboto(
                      fontSize: 18.5.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff0A0615)),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            isLoading
                ? _buildShimmer()
                : smartSuggestions.isEmpty
                    ? SizedBox(
                        height: 14.h,
                        child: Center(child: Text("No suggestions available.")),
                      )
                    : SizedBox(
                        height: 14.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: smartSuggestions.length,
                          itemBuilder: (context, index) {
                            final item = smartSuggestions[index];
                            return Padding(
                              padding: EdgeInsets.only(right: 3.w),
                              child: Container(
                                width: 74.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 5)
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 4.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          item.image,
                                          width: 39.sp,
                                          height: 39.sp,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 2.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item.title,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 17.sp),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Image.asset(
                                                      'assests/Pantry/ic_round-restore.png',
                                                      height: 23.sp,
                                                      width: 23.sp,
                                                    ),
                                                    onPressed: () =>
                                                        cycleAlternative(item),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.w),
                                              child: Text(
                                                item.subtitle,
                                                style: GoogleFonts.roboto(
                                                    color: Color(0xff9299A3),
                                                    fontSize: 15.sp),
                                              ),
                                            ),
                                            SizedBox(height: 0.5.h),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 2.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize:
                                                          Size(1.w, 3.h),
                                                      backgroundColor:
                                                          item.isAdded
                                                              ? Colors.grey
                                                              : Colors.black,
                                                      shape: StadiumBorder(),
                                                    ),
                                                    onPressed: item.isAdded
                                                        ? null
                                                        : () =>
                                                            addItemToGrocery(
                                                                item),
                                                    child: Text(
                                                      "Add",
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white),
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
                              ),
                            );
                          },
                        ),
                      ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Actual Grocery",
                  style: GoogleFonts.roboto(
                      fontSize: 18.sp, fontWeight: FontWeight.w600),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: StadiumBorder(),
                  ),
                  onPressed: showAddIngredientDialog,
                  child: Text(
                    "Add",
                    style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: isActualGroceryLoading
                  ? _buildActualGroceryShimmer()
                  : actualGrocery.isEmpty
                      ? Center(child: Text("No groceries added yet. Add some!"))
                      : filteredActualGrocery.isEmpty
                          ? Center(child: Text("No items match your search."))
                          : ListView.builder(
                              itemCount: filteredActualGrocery.length,
                              itemBuilder: (context, index) {
                                final item = filteredActualGrocery[index];
                                return Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  margin: EdgeInsets.symmetric(vertical: 1.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(2.w),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 1.h),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              item.image,
                                              width: 40.sp,
                                              height: 40.sp,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 40.w,
                                                    child: Text(
                                                      item.title,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 17.sp),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                item.subtitle,
                                                style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.5.sp,
                                                  color: Color(0xff9299A3),
                                                ),
                                              ),
                                              SizedBox(height: 0.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      fixedSize:
                                                          Size(29.w, 2.h),
                                                      backgroundColor:
                                                          Colors.black,
                                                      shape: StadiumBorder(),
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    onPressed: () =>
                                                        addToPantry(item),
                                                    child: Text(
                                                      "Add to Pantry",
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Image.asset(
                                                      'assests/Pantry/delete_icon.png',
                                                      width: 24.sp,
                                                      height: 24.sp,
                                                    ),
                                                    onPressed: () =>
                                                        removeItemFromGrocery(
                                                            item),
                                                  ),
                                                ],
                                              ),
                                            ],
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
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
