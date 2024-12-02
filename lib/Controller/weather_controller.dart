import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Model/location_model.dart';

class WeatherController extends GetxController {
  final cityController = TextEditingController();

  Rxn<LocationModel> weatherData = Rxn<LocationModel>();
  RxBool isLoading = false.obs;

  Future<void> getWeather(String cityName) async {
    try {
      isLoading.value = true;

      final response = await http.get(Uri.parse(
          'https://api.weatherapi.com/v1/current.json?key=10c97e4427ec4bbe87b135334240212&q=$cityName'));

      if (response.statusCode == 404) {
        throw "City not found or network issue";
      } else {
        if (kDebugMode) {
          print(response.body);
        }
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        weatherData.value = LocationModel.fromJson(jsonMap);
      }
    } catch (e) {
      throw "Failed to fetch weather data: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
