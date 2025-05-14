import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, dynamic>> notifications = const [
    {
      'icon': Icons.restaurant, // replace with actual asset in production
      'title': "Thursday's Feast Awaits!",
      'subtitle': "Your Exotic Veggie Platter is on the menu. Get excited!",
      'time': "2 days ago",
      'color': Colors.grey
    },
    {
      'icon': Icons.location_on,
      'title': "Meal Kit En Route!",
      'subtitle': "Today's the day. Your culinary adventure is almost there.",
      'time': "6 days ago",
      'color': Colors.deepOrange
    },
    {
      'icon': Icons.campaign,
      'title': "Tomorrow's Treats!",
      'subtitle': "Last chance to add a little extra to your Tuesday delivery.",
      'time': "9 days ago",
      'color': Colors.redAccent
    },
    {
      'icon': Icons.stars,
      'title': "Taste Satisfaction?",
      'subtitle': "Tell us how the Veggie Platter did on the flavor front!",
      'time': "1 week ago",
      'color': Colors.amber
    },
    {
      'icon': Icons.refresh,
      'title': "Order Tweaked!",
      'subtitle':
          "Added Gourmet Cheese to your kit. Next week just got tastier!",
      'time': "13 days ago",
      'color': Colors.green
    },
    {
      'icon': Icons.restaurant_menu,
      'title': "Fresh Flavors Unveiled!",
      'subtitle': "New menu items are in! What will you try next?",
      'time': "4 days ago",
      'color': Colors.brown
    },
    {
      'icon': Icons.local_shipping,
      'title': "Delivery Day!",
      'subtitle': "Your meal kit, now with extra cheese, is arriving today.",
      'time': "2 weeks ago",
      'color': Colors.deepOrange
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Notifications",
                        style: GoogleFonts.roboto(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close, size: 22.sp)),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: ListView.separated(
                      itemCount: notifications.length,
                      separatorBuilder: (_, __) => SizedBox(height: 2.h),
                      itemBuilder: (context, index) {
                        final item = notifications[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon Bubble
                            CircleAvatar(
                              radius: 3.h,
                              backgroundColor: item['color'].withOpacity(0.1),
                              child: Icon(item['icon'],
                                  color: item['color'], size: 3.2.h),
                            ),
                            SizedBox(width: 4.w),
                            // Text Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: GoogleFonts.roboto(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    item['subtitle'],
                                    style: GoogleFonts.roboto(
                                      fontSize: 16.sp,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 2.w),
                            // Time Text
                            Text(
                              item['time'],
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
