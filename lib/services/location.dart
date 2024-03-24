import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude, longitude;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
        latitude = position.latitude;
    longitude = position.longitude;
  }
}
