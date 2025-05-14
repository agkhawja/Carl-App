import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Step {
  final String description;
  final String time;
  final String imageUrl;

  Step({
    required this.description,
    required this.time,
    required this.imageUrl,
  });
}

class StepsScreen extends StatefulWidget {
  final Map<String, dynamic>? ai_one_recipes_detail_data;
  const StepsScreen({this.ai_one_recipes_detail_data});

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  late List<Step> steps;

  @override
  void initState() {
    super.initState();
    steps = _parseSteps(widget.ai_one_recipes_detail_data);
  }

  List<Step> _parseSteps(Map<String, dynamic>? data) {
    List<Step> parsedSteps = [];
    if (data == null || !data.containsKey('Preparation Steps')) {
      print('Data or Preparation Steps key is null');
      return parsedSteps;
    }

    final preparationSteps = data['Preparation Steps'] as List<dynamic>?;
    if (preparationSteps == null || preparationSteps.isEmpty) {
      print('Preparation Steps list is null or empty');
      return parsedSteps;
    }

    final placeholderImages = [
      'assests/generated_results_log_recepies/step_1.png',
      'assests/generated_results_log_recepies/step_2.png',
      'assests/generated_results_log_recepies/step_3.png',
      'assests/generated_results_log_recepies/step_4.png',
      'assests/generated_results_log_recepies/step_5.png',
    ];

    int imageIndex = 0;
    for (var stepEntry in preparationSteps) {
      if (stepEntry is Map<String, dynamic>) {
        // Skip the title entry
        if (stepEntry.containsKey('title')) {
          continue;
        }

        // Process step entries (e.g., "Step 1", "Step 2")
        final stepKey = stepEntry.keys.firstWhere(
          (key) => key.startsWith('Step'),
          orElse: () => '',
        );
        if (stepKey.isNotEmpty) {
          final stepDetails = stepEntry[stepKey] as Map<String, dynamic>?;
          if (stepDetails != null) {
            final description = stepDetails['description']?.toString() ?? 'N/A';
            final time = stepDetails['time']?.toString() ?? 'N/A';
            final imageUrl =
                placeholderImages[imageIndex % placeholderImages.length];

            print(
                'Parsed step: $stepKey, Description: $description, Time: $time');
            parsedSteps.add(Step(
              description: description,
              time: time,
              imageUrl: imageUrl,
            ));
            imageIndex++;
          } else {
            print('Step details are null for $stepKey');
          }
        }
      } else {
        print('Invalid step entry: $stepEntry');
      }
    }

    print('Total steps parsed: ${parsedSteps.length}');
    return parsedSteps;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 36.h,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (steps.isEmpty)
                    Center(
                      child: Text(
                        'No steps available',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    ...steps.asMap().entries.map((entry) {
                      int index = entry.key + 1;
                      Step step = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                child: Text('$index'),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Step $index',
                                      style: GoogleFonts.roboto(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff0A0615),
                                      ),
                                    ),
                                    Text(
                                      step.time,
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        color: Color(0xff0A0615),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!(steps.last == step))
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 80
                                            .sp, // Approximate height to span to next step
                                        child: DottedLine(
                                          direction: Axis.vertical,
                                          alignment: WrapAlignment.center,
                                          lineThickness: 1.0,
                                          dashLength: 6.0,
                                          dashColor: Colors.black,
                                          dashGapLength: 2.0,
                                          dashGapColor: Colors.white,
                                          dashRadius: 2.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(width: 2.w),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: SizedBox(
                                  width: 77.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: (steps.last == step)
                                                ? 2.w
                                                : 0.w),
                                        child: Text(
                                          step.description,
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.sp,
                                            color: Color(0xff0B0616),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      SizedBox(
                                        width: 80.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                step.imageUrl,
                                                height: 60.sp,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    height: 60.sp,
                                                    width: 80.w,
                                                    color: Colors.grey[300],
                                                    child: Center(
                                                      child: Text(
                                                        'Image not found',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      if (index < steps.length)
                                        Divider(
                                          thickness: 1,
                                          color: Colors.grey[300],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 1.h),
          height: 9.h,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 198, 196, 196),
                spreadRadius: 1,
                blurRadius: 6,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Center(
            child: Text(
              'Cooking Completed',
              style: GoogleFonts.roboto(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xff0A0615),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
