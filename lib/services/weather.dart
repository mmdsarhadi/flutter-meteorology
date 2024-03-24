 import 'package:meteorology/services/location.dart';
import 'package:meteorology/services/networking.dart';
import 'package:meteorology/utilities/constants.dart';

class Weather
 {
   Future<dynamic> getLocationWeather()async
   {
     Location location = Location();
     await location.getCurrentLocation();

     NetWorkhelper netWorkhelper = NetWorkhelper(
         "$openweathermapurl?units=metric&lat=${location.latitude}&lon=${location.longitude}&appid=$apikey");
     var weatherData = await netWorkhelper.getData();
     return weatherData;
   }

   Future<dynamic> getCityWeather(String CityName) async

   {
     NetWorkhelper netWorkhelper =  NetWorkhelper(
       '$openweathermapurl?q=$CityName&appid=$apikey&units=metric'

     );
     var weatherData  =  await netWorkhelper.getData();
     return weatherData;
   }

 }
