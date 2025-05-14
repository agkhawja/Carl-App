// ignore_for_file: avoid_print, non_constant_identifier_names, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String url = 'https://9d23-119-156-121-136.ngrok-free.app/api';
  //https://8f03-39-60-229-211.ngrok-free.app
  //https://9d23-119-156-121-136.ngrok-free.app

  Future<Map<String, dynamic>> signUpviaEmailPassword(
    BuildContext context,
    String username,
    String email,
    String password,
  ) async {
    try {
      String i =
          '$url/auth/local/register'; // Ensure 'url' is defined correctly
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      Map<String, dynamic> item = json.decode(response.body);
      print('API Raw Response: ${response.body}');
      print('API Decoded Response: $item');

      // Always return the response, regardless of status code
      return item;
    } catch (e) {
      print('Error Occurred: $e');
      // Return an error map instead of throwing or returning empty
      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> signInviaEmailPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      String i = '$url/auth/local';
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "identifier": email,
          "password": password,
        }),
      );

      Map<String, dynamic> item = json.decode(response.body);
      print('API Raw Response: ${response.body}');
      print('API Decoded Response: $item');

      return item;
    } catch (e) {
      print('Error Occurred: $e');

      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> getAllUserData(
    BuildContext context,
  ) async {
    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    String userJson = prefs.getString('user') ?? "";
    final Map<String, dynamic> userMap = json.decode(userJson);
    int userId = userMap['id'];
    try {
      String i = '$url/users/$userId';
      final response = await http.get(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic> item = json.decode(response.body);
      print('API Raw Response: ${response.body}');
      print('API Decoded Response: $item');
      Logger logger = Logger();
      print('API Raw Response Start');
      logger.d(response.body);
      print('API Raw Response End');
      print('API Decoded Response Start');
      logger.d(item);
      print('API Decoded Response End');

      return item;
    } catch (e) {
      print('Error Occurred: $e');

      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> getAllPantryData(
    BuildContext context,
  ) async {
    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    String userJson = prefs.getString('user') ?? "";
    final Map<String, dynamic> userMap = json.decode(userJson);
    int userId = userMap['id'];
    try {
      String i = '$url/pantries?filters[user][id][\$eq]=$userId';
      //https://9d23-119-156-121-136.ngrok-free.app/api/favourites?filters[user][id][$eq]=13
      //https://9d23-119-156-121-136.ngrok-free.app/api/pantries?filters[user][id][$eq]=13
      final response = await http.get(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic> item = json.decode(response.body);
      print('API Raw Response: ${response.body}');
      print('API Decoded Response: $item');
      Logger logger = Logger();
      print('API Raw Response Start');
      logger.d(response.body);
      print('API Raw Response End');
      print('API Decoded Response Start');
      logger.d(item);
      print('API Decoded Response End');

      return item;
    } catch (e) {
      print('Error Occurred: $e');

      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> getAllFavouritesData(
    BuildContext context,
  ) async {
    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    String userJson = prefs.getString('user') ?? "";
    final Map<String, dynamic> userMap = json.decode(userJson);
    int userId = userMap['id'];
    try {
      String i = '$url/favourites?filters[user][id][\$eq]=$userId';
      //https://9d23-119-156-121-136.ngrok-free.app/api/favourites?filters[user][id][$eq]=13
      //https://9d23-119-156-121-136.ngrok-free.app/api/favourites?filters[user][id][$eq]=13
      //https://9d23-119-156-121-136.ngrok-free.app/api/pantries?filters[user][id][$eq]=13
      final response = await http.get(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic> item = json.decode(response.body);
      print('API Raw Response: ${response.body}');
      print('API Decoded Response: $item');
      Logger logger = Logger();
      print('API Raw Response Start');
      logger.d(response.body);
      print('API Raw Response End');
      print('API Decoded Response Start');
      logger.d(item);
      print('API Decoded Response End');

      return item;
    } catch (e) {
      print('Error Occurred: $e');

      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile(
    BuildContext context, {
    String? selectedGender,
    String? selectedDate,
    String? selectedHeight,
    String? selectedWeight,
    String? selectedActivity,
    String? selectedLifeStyleAndSleepQuality,
    String? selectedDailyStressLevel,
    String? selectedPrimaryGoal,
    List<String>? selectedTypesofSportsPracticed,
    String?
        selectedBodyCompositionGoal, // Changed to List<String> to match cURL
    List<String>? selectedPrioritiesinWellBeing,
    List<String>? selectedRisks,
    List<String>? selectedDietaryRestrictions,
    List<String>? selectedMeals,
    String? selectedAlcoholicBeverages,
    String? selectedEatingYourMeals,
    String? timeSpendPreparingYourMealsDaily,
    String? eatOutPerWeek,
    String? sugaryDrinks,
    List<String>? selectedDietarySupplements,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userJson = prefs.getString('user') ?? "";
      final Map<String, dynamic> userMap = json.decode(userJson);
      int userId = userMap['id'];

      String endpoint = '$url/users/$userId?populate=*';

      final payload = {
        "gender": selectedGender,
        "dob": selectedDate,
        "height": selectedHeight,
        "weight": selectedWeight,
        "activity_level": selectedActivity,
        "sleep_quality": selectedLifeStyleAndSleepQuality,
        "daily_stress_level": selectedDailyStressLevel,
        "primary_goal": selectedPrimaryGoal,
        "sport_do_you_practice": selectedTypesofSportsPracticed,
        "body_composition_goal": selectedBodyCompositionGoal,
        "priority_in_well_being": selectedPrioritiesinWellBeing,
        "risks": selectedRisks,
        "dietary_restrictions_or_allergies": selectedDietaryRestrictions,
        "meals_consume_daily": selectedMeals,
        "alcohalic_beverages":
            selectedAlcoholicBeverages, // Note: typo kept to match cURL
        "time_spend_eating_your_meals_daily": selectedEatingYourMeals,
        "time_spend_preparing_meals_daily": timeSpendPreparingYourMealsDaily,
        "eat_out_per_week": eatOutPerWeek,
        "sugary_drinks": sugaryDrinks,
        "dietary_suplements":
            selectedDietarySupplements, // Note: typo kept to match cURL
      };

      Logger().d('Sending payload: $payload');

      final response = await http.put(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          // No authorization header since it works without in Postman
        },
        body: json.encode(payload),
      );

      Logger().d('Response status: ${response.statusCode}');
      Logger().d('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return {
          'error': {
            'message': 'API error: ${response.body}',
            'status': response.statusCode,
          }
        };
      }
    } catch (e) {
      Logger().e('Error in updateProfile: $e');
      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
        }
      };
    }
  }

  Future<Map<String, dynamic>> updateProfileImage(BuildContext context,
      {int? image_id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userJson = prefs.getString('user') ?? "";
      final Map<String, dynamic> userMap = json.decode(userJson);
      int userId = userMap['id'];

      String endpoint = '$url/users/$userId?populate=*';

      final payload = {
        "profile_image": {"id": image_id},
      };

      Logger().d('Sending payload: $payload');

      final response = await http.put(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          // No authorization header since it works without in Postman
        },
        body: json.encode(payload),
      );

      Logger().d('Response status: ${response.statusCode}');
      Logger().d('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return {
          'error': {
            'message': 'API error: ${response.body}',
            'status': response.statusCode,
          }
        };
      }
    } catch (e) {
      Logger().e('Error in updateProfile: $e');
      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
        }
      };
    }
  }

  Future<Map<String, dynamic>> changePasswordApi(
    BuildContext context,
    String currentPassword,
    String password,
    String passwordConfirmation,
  ) async {
    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    try {
      String i = '$url/auth/change-password';
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "currentPassword": currentPassword,
          "password": password,
          "passwordConfirmation": passwordConfirmation,
        }),
      );

      Map<String, dynamic> item = json.decode(response.body);
      print('API Raw Response: ${response.body}');
      print('API Decoded Response: $item');

      return item;
    } catch (e) {
      print('Error Occurred: $e');

      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> foodPrefrenceApi(
    BuildContext context,
    List<String>? foods_you_like,
    List<String>? foods_to_avoid,
    List<String>? dietary_preferences,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt');
      String? userJson = prefs.getString('user');

      if (token == null || userJson == null) {
        return {
          'error': {
            'message': 'User not logged in or token missing',
            'status': 401,
            'name': 'AuthError'
          }
        };
      }

      int userId = json.decode(userJson)['id'];

      String i = '$url/food-preferences';
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "data": {
            "foods_you_like": foods_you_like,
            "foods_to_Avoid": foods_to_avoid,
            "dietary_Preferences": dietary_preferences,
            "users_permissions_user":
                userId // 👈 Linking the preference to the user
          }
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Raw Response: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> item = json.decode(response.body);
        print('API Decoded Response: $item');
        return item;
      } else {
        return {
          'error': {
            'message': 'Failed to save preferences: ${response.body}',
            'status': response.statusCode,
            'name': 'APIError'
          }
        };
      }
    } catch (e) {
      print('Error Occurred: $e');
      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> pantryAddtoFavouriteApi(
    BuildContext context,
    bool isFavourite,
    int pantryId,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt');
      String? userJson = prefs.getString('user');

      if (token == null || userJson == null) {
        return {
          'error': {
            'message': 'User not logged in or token missing',
            'status': 401,
            'name': 'AuthError'
          }
        };
      }

      int userId = json.decode(userJson)['id'];

      String i = '$url/favourites';
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "data": {
            "isFavourite": isFavourite,
            "user": userId,
            "pantry": pantryId,
          }
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Raw Response: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> item = json.decode(response.body);
        print('API Decoded Response: $item');
        return item;
      } else {
        return {
          'error': {
            'message': 'Failed to save preferences: ${response.body}',
            'status': response.statusCode,
            'name': 'APIError'
          }
        };
      }
    } catch (e) {
      print('Error Occurred: $e');
      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<bool> pantryRemoveFromFavouriteApi({
    required String favoriteDocumentId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    try {
      final response = await http.delete(
        Uri.parse('$url/favourites/$favoriteDocumentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Create Service Error: $e');
      return false;
    }
  }

  Future<bool> deletePantryIngredients({
    // required BuildContext context,
    required String pantryId,
    // required String token,
    // int? imageId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    try {
      final response = await http.delete(
        Uri.parse('$url/pantries/$pantryId'),
        //https://9d23-119-156-121-136.ngrok-free.app/api/pantries/im14obmc2f6f62zyrb30najp
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: jsonEncode(requestBody),
      );

      if (response.statusCode == 204) {
        // if (context.mounted) {
        //   ScaffoldMessenger.of(context)
        //       .showSnackBar(SnackBar(content: Text("Delete Successfully")));
        // }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Create Service Error: $e');
      return false;
    }
  }

  Future<bool> deleteActualGrocery({
    required String groceryDocumentId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    try {
      final response = await http.delete(
        Uri.parse('$url/grocery-lists/$groceryDocumentId'),
        //https://9d23-119-156-121-136.ngrok-free.app/api/grocery-lists/fp546tusqubis103782nhgh9
        //https://9d23-119-156-121-136.ngrok-free.app/api/pantries/im14obmc2f6f62zyrb30najp
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: jsonEncode(requestBody),
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Create Service Error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> recipeGenerateApi(
    BuildContext context,
    String How_much_time_do_you_have_to_cook,
    String How_many_people_did_you_want_to_cook_for,
    String How_healthy_do_you_want_your_meal_to_be,
    String image_url,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt');
      String? userJson = prefs.getString('user');

      if (token == null || userJson == null) {
        return {
          'error': {
            'message': 'User not logged in or token missing',
            'status': 401,
            'name': 'AuthError'
          }
        };
      }

      // int userId = json.decode(userJson)['id'];

      String i = '$url/recipes';
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "data": {
            "How_much_time_do_you_have_to_cook":
                How_much_time_do_you_have_to_cook,
            "How_many_people_did_you_want_to_cook_for":
                How_many_people_did_you_want_to_cook_for,
            "How_healthy_do_you_want_your_meal_to_be":
                How_healthy_do_you_want_your_meal_to_be,
            "image_url": image_url
          }
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Raw Response: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> item = json.decode(response.body);
        print('API Decoded Response: $item');
        return item;
      } else {
        return {
          'error': {
            'message': 'Failed to Generate: ${response.body}',
            'status': response.statusCode,
            'name': 'APIError'
          }
        };
      }
    } catch (e) {
      print('Error Occurred: $e');
      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> pantryAddIngredients(
    BuildContext context,
    String? Ingredient,
    String? Quantity,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt');
      String? userJson = prefs.getString('user');

      if (token == null || userJson == null) {
        return {
          'error': {
            'message': 'User not logged in or token missing',
            'status': 401,
            'name': 'AuthError'
          }
        };
      }

      int userId = json.decode(userJson)['id'];

      String i = '$url/pantries';
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "data": {
            "Ingredient": Ingredient,
            "Quantity": Quantity,
            "user": userId
          }
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Raw Response: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> item = json.decode(response.body);
        print('API Decoded Response: $item');
        return item;
      } else {
        return {
          'error': {
            'message': 'Failed to Generate: ${response.body}',
            'status': response.statusCode,
            'name': 'APIError'
          }
        };
      }
    } catch (e) {
      print('Error Occurred: $e');
      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> feedbackRatingApi(
    BuildContext context, {
    double? rating_stars_after_cooking,
    String? feedback_before_cooking,
    String? feedback_after_cooking,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt');
      String? userJson = prefs.getString('user');

      if (token == null || userJson == null) {
        return {
          'error': {
            'message': 'Token is missing',
            'status': 401,
            'name': 'AuthError'
          }
        };
      }

      int userId = json.decode(userJson)['id'];

      String i = '$url/feedbacks';
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "data": {
            "rating_stars_after_cooking": rating_stars_after_cooking,
            "feedback_after_cooking": feedback_after_cooking,
            "feedback_before_cooking": feedback_before_cooking,
            "user": userId,
          }
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Raw Response: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> item = json.decode(response.body);
        print('API Decoded Response: $item');
        return item;
      } else {
        return {
          'error': {
            'message': 'Failed to Generate: ${response.body}',
            'status': response.statusCode,
            'name': 'APIError'
          }
        };
      }
    } catch (e) {
      print('Error Occurred: $e');
      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> addAISuggestedGroceryToActualGrocery(
    BuildContext context, {
    required String grocery_title,
    required String grocery_quantity,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt');
      String? userJson = prefs.getString('user');

      if (token == null || userJson == null) {
        return {
          'error': {
            'message': 'Token is missing',
            'status': 401,
            'name': 'AuthError'
          }
        };
      }

      int userId = json.decode(userJson)['id'];

      String i = '$url/grocery-lists';
      //grocery-lists
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "data": {
            "grocery_title": grocery_title,
            "grocery_quantity": grocery_quantity,
            "user": userId,
          }
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Raw Response: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> item = json.decode(response.body);
        print('API Decoded Response: $item');
        return item;
      } else {
        return {
          'error': {
            'message': 'Failed to Generate: ${response.body}',
            'status': response.statusCode,
            'name': 'APIError'
          }
        };
      }
    } catch (e) {
      print('Error Occurred: $e');
      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> foodPrefrenceApiputApi(
    BuildContext context,
    List<String>? foods_you_like,
    List<String>? foods_to_avoid,
    List<String>? dietary_preferences,
    String documentId, // Added documentId parameter
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt');

      if (token == null) {
        return {
          'error': {
            'message': 'User not logged in or token missing',
            'status': 401,
            'name': 'AuthError'
          }
        };
      }

      // Note: Assuming 'url' is defined elsewhere, e.g., in a constants file
      String apiUrl = '$url/food-preferences/$documentId';
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "data": {
            "foods_you_like": foods_you_like,
            "foods_to_Avoid": foods_to_avoid,
            "dietary_Preferences": dietary_preferences,
          }
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> item = json.decode(response.body);
        print('API Decoded Response: $item');
        return item;
      } else {
        return {
          'error': {
            'message': 'Failed to update preferences: ${response.body}',
            'status': response.statusCode,
            'name': 'APIError'
          }
        };
      }
    } catch (e) {
      print('Error Occurred: $e');
      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> foodPrefrenceGetAllData(
    BuildContext context,
    // String currentUserId,
  ) async {
    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    String? userJson = prefs.getString('user');

    if (token == null || userJson == null) {
      return {
        'error': {
          'message': 'User not logged in or token missing',
          'status': 401,
          'name': 'AuthError'
        }
      };
    }

    int userId = json.decode(userJson)['id'];
    try {
      //https://c502-39-60-230-244.ngrok-free.app/api/food-preferences?filters[users_permissions_user][id][$eq]=7&populate=*
      String i =
          '$url/food-preferences?filters[users_permissions_user][id][\$eq]=$userId&populate=*';
      final response = await http.get(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic> item = json.decode(response.body);

      Logger logger = Logger();
      logger.d(userId);

      return item;
    } catch (e) {
      print('Error Occurred: $e');

      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> getAllActualGroceryData(
    BuildContext context,
    // String currentUserId,
  ) async {
    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    String? userJson = prefs.getString('user');

    if (token == null || userJson == null) {
      return {
        'error': {
          'message': 'User not logged in or token missing',
          'status': 401,
          'name': 'AuthError'
        }
      };
    }

    int userId = json.decode(userJson)['id'];
    try {
      //https://c502-39-60-230-244.ngrok-free.app/api/food-preferences?filters[users_permissions_user][id][$eq]=7&populate=*
      String i =
          '$url/grocery-lists?filters[user][id][\$eq]=$userId&populate=*';
      //https://9d23-119-156-121-136.ngrok-free.app/api/grocery-lists?filters[user][id][$eq]=13&populate=*
      final response = await http.get(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic> item = json.decode(response.body);

      Logger logger = Logger();
      logger.d(userId);

      return item;
    } catch (e) {
      print('Error Occurred: $e');

      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> getAllLikedPantryItemsData(
    BuildContext context,
    // String currentUserId,
  ) async {
    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    String? userJson = prefs.getString('user');

    if (token == null || userJson == null) {
      return {
        'error': {
          'message': 'User not logged in or token missing',
          'status': 401,
          'name': 'AuthError'
        }
      };
    }

    int userId = json.decode(userJson)['id'];
    try {
      //https://c502-39-60-230-244.ngrok-free.app/api/food-preferences?filters[users_permissions_user][id][$eq]=7&populate=*
      String i = '$url/favourites?filters[user][id][\$eq]=$userId&populate=*';
      //https://9d23-119-156-121-136.ngrok-free.app/api/favourites?filters[user][id][$eq]=13&populate=*
      final response = await http.get(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic> item = json.decode(response.body);

      Logger logger = Logger();
      logger.d(userId);

      return item;
    } catch (e) {
      print('Error Occurred: $e');

      return {
        'error': {
          'message': 'Network error: $e',
          'status': 0,
          'name': 'NetworkError'
        }
      };
    }
  }

  Future<Map<String, dynamic>> generateRecipes(
      Map<String, dynamic> userData) async {
    const String apiUrl =
        'https://d096-39-63-45-130.ngrok-free.app/generate-recipes/';
    print("UsserData: ${userData}");
    Logger logger = Logger();
    logger.d(userData);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully generated recipes: ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print(
            'Failed to generate recipes. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('Failed to generate recipes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while generating recipes: $e');
      throw Exception('Error occurred while generating recipes: $e');
    }
  }

  Future<Map<String, dynamic>> generateGrocerythroughAIApi(
      Map<String, dynamic> userData) async {
    const String apiUrl =
        'https://ee84-182-190-160-104.ngrok-free.app/generate-grocery-list/';
    //https://ee84-182-190-160-104.ngrok-free.app/docs
    //https://3ba3-119-154-234-132.ngrok-free.app/generate-grocery-list/
    print("UserData: ${userData}");
    Logger logger = Logger();
    logger.d(userData);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully generated groceries: ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print(
            'Failed to generate groceries. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('Failed to generate recipes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while generating groceries: $e');
      throw Exception('Error occurred while generating groceries: $e');
    }
  }

  Future<Map<String, dynamic>> signUpPhoneCode(
    BuildContext context,
    String phoneNumber,
  ) async {
    try {
      String i = '$url/service-provider-auth/signup';
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "phoneNumber": phoneNumber,
          // "email": email,
          // "name": name,
        }),
      );

      Map<String, dynamic> item = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return item;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(item["error"]["message"]),
            ),
          );
        }
        return {};
      }
    } catch (e) {
      debugPrint('Error Occurred: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error in Response'),
          ),
        );
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> signUpVerify(
    BuildContext context,
    String phoneNumber,
    String email,
    String name,
    String otpCode,
    // String otpId,
  ) async {
    try {
      String i = '$url/service-provider-auth/verify-signup';
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "phoneNumber": phoneNumber,
          "email": email,
          "name": name,
          "code": otpCode,
          // "otpId": otpId
        }),
      );

      Map<String, dynamic> item = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return item;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(item["error"]["message"]),
            ),
          );
        }
        return {};
      }
    } catch (e) {
      debugPrint('Error Occurred: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error in Response'),
          ),
        );
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> signInPhoneCode(
    BuildContext context,
    String phoneNumber,
  ) async {
    try {
      String i = '$url/service-provider-auth/login';
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "phoneNumber": phoneNumber,
          // "email": email,
          // "name": name,
        }),
      );

      Map<String, dynamic> item = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return item;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(item["error"]["message"]),
            ),
          );
        }
        return {};
      }
    } catch (e) {
      debugPrint('Error Occurred: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error in Response'),
          ),
        );
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> signInVerify(
    BuildContext context,
    String phoneNumber,
    // String email,
    // String name,
    String otpCode,
    // String otpId,
  ) async {
    try {
      String i = '$url/service-provider-auth/verify-login';
      final response = await http.post(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "phoneNumber": phoneNumber,
          // "email": email,
          // "name": name,
          "code": otpCode,
          // "otpId": otpId
        }),
      );

      Map<String, dynamic> item = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return item;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(item["error"]["message"]),
            ),
          );
        }
        return {};
      }
    } catch (e) {
      debugPrint('Error Occurred: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error in Response'),
          ),
        );
      }
    }
    return {};
  }

  Future<Map<String, dynamic>> getAllProfessions(
    BuildContext context,
    // String token,
  ) async {
    try {
      String i = '$url/professions?populate=*';
      final response = await http.get(
        Uri.parse(i),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Authorization': 'Bearer $token',
        },
      );
      Map<String, dynamic> item = json.decode(response.body);
      if (response.statusCode == 200) {
        return item;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(item["error"]["message"]),
            ),
          );
        }
        return {};
      }
    } catch (e) {
      debugPrint('Error Occurred$e');
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Error in Response')));
      }
    }
    return {};
  }

  Future<List<dynamic>> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/upload'),
      );
      // request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('files', imageFile.path),
      );

      final response = await request.send();
      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);
        print(
            "Image response:-------------------------------------${jsonData}");
        return jsonData;
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Image Upload Error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createService({
    required String name,
    required String description,
    required double price,
    required int serviceProviderId,
    required String token,
    int? imageId,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "data": {
          "name": name,
          "description": description,
          "price": price,
          "image": imageId,
          "serviceProviderId": serviceProviderId,
        },
      };

      final response = await http.post(
        Uri.parse('$url/services'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      Map<String, dynamic> item = json.decode(response.body);
      print("service response:-------------------------------------${item}");

      return item;
    } catch (e) {
      debugPrint('Create Service Error: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> updateService({
    required String serviceId,
    required String name,
    required String description,
    required double price,
    required int serviceProviderId,
    required String token,
    int? imageId,
  }) async {
    print("Service Doc ID-------------------------$serviceId");
    // Implement your API call to update service
    // Return response in format: {'data': {...service data...}}
    try {
      final Map<String, dynamic> requestBody = {
        "data": {
          "name": name,
          "description": description,
          "price": price,
          "image": imageId,
          "serviceProviderId": serviceProviderId,
        },
      };

      final response = await http.put(
        Uri.parse('$url/services/$serviceId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      Map<String, dynamic> item = json.decode(response.body);
      print("service response:-------------------------------------${item}");

      return item;
    } catch (e) {
      debugPrint('Create Service Error: $e');
      return {};
    }
  }

  Future<bool> deleteService({
    // required BuildContext context,
    required String serviceId,
    required String token,
    int? imageId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$url/services/$serviceId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: jsonEncode(requestBody),
      );

      if (response.statusCode == 204) {
        // if (context.mounted) {
        //   ScaffoldMessenger.of(context)
        //       .showSnackBar(SnackBar(content: Text("Delete Successfully")));
        // }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Create Service Error: $e');
      return false;
    }
  }

  Future<bool> updateSchedule(String serviceProviderDocId, String token,
      Map<String, dynamic> schedule) async {
    final i = Uri.parse('$url/service-providers/$serviceProviderDocId');
    final response = await http.put(
      i,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'data': {
          'schedule': schedule,
        }
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(
          'Failed to update schedule: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  Future<List<int>> uploadImages(List<File> images) async {
    var uri = Uri.parse('$url/upload');
    var request = http.MultipartRequest('POST', uri);

    // Add all image files to the request
    for (var image in images) {
      request.files.add(await http.MultipartFile.fromPath('files', image.path));
    }

    var response = await request.send();
    if (response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);
      print("responseData : +++++++++++++++++++$responseData");
      // Extract IDs from response assuming response is a list of objects with 'id'
      return List<int>.from(jsonResponse.map((item) => item['id']));
    } else {
      throw Exception('Failed to upload images: ${response.statusCode}');
    }
  }

  // Update service provider with image IDs
  Future<bool> updateServiceProviderImages(
      String serviceProviderDocId, String token, List<int> imageIds) async {
    final i = Uri.parse('$url/service-providers/$serviceProviderDocId');
    final response = await http.put(
      i,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'data': {
          'image': imageIds.map((id) => {'id': id}).toList(),
        }
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(
          'Failed to update service provider: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  Future<bool> updateBusinessName(
      String serviceProviderDocId, String token, String name) async {
    final i = Uri.parse('$url/service-providers/$serviceProviderDocId');
    final response = await http.put(
      i,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'data': {
          'businessName': name,
        }
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(
          'Failed to update schedule: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  Future<bool> updateAddressAndLocation(String serviceProviderDocId,
      String token, String address, String location) async {
    final i = Uri.parse('$url/service-providers/$serviceProviderDocId');
    final response = await http.put(
      i,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'data': {
          'address': address,
          'location': location,
        }
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(
          'Failed to update schedule: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchServiceProviderDetails(
      String userId, String token) async {
    final String apiUrl = '$url/service-providers/$userId?populate=*';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }
}
