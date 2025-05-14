import 'package:carl/settings_screens/ai_recipe_history.dart';
import 'package:carl/settings_screens/dietary_prefrence_screen.dart';
import 'package:carl/settings_screens/notification_screen.dart';
import 'package:carl/settings_screens/privacy_policy_screen.dart';
import 'package:carl/settings_screens/profile_settings_screes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isPushNotificationEnabled = true;

  Widget buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        child: Row(
          children: [
            Icon(icon, size: 22.sp, color: Color(0xff0A0615)),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.roboto(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff707070))),
                  SizedBox(height: 0.5.h),
                  Text(subtitle,
                      style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          color: Color(0xff9299A3),
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            if (showChevron && onTap != null)
              Icon(Icons.chevron_right, size: 22.sp, color: Color(0xff707070)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Settings',
                    style: GoogleFonts.roboto(
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff0A0615),
                    )),
                SizedBox(height: 1.h),
                Text(
                  'Update your settings like notification, diet preference, profile edit etc.',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: Color(0xff9299A3),
                  ),
                ),
                SizedBox(height: 3.h),
                buildSettingItem(
                  icon: Icons.person,
                  title: 'Profile Information',
                  subtitle: 'Change your information',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProfileSettingsScreen();
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 11.5.w),
                  child: Divider(color: Color(0xffE5E9EF)),
                ),
                buildSettingItem(
                  icon: Icons.book,
                  title: 'Dietary Preferences',
                  subtitle: 'Add your diet preference',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DietaryPreferenceScreen();
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 11.5.w),
                  child: Divider(color: Color(0xffE5E9EF)),
                ),
                buildSettingItem(
                  icon: Icons.access_time_filled,
                  title: 'Ai Recipe History',
                  subtitle: 'See history to make more better dishes',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AiRecipeHistoryScreen();
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 11.5.w),
                  child: Divider(color: Color(0xffE5E9EF)),
                ),
                buildSettingItem(
                  icon: Icons.privacy_tip,
                  title: 'Privacy',
                  subtitle: 'Terms & Conditions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PrivacyPolicyScreen();
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 11.5.w),
                  child: Divider(color: Color(0xffE5E9EF)),
                ),
                buildSettingItem(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: null, // Makes row non-clickable
                  showChevron: false, // Hides the chevron icon
                ),
                Padding(
                  padding: EdgeInsets.only(left: 11.5.w),
                  child: Divider(color: Color(0xffE5E9EF)),
                ),
                Text('Notification',
                    style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff9299A3))),
                SizedBox(height: 2.h),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NotificationsScreen();
                        },
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.notifications,
                          size: 22.sp, color: Color(0xff0A0615)),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Push Notification',
                                style: GoogleFonts.roboto(
                                    fontSize: 17.sp,
                                    color: Color(0xff707070),
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 0.5.h),
                            Text('For Daily updates',
                                style: GoogleFonts.roboto(
                                    fontSize: 15.sp, color: Color(0xff9299A3))),
                          ],
                        ),
                      ),
                      Switch(
                        activeColor: Colors.white,
                        focusColor: Colors.white,
                        activeTrackColor: Colors.black,
                        value: isPushNotificationEnabled,
                        onChanged: (value) {
                          setState(() {
                            isPushNotificationEnabled = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 11.5.w, top: 0.5.h),
                  child: Divider(color: Color(0xffE5E9EF)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
