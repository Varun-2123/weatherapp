import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['API_KEY'];

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _WeatherPageState();
  }
}

class _WeatherPageState extends State<WeatherPage> {
  final _WeatherServices = WeatherServices(apiKey: apiKey!);
  WeatherModel? _weather;

  _fetchWeather() async {
    String cityName = await _WeatherServices.getCurrentCity();
    try {
      final weather = await _WeatherServices.getWeather(cityName: cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  List<Color> getGradientColorsForTime() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      // Morning
      return [
        const Color.fromARGB(255, 249, 150, 1),
        const Color.fromARGB(255, 249, 150, 1),
        const Color.fromARGB(255, 255, 239, 91),
        Colors.cyan,
        Colors.lightBlueAccent,
        Colors.lightBlue,
        Colors.blueGrey,
      ];
    } else if (hour >= 12 && hour < 16) {
      // Afternoon
      return [
        Colors.orange,
        const Color.fromARGB(255, 255, 239, 91),
        Colors.lightBlue,
        Colors.blueAccent,
      ];
    } else if (hour >= 16 && hour < 19) {
      // Evening
      return [Colors.yellow, Colors.deepOrange, Colors.purple];
    } else {
      // Night
      return [
        const Color.fromARGB(255, 28, 40, 111),
        const Color.fromARGB(255, 4, 21, 74),
        const Color.fromARGB(255, 0, 0, 0),
      ];
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    var hour = DateTime.now().hour;
    if (mainCondition == null) {
      return "assets/weather_animation/sunny.json";
    }
    switch (mainCondition) {
      case "Clouds":
      case "Haze":
      case "Smoke":
      case "Mist":
      case "Dust":
      case "Fog":
        return "assets/weather_animation/cloudy.json";
      case "Rain":
      case "Drizzle":
      case "Shower rain":
        return "assets/weather_animation/raining.json";
      case "Thunderstorm":
        return "assets/weather_animation/thunderstorm.json";
      case "Clear":
        if (hour > 18 || hour < 6) {
          return "assets/weather_animation/clear_night.json";
        } else {
          return "assets/weather_animation/clear_day.json";
        }
      default:
        if (hour > 18 || hour < 6) {
          return "assets/weather_animation/clear_night.json";
        } else {
          return "assets/weather_animation/clear_day.json";
        }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: getGradientColorsForTime(),
          ),
        ),
        child: Center(
          child:
              _weather == null
                  ? Lottie.asset(
                    "assets/weather_animation/loading.json",
                    height: 260,
                    width: 260,
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, size: 40, color: Colors.white),
                      Text(
                        _weather?.cityName ?? "loading...",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontFamily: "SpecialGothic",
                        ),
                      ),
                      SizedBox(height: 120),
                      Lottie.asset(
                        getWeatherAnimation(_weather?.mainCondition),
                        height: 260,
                        width: 260,
                      ),
                      SizedBox(height: 65),
                      Text(
                        "${_weather?.temperature.round()}°C",
                        style: TextStyle(
                          fontSize: 68,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: "SpecialGothic",
                        ),
                      ),
                      Text(
                        _weather?.mainCondition ?? "loading...",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontFamily: "SpecialGothic",
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
