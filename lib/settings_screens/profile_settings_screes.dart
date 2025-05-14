// ignore_for_file: unused_field, avoid_print, unused_element

import 'dart:convert';
import 'dart:io';
import 'package:carl/api/api_service.dart';
import 'package:carl/auth/login_screen.dart';
import 'package:carl/settings_screens/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String username = '';
  String userEmail = '';
  bool isLoading = false;
  File? _image;
  String? _imageUrl;
  int? _imageId;
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _getUserNameAndEmail();
  }

  // Fetch username, email, and profile image from SharedPreferences
  Future<void> _getUserNameAndEmail() async {
    setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user');
      if (userJson != null) {
        Map<String, dynamic> user = json.decode(userJson);
        setState(() {
          username = user['username'] ?? 'User';
          userEmail = user['email'] ?? '';
          // Load existing profile image URL if available
          if (user['profile_image'] != null &&
              user['profile_image']['url'] != null) {
            _imageUrl = user['profile_image']['url'];
          }
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _imageUrl = null; // Clear existing URL to show picked image
        });
        // await _uploadImage();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  // Upload image to server
  Future<void> _uploadImage() async {
    if (_image == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Ensure the file exists
      if (!await _image!.exists()) {
        throw Exception('Image file does not exist');
      }

      final imageResponse = await _apiService.uploadImage(_image!);
      if (imageResponse.isNotEmpty && imageResponse[0]['id'] != null) {
        setState(() {
          _imageUrl = imageResponse[0]['url'];
          _imageId = imageResponse[0]['id'];
        });
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
      setState(() {
        _image = null;
        _imageId = null;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Save profile image by calling updateProfileImage API
  Future<void> _saveProfileImage() async {
    if (_image == null && _imageId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image first')),
        );
      }
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // If image is selected but not uploaded yet
      if (_image != null && _imageId == null) {
        final imageResponse = await _apiService.uploadImage(_image!);
        if (imageResponse.isNotEmpty && imageResponse[0]['id'] != null) {
          _imageUrl = imageResponse[0]['url'];
          _imageId = imageResponse[0]['id'];
        } else {
          throw Exception('Failed to upload image');
        }
      }

      if (_imageId != null) {
        final response =
            await _apiService.updateProfileImage(context, image_id: _imageId);
        if (response.containsKey('error')) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  response['error']['message'] ??
                      'Failed to update profile image',
                ),
              ),
            );
          }
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? userJson = prefs.getString('user');
          if (userJson != null) {
            final Map<String, dynamic> userMap = json.decode(userJson);
            userMap['profile_image'] = {'id': _imageId, 'url': _imageUrl};
            await prefs.setString('user', json.encode(userMap));
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Profile image updated successfully')),
            );
          }
          setState(() {
            _image = null; // Clear after saving
            _imageId = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile image: $e')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              "Confirm Logout",
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: 18.sp,
              ),
            ),
          ),
          content: Text(
            "Do you want to logout your account?",
            style: GoogleFonts.roboto(
              fontSize: 15.5.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xff707070),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.roboto(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove("jwt");
                await prefs.remove("user");

                if (context.mounted) {
                  Navigator.of(dialogContext).pop(); // Close dialog
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              child: Text(
                "Logout",
                style: GoogleFonts.roboto(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile Settings",
          style: GoogleFonts.roboto(fontSize: 18.sp, color: Color(0xff0A0615)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xffDFE5E8),
                        radius: 32.sp,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : _imageUrl != null
                                ? NetworkImage(
                                    "${"https://c502-39-60-230-244.ngrok-free.app"}${_imageUrl!}")
                                : null,
                        child: _image == null && _imageUrl == null
                            ? Icon(
                                Icons.person,
                                size: 40.sp,
                                color: Color(0xffAEB6BA),
                              )
                            : null,
                      ),
                      InkWell(
                        onTap: _pickImage,
                        child: Text(
                          'Change Profile Picture',
                          style: GoogleFonts.roboto(
                              color: Color(0xff9299A3), fontSize: 15.5.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  label("Full Name"),
                  textField(initialText: username),
                  label("Email"),
                  textField(initialText: userEmail),
                  label("Phone Number"),
                  textField(initialText: "+92345677890"),
                  label("Password"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: textField(
                          initialText: "************",
                          obscure: true,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Change",
                          style: GoogleFonts.roboto(
                            fontSize: 16.5.sp,
                            color: Color(0xff2D5591),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  fullButton(context, "Save", onPressed: _saveProfileImage),
                  SizedBox(height: 2.h),
                  outlinedButton("Logout", onPressed: () {
                    _showLogoutConfirmationDialog(context);
                  }),
                ],
              ),
            ),
    );
  }

  Widget label(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 0.5.h),
      child: Text(
        text,
        style: GoogleFonts.roboto(fontSize: 15.sp, color: Color(0xff9299A3)),
      ),
    );
  }

  Widget textField({required String initialText, bool obscure = false}) {
    return TextFormField(
      readOnly: true,
      initialValue: initialText,
      style: GoogleFonts.roboto(
        color: Color(0xff707070),
        fontSize: 16.sp,
      ),
      obscureText: obscure,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 1.5.h),
        isDense: true,
        border: InputBorder.none,
      ),
    );
  }

  Widget fullButton(BuildContext context, String text,
      {required VoidCallback onPressed}) {
    return SizedBox(
      width: 100.w,
      height: 6.5.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
        child: Text(
          text,
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget outlinedButton(String text, {required VoidCallback onPressed}) {
    return SizedBox(
      width: 100.w,
      height: 6.5.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: GoogleFonts.roboto(fontSize: 18.sp, color: Colors.black),
        ),
      ),
    );
  }
}
