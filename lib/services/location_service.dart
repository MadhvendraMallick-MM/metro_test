import 'package:geolocator/geolocator.dart';
import '../data/metro_data.dart';
import 'dart:math';

class LocationService {
  // Check if location services are enabled
  static Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permissions
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permissions
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Get current position
  static Future<Position?> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check permissions
      LocationPermission permission = await checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Find nearest metro station based on current location
  static Future<String?> findNearestStation() async {
    try {
      Position? position = await getCurrentPosition();
      if (position == null) return null;

      // Get all stations with coordinates
      final stationsWithCoords = MetroData.allStationsWithCoordinates;

      if (stationsWithCoords.isEmpty) return null;

      // Find nearest station
      String? nearestStation;
      double minDistance = double.infinity;

      for (var station in stationsWithCoords) {
        double distance = _calculateDistance(
          position.latitude,
          position.longitude,
          station['latitude'] as double,
          station['longitude'] as double,
        );

        if (distance < minDistance) {
          minDistance = distance;
          nearestStation = station['name'] as String;
        }
      }

      return nearestStation;
    } catch (e) {
      print('Error finding nearest station: $e');
      return null;
    }
  }

  // Calculate distance between two points (in kilometers)
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // km

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  // Get location permission status as string
  static Future<String> getPermissionStatus() async {
    LocationPermission permission = await checkPermission();
    switch (permission) {
      case LocationPermission.denied:
        return 'denied';
      case LocationPermission.deniedForever:
        return 'deniedForever';
      case LocationPermission.whileInUse:
        return 'whileInUse';
      case LocationPermission.always:
        return 'always';
      default:
        return 'unknown';
    }
  }
}
