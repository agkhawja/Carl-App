// ignore_for_file: avoid_print, use_build_context_synchronously, unused_element, unused_field

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AskNutriAi extends StatefulWidget {
  const AskNutriAi({super.key});

  @override
  State<AskNutriAi> createState() => _AskNutriAiState();
}

class _AskNutriAiState extends State<AskNutriAi> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _streamedResponse = "";
  bool _isLoading = false;
  int uniqueId = 0;
  bool isClose = false;
  late stt.SpeechToText _speech;
  bool _fullNameError = false;
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _generateUniqueId() {
    final random = Random();
    setState(() {
      uniqueId = random.nextInt(1000000);
    });
  }

  void _resetError(TextEditingController controller) {
    setState(() {
      if (controller == _controller) _fullNameError = false;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _speech = stt.SpeechToText(); // ✅ initialize the speech recognizer
  //   _messages.add({
  //     "role": "bot",
  //     "message":
  //         "Hi there! I'm your NutriAI assistant. How can I help with your nutrition today?"
  //   });
  //   _generateUniqueId();
  // }

  @override
  void initState() {
    super.initState();
    try {
      _speech = stt.SpeechToText();
      _messages.add({
        "role": "bot",
        "message":
            "Hi there! I'm your NutriAI assistant. How can I help with your nutrition today?"
      });
      _generateUniqueId();
    } catch (e) {
      debugPrint('Error initializing speech: $e');
    }
  }

  Future<void> _sendMessage(String message) async {
    setState(() {
      _messages.add({"role": "user", "message": message});
      _isLoading = true;
    });

    _scrollToBottom();
    await _streamBotResponse(message);

    setState(() {
      _isLoading = false;
    });

    _controller.clear();
  }

  Future<void> _streamBotResponse(String message) async {
    const url = 'https://ai-apis-m6xtm.ondigitalocean.app/onboarding_chatbot';
    final String encodedPhoneNumber = Uri.encodeQueryComponent(message);
    message = encodedPhoneNumber;

    final request =
        http.Request('POST', Uri.parse('$url?query=$message&id=$uniqueId'))
          ..headers['accept'] = 'application/json';

    final streamedResponse = await request.send();

    setState(() {
      _streamedResponse = "";
    });

    streamedResponse.stream.transform(utf8.decoder).listen((chunk) {
      try {
        final jsonResponse = jsonDecode(chunk);
        final message = jsonResponse['response'];
        final onboardingCompleted =
            jsonResponse['onboarding_completed'] ?? false;

        setState(() {
          _streamedResponse = message;
        });

        _scrollToBottom();

        if (onboardingCompleted) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              // Navigator.of(context).pushReplacement(
              //   MaterialPageRoute(
              //     builder: (context) => SignInScreen(),
              //   ),
              // );
            }
          });
        }
      } catch (e) {
        setState(() {
          _streamedResponse = "Error parsing response: $e";
        });
      }
    }, onDone: () {
      setState(() {
        _messages.add({"role": "bot", "message": _streamedResponse});
        _streamedResponse = "";
      });
      _scrollToBottom();
    }, onError: (error) {
      setState(() {
        _messages.add({"role": "bot", "message": "Error: $error"});
      });
      _scrollToBottom();
    });
  }

  Future<String> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson == null) return 'User';
    Map<String, dynamic> user = json.decode(userJson);
    return user['username'] ?? 'User';
  }

  Future<void> _requestPermission() async {
    var status = await Permission.microphone.request();
    print('Permission request result: $status');
    if (status.isGranted) {
      print('Microphone permission granted');
    } else if (status.isDenied) {
      print('Microphone permission denied');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );
    } else if (status.isPermanentlyDenied) {
      print('Microphone permission permanently denied');
      await _showPermissionDialog();
    }
  }

  Future<void> _showPermissionDialog() async {
    bool? openSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission Required'),
        content: const Text(
          'This app needs microphone access for voice input. Please enable it in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );

    if (openSettings == true) {
      print('Opening app settings...');
      await openAppSettings();
      var status = await Permission.microphone.status;
      print('Permission status after returning from settings: $status');
    } else {
      print('User chose not to open settings');
    }
  }

  // Future<void> _listen(TextEditingController controller) async {
  //   // print('Mic button pressed for controller: ${controller.hashCode}');
  //   // var status = await Permission.microphone.status;
  //   // print('Current permission status before listen: $status');

  //   // if (!status.isGranted) {
  //   //   // await _requestPermission();
  //   //   status = await Permission.microphone.status;
  //   //   print('Permission status after request: $status');
  //   //   if (!status.isGranted) return;
  //   // }

  //   print('Initializing speech recognition...');
  //   bool available = await _speech.initialize(
  //     onStatus: (status) => print('Speech status: $status'),
  //     onError: (error) => print('Speech error: $error'),
  //   );
  //   if (available) {
  //     print('Starting to listen...');
  //     _speech.listen(
  //       onResult: (result) {
  //         print('Speech result: ${result.recognizedWords}');
  //         setState(() {
  //           controller.text = result.recognizedWords;
  //           _resetError(controller);
  //         });
  //       },
  //     );
  //   } else {
  //     print('Speech recognition not available');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Speech recognition not available')),
  //     );
  //   }
  // }

  Future<void> _listen(TextEditingController controller) async {
    try {
      var status = await Permission.microphone.status;
      if (!status.isGranted) {
        status = await Permission.microphone.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission required')),
          );
          return;
        }
      }

      bool available = await _speech.initialize(
        onStatus: (status) => debugPrint('Speech status: $status'),
        onError: (error) => debugPrint('Speech error: $error'),
      );

      if (!available) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition not available')),
        );
        return;
      }

      _speech.listen(
        onResult: (result) {
          setState(() {
            controller.text = result.recognizedWords;
            _resetError(controller);
          });
        },
      );
    } catch (e) {
      debugPrint('Error in _listen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEBEBEB),
      appBar: AppBar(
        backgroundColor: const Color(0xffEBEBEB),
        // foregroundColor: const Color.fromARGB(255, 72, 74, 159),
        leadingWidth: 100.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 2.5.w),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios, size: 16.sp),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              CircleAvatar(
                radius: 6.5.w,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    const AssetImage('assests/home_screen/profile_pic.png'),
              ),
              SizedBox(width: 2.w),
              Flexible(
                child: FutureBuilder<String>(
                  future: _getUsername(),
                  builder: (context, snapshot) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            color: const Color(0xff000000),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          snapshot.data ?? 'User',
                          style: GoogleFonts.roboto(
                            fontSize: 17.5.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: Image.asset(
              'assests/home_screen/bell_icon.png',
              width: 22.sp,
              height: 22.sp,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            if (!isClose)
              Padding(
                padding: EdgeInsets.all(15.sp),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'AI Nutritionist',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff1F1F1F),
                              fontSize: 17.sp,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => isClose = true),
                            icon: Icon(Icons.close, size: 17.sp),
                          ),
                        ],
                      ),
                      Text(
                        'Hi there! I\'m your NutriAI assistant. How can I help with your nutrition today?',
                        style: GoogleFonts.roboto(
                          fontSize: 14.5.sp,
                          color: const Color(0xff707070),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount:
                      _messages.length + (_streamedResponse.isNotEmpty ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_streamedResponse.isNotEmpty && index == 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 0.h),
                        child: ChatBubble(
                          message: _streamedResponse,
                          isUser: false,
                        ),
                      );
                    } else if (_messages.isEmpty || index >= _messages.length) {
                      return const SizedBox.shrink();
                    }
                    final message = _messages[_messages.length - index - 1];
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
                      child: ChatBubble(
                        message: message['message']!,
                        isUser: message['role'] == 'user',
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_isLoading)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Image.asset(
                    'assets/images/loading.gif',
                    color: const Color.fromARGB(255, 72, 74, 159),
                    width: 45.w,
                    height: 8.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            Container(
              padding: EdgeInsets.only(
                  bottom: 3.5.h, top: 2.h, left: 5.w, right: 4.w),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 2,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        fillColor: const Color(0xffEBEBEB),
                        filled: true,
                        hintText: 'Ask me anything..',
                        hintStyle: GoogleFonts.roboto(
                          color: const Color(0xff8F8F8F),
                          fontSize: 14.sp,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.mic_none_outlined,
                              color: Colors.black),
                          onPressed: () => _listen(_controller),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _sendMessage(_controller.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isUser
                ? const Color.fromARGB(255, 72, 74, 159)
                : const Color.fromARGB(255, 224, 222, 222),
            borderRadius: BorderRadius.only(
              topLeft: isUser ? const Radius.circular(20) : Radius.zero,
              topRight: isUser ? Radius.zero : const Radius.circular(20),
              bottomLeft: const Radius.circular(20),
              bottomRight: const Radius.circular(20),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
