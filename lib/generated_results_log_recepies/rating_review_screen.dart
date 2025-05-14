// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, prefer_const_constructors_in_immutables, curly_braces_in_flow_control_structures

import 'package:carl/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RatingReview extends StatefulWidget {
  final String? recipeName;
  RatingReview({
    this.recipeName,
  });
  @override
  _RatingReviewState createState() => _RatingReviewState();
}

class _RatingReviewState extends State<RatingReview> {
  final TextEditingController _feedbackController = TextEditingController();
  double _userRating = 0.0; // Default rating
  bool _isSubmitting = false;
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    // Validate input
    if (_feedbackController.text.trim().isEmpty) {
      if (mounted) _showSnackBar('Please enter your feedback');
      return;
    }

    if (_userRating < 1) {
      if (mounted) _showSnackBar('Please select a rating');
      return;
    }

    setState(() => _isSubmitting = true);

    // Call the API with only rating and feedback after cooking
    final response = await ApiService().feedbackRatingApi(
      context,
      rating_stars_after_cooking: _userRating,
      feedback_after_cooking: _feedbackController.text,
    );

    if (!mounted) {
      print('Widget is not mounted, skipping UI update');
      return;
    }
    setState(() => _isSubmitting = false);

    // Handle API response
    if (response.containsKey('error')) {
      final error = response['error'];
      if (mounted)
        _showSnackBar(
            'Failed to submit: ${error['message']} (Status: ${error['status']})');
    } else {
      if (mounted) {
        _showSnackBar('Feedback submitted successfully!');
        _feedbackController.clear();
        Navigator.pop(context);
      }
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

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
        backgroundColor: const Color(0xffF7F7F7),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: const Color(0xffFFFFFF),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 100.h,
                color: const Color(0xffF7F7F7),
              ),
              Container(
                height: 25.h,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How was your meal?',
                          style: GoogleFonts.roboto(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff0A0615),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.recipeName ?? 'N/A',
                          style: GoogleFonts.roboto(
                            color: const Color(0xff707070),
                            fontSize: 15.5.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: Image.asset(
                              'assests/generated_results_log_recepies/recipe_dish.png',
                              height: 65.sp,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            SizedBox(height: 2.h),
                            RatingBar.builder(
                              initialRating: _userRating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Color(0xffFF9500),
                              ),
                              onRatingUpdate: (rating) {
                                setState(() => _userRating = rating);
                              },
                            ),
                            SizedBox(height: 3.h),
                            Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add a comment',
                                    style: GoogleFonts.roboto(
                                      color: const Color(0xff1F1F1F),
                                      fontSize: 17.5.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Container(
                                    height: 27.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                      vertical: 2.h,
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 2.h),
                                    child: TextField(
                                      controller: _feedbackController,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        hintText:
                                            'What did you like or dislike about this meal?',
                                        hintStyle: GoogleFonts.roboto(
                                          color: const Color(0xff707070),
                                          fontSize: 16.sp,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100.w,
                                    height: 7.h,
                                    child: ElevatedButton(
                                      onPressed: _isSubmitting
                                          ? null
                                          : _submitFeedback,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        disabledBackgroundColor: Colors.grey,
                                      ),
                                      child: _isSubmitting
                                          ? const CircularProgressIndicator(
                                              color: Colors.white)
                                          : Text(
                                              "Submit Feedback",
                                              style: GoogleFonts.roboto(
                                                fontSize: 18.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
