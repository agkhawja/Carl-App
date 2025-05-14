import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String selectedLanguage = 'English';

  final List<String> languages = [
    'English',
    'Urdu',
    'Arabic',
    'French',
    'German',
    'Spanish',
    'Chinese',
    'Hindi'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  dropdownColor: Colors.black,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white),
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                  items: languages.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Row(
                        children: [
                          Icon(Icons.language, color: Colors.white),
                          SizedBox(width: 1.w),
                          Text(
                            language,
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLanguage = newValue!;
                      // Optional: implement logic to update privacy content based on selected language
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'At TasteTrail, we take your privacy seriously. We collect personal information such as your name, email, and preferences like dietary needs, along with automatically collected data such as device information, app usage, and location data (if you opt-in).\n\n'
                  'We use this information to provide personalized recipe suggestions, improve app performance, and keep you informed with updates or notifications.\n\n'
                  'Your data is never sold, and we only share it with trusted service providers (like analytics tools) or if legally required. We take reasonable steps to protect your information, though no system is entirely secure. You have control over your data and can adjust settings in the app or opt out of notifications whenever you wish.',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: Colors.black,
                    // height: 1.5,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
