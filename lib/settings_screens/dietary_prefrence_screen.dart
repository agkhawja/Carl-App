import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DietaryPreferenceScreen extends StatefulWidget {
  const DietaryPreferenceScreen({super.key});

  @override
  State<DietaryPreferenceScreen> createState() =>
      _DietaryPreferenceScreenState();
}

class _DietaryPreferenceScreenState extends State<DietaryPreferenceScreen> {
  String? _selectedPreference;
  final List<String> _preferences = [
    'Vegetarian',
    'Gluten free',
    'Keto',
    'No restriction',
    'Low carb',
  ];
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Dietary preference',
          style:
              GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Text(
              'Select one',
              style:
                  GoogleFonts.roboto(fontSize: 16.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 2.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ExpansionTile(
                title: Text(
                  _selectedPreference ?? 'Select dietary preference',
                  style: GoogleFonts.roboto(fontSize: 16.sp),
                ),
                trailing: Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 24.sp,
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _isExpanded = expanded;
                  });
                },
                children: _preferences.map((preference) {
                  return _buildDropdownItem(preference);
                }).toList(),
              ),
            ),
            SizedBox(height: 2.h),
            _buildDoneButton(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownItem(String preference) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPreference = preference;
          _isExpanded = false;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: _selectedPreference == preference
              ? Colors.grey[200]
              : Colors.transparent,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Text(
              preference,
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: _selectedPreference == preference
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (_selectedPreference == preference)
              Icon(Icons.check, size: 20.sp, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedPreference != null
            ? () {
                // Handle done action
                Navigator.pop(context, _selectedPreference);
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Done',
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
