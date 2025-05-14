import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AiRecipeHistoryScreen extends StatefulWidget {
  const AiRecipeHistoryScreen({super.key});

  @override
  State<AiRecipeHistoryScreen> createState() => _AiRecipeHistoryScreenState();
}

class _AiRecipeHistoryScreenState extends State<AiRecipeHistoryScreen> {
  // Dummy data - will be replaced with API data later
  final List<Map<String, dynamic>> _recipes = [
    {'name': 'Quinoa Salad', 'ingredients': 7, 'isSelected': false},
    {'name': 'Vegetable Stir Fry', 'ingredients': 5, 'isSelected': false},
    {'name': 'Chicken Tandoori', 'ingredients': 12, 'isSelected': false},
    {'name': 'Zinger Burger', 'ingredients': 12, 'isSelected': false},
    {'name': 'Fried Rice', 'ingredients': 12, 'isSelected': false},
    {'name': 'Zinger Burger', 'ingredients': 12, 'isSelected': false},
    {'name': 'French Fries', 'ingredients': 12, 'isSelected': false},
    {'name': 'Chocolate Cake', 'ingredients': 12, 'isSelected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ai Recipe History',
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        itemCount: _recipes.length,
        separatorBuilder: (context, index) => Divider(
          height: 2.h,
          color: Colors.grey[300],
        ),
        itemBuilder: (context, index) {
          final recipe = _recipes[index];
          return _buildRecipeItem(recipe, index);
        },
      ),
    );
  }

  Widget _buildRecipeItem(Map<String, dynamic> recipe, int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        recipe['name'],
        style: GoogleFonts.roboto(
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
          color: Color(0xff0A0615),
        ),
      ),
      subtitle: Text(
        '${recipe['ingredients']} Ingredients',
        style: GoogleFonts.roboto(
          fontSize: 14.5.sp,
          color: Color(0xff9299A3),
        ),
      ),
      trailing: Container(
        height: 23.sp,
        width: 23.sp,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffE5E9EF),
        ),
        child: Center(
          child: IconButton(
            icon: Icon(
              recipe['isSelected'] ? Icons.check : Icons.add,
              size: 17.sp,
              color: recipe['isSelected'] ? Colors.green : Colors.black,
            ),
            onPressed: () {
              setState(() {
                _recipes[index]['isSelected'] = !_recipes[index]['isSelected'];
              });
            },
          ),
        ),
      ),
    );
  }
}
