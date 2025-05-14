// ignore_for_file: unnecessary_null_comparison, unnecessary_type_check

import 'package:carl/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  List<Map<String, dynamic>> pantryItems = [];
  List<Map<String, dynamic>> favoriteItems = [];
  Set<int> likedItems = {};
  bool isLoading = true;
  bool isAddingIngredient = false;
  String? errorMessage;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchPantryData();
  }

  // Fetch pantry and favorite data from API
  Future<void> fetchPantryData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      // Fetch pantry data
      final pantryResponse = await ApiService().getAllPantryData(context);
      if (pantryResponse != null && pantryResponse['data'] != null) {
        if (!mounted) return;
        setState(() {
          pantryItems = List<Map<String, dynamic>>.from(
              pantryResponse['data'].map((item) => {
                    'id': item['id']?.toString() ?? '',
                    'documentId': item['documentId']?.toString() ?? '',
                    'title': item['Ingredient']?.toString() ?? 'Unknown',
                    'quantity':
                        item['Quantity']?.toString().split(' ').first ?? '1',
                    'unit': item['Quantity']
                            ?.toString()
                            .split(' ')
                            .skip(1)
                            .join(' ') ??
                        '',
                  }));
        });
        logger.d('Pantry Items: $pantryItems');
      } else {
        if (!mounted) return;
        setState(() {
          pantryItems = [];
        });
      }

      // Fetch favorite data
      final favoriteResponse =
          await ApiService().getAllLikedPantryItemsData(context);
      if (favoriteResponse != null && favoriteResponse['data'] != null) {
        if (!mounted) return;
        favoriteItems =
            List<Map<String, dynamic>>.from(favoriteResponse['data']);
        setState(() {
          likedItems.clear();
          for (int i = 0; i < pantryItems.length; i++) {
            final pantryItemId = pantryItems[i]['id'];
            final favoriteItem = favoriteItems.firstWhere(
              (fav) => fav['pantry']?['id']?.toString() == pantryItemId,
              orElse: () => {'isFavourite': false},
            );
            if (favoriteItem['isFavourite'] == true) {
              likedItems.add(i);
            }
          }
          isLoading = false;
        });
        logger.d('Favorite Items: $favoriteItems, Liked Items: $likedItems');
      } else {
        if (!mounted) return;
        setState(() {
          favoriteItems = [];
          likedItems.clear();
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      logger.e('Failed to load pantry or favorite data: $e');
      setState(() {
        errorMessage = 'Failed to load data: $e';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage!)),
      );
    }
  }

  // Get filtered items based on search query
  List<Map<String, dynamic>> get filteredItems {
    final query = searchController.text.toLowerCase();
    return pantryItems
        .where((item) {
          final title = item['title']?.toLowerCase() ?? '';
          return title.contains(query);
        })
        .toList()
        .reversed
        .toList();
  }

  // Toggle favorite status with API call
  Future<void> toggleFavorite(int index, Map<String, dynamic> item) async {
    final isCurrentlyFavorited = likedItems.contains(index);
    final itemId = item['id']?.toString();

    if (itemId == null || itemId.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid item ID")),
      );
      return;
    }

    try {
      final parsedId = int.tryParse(itemId);
      if (parsedId == null) {
        throw FormatException("Invalid item ID format: $itemId");
      }
      logger.d("Toggling favorite for item ID: $parsedId");

      bool success;
      if (isCurrentlyFavorited) {
        // Find the favorite entry's documentId
        final favoriteItem = favoriteItems.firstWhere(
          (fav) => fav['pantry']?['id']?.toString() == itemId,
          orElse: () => {},
        );
        final favoriteDocumentId = favoriteItem['documentId']?.toString();
        if (favoriteDocumentId == null || favoriteDocumentId.isEmpty) {
          throw Exception(
              "Favorite document ID not found for item ID: $itemId");
        }
        success = await ApiService().pantryRemoveFromFavouriteApi(
            favoriteDocumentId: favoriteDocumentId);
      } else {
        // Add to favorites using pantry item ID
        final result =
            await ApiService().pantryAddtoFavouriteApi(context, true, parsedId);
        logger.d('Add to favorite result: $result');
        // Assume success if no exception and result is a Map (adjust based on actual API response)
        success = result != null && (result is Map);
      }

      if (success) {
        if (!mounted) return;
        setState(() {
          if (isCurrentlyFavorited) {
            likedItems.remove(index);
          } else {
            likedItems.add(index);
          }
        });
        // Refresh favorite data to ensure consistency
        final favoriteResponse =
            await ApiService().getAllLikedPantryItemsData(context);
        if (favoriteResponse != null && favoriteResponse['data'] != null) {
          if (!mounted) return;
          setState(() {
            favoriteItems =
                List<Map<String, dynamic>>.from(favoriteResponse['data']);
            likedItems.clear();
            for (int i = 0; i < pantryItems.length; i++) {
              final pantryItemId = pantryItems[i]['id'];
              final favoriteItem = favoriteItems.firstWhere(
                (fav) => fav['pantry']?['id']?.toString() == pantryItemId,
                orElse: () => {'isFavourite': false},
              );
              if (favoriteItem['isFavourite'] == true) {
                likedItems.add(i);
              }
            }
          });
          logger.d(
              'Refreshed Favorite Items: $favoriteItems, Liked Items: $likedItems');
        }
      } else {
        throw Exception(
            'Failed to update favorite status: Invalid response from server');
      }
    } catch (e) {
      if (!mounted) return;
      logger.e('Failed to update favorite status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Unable to update favorite status. Please try again.")),
      );
    }
  }

  // Delete pantry item with API call
  Future<void> deletePantryItem(int index, Map<String, dynamic> item) async {
    final documentId = item['documentId']?.toString();

    if (documentId == null || documentId.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid document ID")),
      );
      return;
    }

    try {
      final success =
          await ApiService().deletePantryIngredients(pantryId: documentId);
      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ingredient deleted successfully")),
        );
        await fetchPantryData();
      } else {
        throw Exception("Failed to delete ingredient");
      }
    } catch (e) {
      if (!mounted) return;
      logger.e('Failed to delete ingredient: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete ingredient: $e")),
      );
    }
  }

  // Check if ingredient already exists
  bool _ingredientExists(String name, String quantity) {
    final normalizedName = name.trim().toLowerCase();
    final normalizedQuantity = quantity.trim().toLowerCase();
    return pantryItems.any((item) =>
        item['title']?.toLowerCase() == normalizedName &&
        "${item['quantity']} ${item['unit']}".toLowerCase() ==
            normalizedQuantity);
  }

  // Add ingredient with robust debouncing
  Future<void> _addIngredient(String name, String quantity) async {
    if (isAddingIngredient) return;

    if (_ingredientExists(name, quantity)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ingredient already exists in pantry")),
      );
      return;
    }

    if (mounted) {
      setState(() {
        isAddingIngredient = true;
      });
    }

    try {
      await ApiService().pantryAddIngredients(context, name, quantity);
      await fetchPantryData();
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ingredient added successfully!")),
      );
    } catch (e) {
      if (!mounted) return;
      logger.e('Failed to add ingredient: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add ingredient: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isAddingIngredient = false;
        });
      }
    }
  }

  // Show dialog to add new ingredient
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
          "Add New Ingredient",
          style:
              GoogleFonts.roboto(fontSize: 17.sp, fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ingredient Name',
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
              onPressed:
                  isAddingIngredient ? null : () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: GoogleFonts.roboto(
                    color: Color(0xff000000), fontSize: 15.sp),
              ),
            ),
          ),
          Container(
            width: 33.w,
            decoration: BoxDecoration(
              color: Color(0xff000000),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
              onPressed: isAddingIngredient
                  ? null
                  : () async {
                      try {
                        final name = nameController.text.trim();
                        final quantity = quantityController.text.trim();
                        if (name.isEmpty || quantity.isEmpty) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please fill all fields.")),
                          );
                          return;
                        }
                        await _addIngredient(name, quantity);
                      } catch (e) {
                        if (!mounted) return;
                        logger.e('Unexpected error in add ingredient: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Unexpected error: $e")),
                        );
                      }
                    },
              child: isAddingIngredient
                  ? SizedBox(
                      height: 15.sp,
                      width: 15.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "Add to Pantry",
                      style: GoogleFonts.roboto(
                          color: Colors.white, fontSize: 15.sp),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Build shimmer effect for loading state
  Widget _buildShimmer() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Color(0xffEBEBEB),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 30.w,
              height: 19.sp,
              color: Colors.grey,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 2.h, top: 2.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 18.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Container(
                      width: 30.w,
                      height: 17.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    margin: EdgeInsets.only(bottom: 1.5.h),
                    child: Padding(
                      padding: EdgeInsets.all(2.h),
                      child: Row(
                        children: [
                          Container(
                            height: 10.h,
                            width: 10.h,
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
                                  height: 16.5.sp,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 0.5.h),
                                Container(
                                  width: 20.w,
                                  height: 14.5.sp,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 20.sp,
                                height: 20.sp,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 1.h),
                              Container(
                                width: 20.sp,
                                height: 20.sp,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            childCount: 5, // Show 5 shimmering cards
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Container(
                  width: 40.w,
                  height: 17.sp,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEBEBEB),
      body: isLoading
          ? _buildShimmer()
          : pantryItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Please add pantry items/ingredients",
                        style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff0A0615),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),
                      GestureDetector(
                        onTap: showAddIngredientDialog,
                        child: Container(
                          width: 60.w,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Color(0xff1F1F1F),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Add New Ingredient",
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 17.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Color(0xffEBEBEB),
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      title: Text(
                        "My Pantry",
                        style: GoogleFonts.openSans(
                          color: Color(0xff0A0615),
                          fontSize: 19.sp,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 2.h, top: 2.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5)
                                ],
                              ),
                              child: TextField(
                                controller: searchController,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: "Search Ingredients",
                                  hintStyle: GoogleFonts.openSans(
                                    color: Color(0xff404B52),
                                    fontSize: 16.sp,
                                  ),
                                  border: InputBorder.none,
                                  icon: Icon(Icons.search,
                                      color: Colors.grey, size: 18.sp),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: Text(
                                "My Pantry",
                                style: GoogleFonts.poppins(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff0A0615),
                                ),
                              ),
                            ),
                            SizedBox(height: 1.h),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = filteredItems[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              margin: EdgeInsets.only(bottom: 1.5.h),
                              child: Padding(
                                padding: EdgeInsets.all(2.h),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 10.h,
                                      width: 10.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assests/Pantry/vegetable_category_image.jpg'),
                                          fit: BoxFit.cover,
                                          onError: (exception, stackTrace) {
                                            logger.e(
                                                'Image load error: $exception');
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title']!,
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.5.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff1F1F1F),
                                            ),
                                          ),
                                          SizedBox(height: 0.5.h),
                                          Text(
                                            "${item['quantity']} ${item['unit']}",
                                            style: GoogleFonts.roboto(
                                              color: Color(0xff9299A3),
                                              fontSize: 14.5.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            likedItems.contains(index)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.black,
                                            size: 20.sp,
                                          ),
                                          onPressed: () =>
                                              toggleFavorite(index, item),
                                        ),
                                        IconButton(
                                          icon: Image.asset(
                                              'assests/Pantry/delete_icon.png'),
                                          onPressed: () =>
                                              deletePantryItem(index, item),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: filteredItems.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: GestureDetector(
                          onTap: showAddIngredientDialog,
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Color(0xff1F1F1F),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Add New Ingredient",
                              style: GoogleFonts.roboto(
                                  color: Colors.white, fontSize: 17.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
