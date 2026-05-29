import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:proxlink/features/network/controller/NetworkController.dart';
import 'package:proxlink/Utill/app_storage.dart';

class LocationService {
  Position? _lastPosition;
  late final NetworkController _networkController;
  late final AppStorage _appStorage;

  LocationService() {
    _networkController = Get.find<NetworkController>();
    _appStorage = Get.find<AppStorage>();
  }

  Future<void> updateLocation(Position position) async {
    print('LocationService: Updating location... (${position.latitude}, ${position.longitude})');
    
    // Always store latest in AppStorage as requested
    try {
      await _appStorage.write('current_lat', position.latitude);
      await _appStorage.write('current_lng', position.longitude);
      _appStorage.current_lat.value = position.latitude;
      _appStorage.current_lng.value = position.longitude;
    } catch (e) {
      print('LocationService: Error writing to storage: $e');
    }

    if (_lastPosition == null) {
      print('LocationService: First position, sending...');
      _lastPosition = position;
      await _sendLocation(position);
      return;
    }

    final distance = Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    print('LocationService: Distance since last update: $distance meters');

    if (distance > 1) {
      print('LocationService: Distance > 5m, sending update...');
      _lastPosition = position;
      await _sendLocation(position);
    } else {
      print('LocationService: Stationary, skipping update.');
    }
  }

  Future<void> _sendLocation(Position position) async {
    try {
      print('LocationService: Sending location to server...');
      await _networkController.sendLocation(
        lat: position.latitude,
        lng: position.longitude,
        accuracy: position.accuracy,
        speed: position.speed,
        isMoving: position.speed > 0,
      );
      print('LocationService: Send location call completed.');
    } catch (e) {
      print('LocationService: Error in _sendLocation: $e');
    }
  }
}
