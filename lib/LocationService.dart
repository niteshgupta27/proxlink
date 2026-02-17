import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:proxlink/features/network/controller/NetworkController.dart';
import 'package:proxlink/Utill/app_storage.dart';

class LocationService {
  Position? _lastPosition;
  final _networkController = Get.put(NetworkController());
  final _appStorage = Get.find<AppStorage>();

  Future<void> updateLocation(Position position) async {
    // Always store latest in AppStorage as requested
    await _appStorage.write('current_lat', position.latitude);
    await _appStorage.write('current_lng', position.longitude);

    if (_lastPosition == null) {
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

    if (distance > 5) {
      _lastPosition = position;
      await _sendLocation(position);
    }
  }

  Future<void> _sendLocation(Position position) async {
    print('Sending location to server: ${position.latitude}, ${position.longitude}');
    _appStorage.current_lat.value=position.latitude;
    _appStorage.current_lng.value=position.longitude;
    await _networkController.sendLocation(
      lat: position.latitude,
      lng: position.longitude,
      accuracy: position.accuracy,
      speed: position.speed,
      isMoving: position.speed > 0,
    );
  }
}
