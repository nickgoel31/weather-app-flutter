import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/components/additional_info_item.dart';
import 'package:weather_app/components/info_card.dart';

import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          // GestureDetector(
          //   onTap: () {
          //     //  refresh the weather data
          //     print("Refresh Weather Data");
          //   },
          //   child: const Icon(Icons.refresh),
          // ),
          // InkWell(
          //   onTap: () {
          //     //  refresh the weather data
          //     print("Refresh Weather Data");
          //   },
          //   child: const Icon(Icons.refresh),
          // ),
          IconButton(
            onPressed: () {
              //  refresh the weather data
              print("Refresh Weather Data");
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: const WeatherScreenBody(),
    );
  }
}

class WeatherScreenBody extends StatefulWidget {
  const WeatherScreenBody({super.key});

  @override
  State<WeatherScreenBody> createState() => _WeatherScreenBodyState();
}

class _WeatherScreenBodyState extends State<WeatherScreenBody> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = "Mumbai";
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$OpenWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);
      if (data["cod"] != "200") {
        throw 'An unexpected error occured';
      }
      //data
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentWeather(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        final data = snapshot.data!;

        final currentWeatherData = data["list"][0];
        final currentTemp = currentWeatherData["main"]["temp"] - 273.15;
        final currentDesc = currentWeatherData["weather"][0]["main"];

        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  //NEW COMPONENT CLIPS THE CARD (OVERFLOW HIDDEN)
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    // BACKDROP FILTER FOR BLUR EFFECT
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                currentTemp.toStringAsFixed(0) + "°C",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Icon(
                                currentDesc == "Clouds"
                                    ? Icons.cloud
                                    : currentDesc == "Clear"
                                        ? Icons.sunny
                                        : currentDesc == "Rain"
                                            ? Icons.thunderstorm
                                            : Icons.sunny,
                                size: 60,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                currentDesc,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(198, 195, 195, 195),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Weather Forecast",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       for (int i = 0; i < 5; i++)
              //         CustomInfoCard(
              //           time:
              //               "${data["list"][i + 1]["dt_txt"].toString().split(" ")[1].split(":")[0]}:00",
              //           temperature:
              //               (data["list"][i + 1]["main"]["temp"] - 273.15)
              //                       .toStringAsFixed(0) +
              //                   "°C",
              //           icon: data["list"][i + 1]["weather"][0]["main"] ==
              //                   "Clouds"
              //               ? Icons.cloud
              //               : data["list"][i + 1]["weather"][0]["main"] ==
              //                       "Clear"
              //                   ? Icons.sunny
              //                   : data["list"][i + 1]["weather"][0]["main"] ==
              //                           "Rain"
              //                       ? Icons.thunderstorm
              //                       : Icons.sunny,
              //         ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 135,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CustomInfoCard(
                      time:
                          "${data["list"][index + 1]["dt_txt"].toString().split(" ")[1].split(":")[0]}:00",
                      temperature:
                          (data["list"][index + 1]["main"]["temp"] - 273.15)
                                  .toStringAsFixed(0) +
                              "°C",
                      icon: data["list"][index + 1]["weather"][0]["main"] ==
                              "Clouds"
                          ? Icons.cloud
                          : data["list"][index + 1]["weather"][0]["main"] ==
                                  "Clear"
                              ? Icons.sunny
                              : data["list"][index + 1]["weather"][0]["main"] ==
                                      "Rain"
                                  ? Icons.thunderstorm
                                  : Icons.sunny,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Additional Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomAddInfoCardColumn(
                    icon: Icons.water_drop,
                    title: "Humidity",
                    value: "${currentWeatherData["main"]["humidity"]}%",
                  ),
                  CustomAddInfoCardColumn(
                    icon: Icons.air,
                    title: "Wind Speed",
                    value: "${currentWeatherData["wind"]["speed"]} m/s",
                  ),
                  CustomAddInfoCardColumn(
                    icon: Icons.waves,
                    title: "Pressure",
                    value: "${currentWeatherData["main"]["pressure"]} hPa",
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
