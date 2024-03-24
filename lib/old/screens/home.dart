import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meteorology/components/deteails_widget.dart';
import 'package:meteorology/components/loading.dart';
import 'package:meteorology/models/weather_model.dart';
import 'package:meteorology/services/location.dart';
import 'package:meteorology/services/networking.dart';
import 'package:meteorology/utilities/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDataLoad = true;
  double? latitude, longitude;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;
  WeatherModel? weatherModel;

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  void getPermission() async {
    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      print("defend");
      permission = await geolocatorPlatform.requestPermission();
      if (permission != LocationPermission.denied) {
        if (permission == LocationPermission.deniedForever) {
          // print(
          //     "به صورت کامل رد شده است و  کاربر  می تواند در  تنطیمات ان را اضافه کند");
        }
        else {
          print("denied the request");
          getloction();
        }
      }
    } else {
      getloction();
    }
  }

  void getloction() async {
    Location location = Location();
    location.getCurrentLocation();
    latitude = location.latitude;
    longitude = location.longitude;
    NetWorkhelper network = NetWorkhelper(
        "https://api.openweathermap.org/data/2.5/weather?units=metric&lat=$latitude&lon=$longitude&appid=$apikey");
    var weatherData = await network.getData();
    weatherModel = WeatherModel(
      location: weatherData['name'] + ', ' + weatherData['sys']['country'],
      description: weatherData['weather'][0]['description'],
      temperature: weatherData['main']['temp'],
      feelsLike: weatherData['main']['feels_like'],
      humiduty: weatherData['main']['humiduty'],
      wind: weatherData['wind']['speed'],
      icon: weatherData['weather'][0]['icon'],
    );

    setState(() {
      isDataLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoad) {
      return LoadingWidget();
    } else
      return Scaffold(
        backgroundColor: KOverLayColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        decoration: KTextFieldDecoration,
                        onSubmitted: (String TypedName) {
                          print(TypedName);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white10,
                            // elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () {},
                        child: Container(
                          height: 60,
                          child: Row(
                            children: const [
                              Text(
                                'My Location',
                                style: KtextFieldTextStyle,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.gps_fixed,
                                color: Colors.white60,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_city,
                          color: KMIdLightColor,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          weatherModel!.location!,
                          style: KLocationTExtStyle,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Icon(
                      Icons.wb_sunny_outlined,
                      size: 280,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "${weatherModel!.temperature!}°",
                      style: KTempTextStyle,
                    ),
                    Text(
                      "${weatherModel!.description!.toUpperCase()}",
                      style: KLocationTExtStyle,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: KOverLayColor,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Details_wedget(
                          title: 'FEELS LIKE',
                          value: '${weatherModel!.feelsLike!.round()}°',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        Details_wedget(
                          title: 'HUMIDITY',
                          value: '${weatherModel!.humiduty!}',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        Details_wedget(
                          title: 'WIND',
                          value: '${weatherModel!.wind!.round()}',
                        ),
                      ],
                    ),
                    height: 90,
                  ),
                ),
              )
            ],
          ),
        ),
      );
  }
}
