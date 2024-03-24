import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meteorology/components/error_message.dart';
import 'package:meteorology/old/components/deteails_widget.dart';
import 'package:meteorology/old/components/loading.dart';
import 'package:meteorology/old/models/weather_model.dart';
import 'package:meteorology/services/location.dart';
import 'package:meteorology/services/networking.dart';
import 'package:meteorology/services/weather.dart';
import 'package:meteorology/utilities/constants.dart';
import 'package:meteorology/utilities/weather_icon.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDataLoaded = false;
  bool isError= false;
  double? latitude, longitude;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;
  WeatherModel? weatherModel;
  String? title , message;

  int code = 0;
Weather weather  = Weather();
var weatherData;

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
          print(
              "به صورت کامل رد شده است و  کاربر  می تواند در  تنطیمات ان را اضافه کند");
          setState(() {
            isDataLoaded =  true;
            isError = true;
            title= 'Permisson Permanantly denied';
            message= 'pleas provider permisson the app from  divace settings';
          });
        } else {
          print("permisson granted");
          updateUI();
        }
      } else {
        print("user denid tge request");
        updateUI();

      }
    } else {
      updateUI();
    }
  }

  void updateUI({String ? cityname}) async {
    weatherData = null;
    if(cityname==null || cityname =='')
      {

        if( !await geolocatorPlatform.isLocationServiceEnabled())
        {
          setState(() {
            isError   = true;
            isDataLoaded = true;
            title ="location is truned off";
            message= 'pleas enable the  loction';
            return;

          });
        }
        weatherData = await weather.getLocationWeather();
      }
    else
      {
        weatherData =  await weather.getCityWeather(cityname);
      }

  if(weatherData == null)
    {
      setState(() {
        title= "city not found ";;
        message = 'pleas make sure you have entered the right city name';
        isDataLoaded = true;
        isError  =  true;
        return;
      });
    }

    code = weatherData['weather'][0]['id'];
    weatherModel = WeatherModel(
      location: weatherData['name'] + ', ' + weatherData['sys']['country'],
      description: weatherData['weather'][0]['description'],
      temperature: weatherData['main']['temp'],
      feelsLike: weatherData['main']['feels_like'],
      humiduty: weatherData['main']['humiduty'],
      wind: weatherData['wind']['speed'],

      icon:
          'images/weather-icons/${getIconPrefix(code)}${kweatherIcons[code.toString()]!['icon']}.svg',
    );

    setState(() {
      isDataLoaded = true;
      isError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return LoadingWidget();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false  ,
        backgroundColor: KOverLayColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                          decoration: KTextFieldDecoration,
                          onSubmitted: (String typedName) {
                            setState(() {
                              isDataLoaded = false;
                              updateUI(cityname:typedName );
                            });
                          }),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white12,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Container(
                            height: 65,
                            child: Row(
                              children: [
                                Text(
                                  "My Location",
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
                          onPressed: () {
                            setState(() {
                              isDataLoaded =  false;
                              getPermission();
                            });

                          },
                        ),
                      )),
                ],
              ),
              isError? ErrorMessage(
                title:title!, message: message!,
              ):
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
                    SvgPicture.asset(
                      weatherModel!.icon!,
                      height: 280,
                      color: KMIdLightColor,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "${weatherModel!.temperature!.round()}°",
                      style: KTempTextStyle,
                    ),
                    Text(
                      "${weatherModel!.description!.toUpperCase()}",
                      style: KLocationTExtStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: KOverLayColor,
                  child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Details_wedget(
                            title: "FEELS LIKE",
                            value: "${weatherModel!=null?   weatherModel!.feelsLike!.round(): 0}°",
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: VerticalDivider(
                              thickness: 1,
                            ),
                          ),
                          Details_wedget(
                            title: "HUMIDUTY",
                            value: "${weatherModel!=null?  weatherModel!.humiduty:0}%",
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: VerticalDivider(
                              thickness: 1,
                            ),
                          ),
                          Details_wedget(
                            title: "WIND",
                            value: "${weatherModel!=null?  weatherModel!.wind!:0}",
                          ),
                        ]),
                    height: 90,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    ;
  }
}
