import 'package:flutter/material.dart';
import 'package:weather_app/api.dart';
import 'package:weather_app/weathermodel.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  ApiResponse? response;
  bool inProgress = false;
  String message = "Search for the location to get weather data";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchWidget(),
              SizedBox(height: 20),
              if (inProgress)
                CircularProgressIndicator()
              else
                Expanded(
                  child: SingleChildScrollView(child: _buildWeatherWidget()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Search Any Location',
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        onFieldSubmitted: (value) {
          _getWeatherData(value);
        },
      ),
    );
  }

  Widget _buildWeatherWidget() {
    if (response == null) {
      return Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 50,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    response?.location?.name ?? "",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    response?.location?.country ?? "",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                '${response?.current?.tempC?.toString() ?? ""}°c',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              Text(
                response?.current?.condition?.text.toString() ?? "",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Image.network(
            "https:${response?.current?.condition?.icon}"
                .replaceAll("64x64", "128x128"),
            height: 200,
            scale: 0.7,
          ),
          SizedBox(height: 20),
          Card(
            color: Colors.white,
            elevation: 4,
            child: Column(
              children: [
                _dateAndTitleWidget(
                  "Humidity",
                  response?.current?.humidity?.toString() ?? "",
                ),
                _dateAndTitleWidget(
                  "Wind Speed",
                  "${response?.current?.windKph?.toString() ?? ""} km/h",
                ),
                _dateAndTitleWidget(
                  "UV",
                  response?.current?.uv?.toString() ?? "",
                ),
                _dateAndTitleWidget(
                  "Percipitation",
                  "${response?.current?.precipMm.toString() ?? ""} mm",
                ),
                _dateAndTitleWidget(
                  "Local Time",
                  response?.location?.localtime?.split(" ")?.last ?? "",
                ),
                _dateAndTitleWidget(
                  "Local Date",
                  response?.location?.localtime?.split(" ")?.first ?? "",
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _dateAndTitleWidget(String title, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  _getWeatherData(String location) async {
    setState(() {
      inProgress = true;
    });

    try {
      response = await WeatherApi().getCurrentWeather(location);
    } catch (e) {
      setState(() {
        message = "Failed to Get Weather";
        response = null;
      });
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
