import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weatherapp/consts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory w1 = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;
  String _cityName = '';

  @override
  void initState() {
    super.initState();
    _getWeatherData("Mumbai");
  }

  void _getWeatherData(String cityName) {
    w1.currentWeatherByCityName(cityName).then((w) {
      setState(() {
        _weather = w;
        print("API Response: $_weather?");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 119, 103, 164),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildSearchField(),
          SizedBox(height: 20),
          if (_weather == null)
            CircularProgressIndicator()
          else
            _buildWeatherInfo(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(
                      255, 50, 38, 83), //et the color of the border
                  width: 2.0,
                  // Set the width of the border
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter city name',
                      ),
                      onChanged: (value) {
                        _cityName = value;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _getWeatherData(_cityName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent, // Set button color transparent
                      elevation: 0, // Remove button shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Set button border radius
                      ),
                    ),
                    child: const Icon(
                      Icons.search, // Change this to any icon from the Icons class
                      size: 30, // Adjust the size of the icon as needed
                      color: Colors.white, // Adjust the color of the icon as needed
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        _locationHeader(),
        SizedBox(height: 20),
        _dateTimeInfo(),
        SizedBox(height: 20),
        _weatherIc(),
        SizedBox(height: 20),
        _currentTemp(),
        SizedBox(height: 20),
        _extraInfo(),
      ],
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: TextStyle(fontSize: 35),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              "  ${DateFormat("d.M.y").format(now)}",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        )
      ],
    );
  }

  Widget _weatherIc() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
              ),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  Widget _currentTemp() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
          style: TextStyle(
            color: Colors.black,
            fontSize: 90,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  Widget _extraInfo() {
    return Container(
      height: 150,
      width: 300,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 50, 38, 83),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Max:  ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Min:  ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Wind:  ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Humidity:  ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
