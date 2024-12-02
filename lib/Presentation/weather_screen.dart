import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../Constant/constant.dart';
import '../Controller/weather_controller.dart';
import '../Model/location_model.dart';

class WeatherScreen extends StatelessWidget {
  final WeatherController weatherController = Get.put(WeatherController());

  WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerWidgetAppBar(context, "Weather "),
          const SizedBox(height: 25),
          buildSearchField(),
          const SizedBox(height: 20),
          Obx(() {
            if (weatherController.isLoading.value) {
              return Padding(
                padding: EdgeInsets.only(top: height / 3),
                child: const Center(
                  child: SpinKitChasingDots(
                    color: Colors.blue,
                  ),
                ),
              );
            }
            if (weatherController.weatherData.value == null) {
              return const Expanded(
                child: Center(
                  child:
                      NotFoundCard(message: "Enter a city to get weather data"),
                ),
              );
            }
            return Center(
              child: WeatherCard(weatherController.weatherData.value!),
            );
          }),
        ],
      ),
    );
  }

  Widget buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: weatherController.cityController,
        decoration: InputDecoration(
          labelText: 'Enter City',
          hintText: 'Example: Cairo',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.blueAccent),
            onPressed: () {
              if (weatherController.cityController.text.isEmpty) {
                Get.snackbar(
                  'City Required',
                  'Please enter a city name to get weather data.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              } else {
                weatherController
                    .getWeather(weatherController.cityController.text)
                    .then((_) {})
                    .catchError((e) {
                  showErrorDialog(Get.context!, e.toString());
                });
              }
            },
          ),
        ),
      ),
    );
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text('Error', style: TextStyle(color: Colors.red)),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('OK', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }
}

class WeatherCard extends StatelessWidget {
  final LocationModel locationModel;

  const WeatherCard(this.locationModel, {super.key});

  @override
  Widget build(BuildContext context) {
    if (locationModel.location == null || locationModel.current == null) {
      return const NotFoundCard(
          message: "City not found or data is incomplete.");
    }

    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location: ${locationModel.location?.name ?? "Unknown"}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    fontSize: 24,
                  ),
            ),
            const SizedBox(height: 20),
            buildWeatherInfo(context),
          ],
        ),
      ),
    );
  }

  Widget buildWeatherInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildWeatherDetail(
          context,
          'Temperature: ${locationModel.current?.tempC}°C',
          Colors.orangeAccent,
        ),
        const SizedBox(height: 12),
        buildWeatherDetail(
          context,
          'Condition: ${locationModel.current!.condition?.text!}',
          Colors.greenAccent,
        ),
        const SizedBox(height: 12),
        buildWeatherDetail(
          context,
          'Humidity: ${locationModel.current!.humidity!}%',
          Colors.blueAccent,
        ),
        const SizedBox(height: 12),
        buildWeatherDetail(
          context,
          'Wind: ${locationModel.current!.windMph!} mph',
          Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget buildWeatherDetail(BuildContext context, String text, Color color) {
    return Row(
      children: [
        Icon(Icons.info_outline, color: color, size: 30),
        const SizedBox(width: 10),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class NotFoundCard extends StatelessWidget {
  final String message;

  const NotFoundCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      color: Colors.blue.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Icon(
              Icons.location_off,
              color: Colors.blueAccent,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
