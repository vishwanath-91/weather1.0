import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weatherapp/weatherModelApi/weather_model_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController cityValue = TextEditingController();
  late String cityName;

  String currentDate = DateFormat("dd-MMMM-yyyy-EEEEE").format(DateTime.now());
  String currentTime = DateFormat("hh:mm:ss a").format(DateTime.now());

  Future<WeatherApiModel?> fetchData() async {
    var response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=c7c1ac35067c9968cc494baad5928de2'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      WeatherApiModel apiModel = WeatherApiModel.fromJson(data);
      return apiModel;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            //this container contain hole home screen.
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.blueAccent.shade700, const Color(0xff9c27b0)],
              stops: const [0, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: Column(
              //this container contain hole widgets.
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    //this row for search bar
                    children: [
                      Expanded(
                        child: TextField(
                          controller: cityValue,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (cityValue.text == "") {
                                  cityName = "buxar";
                                } else {
                                  cityName = cityValue.text
                                      .replaceAll(" ", "")
                                      .toLowerCase();
                                }
                                setState(() {
                                  fetchData();
                                });
                              },
                              child: const Icon(Icons.search_sharp),
                            ),
                            hintText: "Search By City",
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  //////////////////////////////////
                ),

                ///////////////////////////////////
                FutureBuilder<WeatherApiModel?>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      ); // Show loading indicator
                    } else if (snapshot.hasError) {
                      return const Text(
                          'Error fetching data'); // Show error message
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Text(
                          'No data available'); // Show no data message
                    } else {
                      WeatherApiModel data = snapshot.data!;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shadowColor: Colors.white,
                              elevation: 25,
                              color: Colors.blueAccent,
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        currentTime,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        currentDate,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${cityName.toUpperCase()} || ",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "${data.main!.temp!.truncate() - 273}°C",
                                            style: const TextStyle(
                                                fontSize: 60,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "${data.weather?.first.description}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 2),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.thunderstorm_outlined,
                                            color: Colors.white,
                                            size: 120,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                          ),
                          //////////////////
                          /////////////////////
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Card(
                                  shadowColor: Colors.white,
                                  elevation: 25,
                                  color: Colors.blueAccent,
                                  child: Row(children: [
                                    const Column(
                                      children: [
                                        Icon(
                                          Icons.thermostat_outlined,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Min Temp:- ${data.main!.tempMin!.truncate() - 273}°C",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Max Temp:- ${data.main!.tempMax!.truncate() - 273}°C",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                                Card(
                                  shadowColor: Colors.white,
                                  elevation: 25,
                                  color: Colors.blueAccent,
                                  child: Row(children: [
                                    const Column(
                                      children: [
                                        Icon(
                                          Icons.ac_unit_outlined,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Pressure:- ${data.main!.pressure!}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Humidity:- ${data.main!.humidity!}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          // Add similar widgets for other data you want to display
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                shadowColor: Colors.white,
                                elevation: 25,
                                color: Colors.blueAccent,
                                child: Row(children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.air_outlined,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "WindSpeed:- ${data.wind!.speed!}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "deg:- ${data.wind!.deg}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ],
                          )
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
