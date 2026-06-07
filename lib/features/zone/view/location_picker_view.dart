import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:proxlink/Utill/app_colors.dart';
import 'package:proxlink/Utill/AppConstants.dart';

class LocationPickerView extends StatefulWidget {
  final double initialLat;
  final double initialLng;

  const LocationPickerView({super.key, required this.initialLat, required this.initialLng});

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  late LatLng _selectedLocation;
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _predictions = [];
  bool _isLoading = false;
  Timer? _debounce;
  bool _isMovingCamera = false;

  // Use the API key from your AndroidManifest.xml
  final String _googleMapsApiKey = "AIzaSyCNgvQKquXLYt3Mpk5ZeQesyGLkSK-mtQI";

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(widget.initialLat, widget.initialLng);
    // Fetch initial address if we have coordinates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAddressFromLatLng(_selectedLocation);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchPlaces(query);
    });
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_googleMapsApiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          setState(() {
            _predictions = data['predictions'];
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching places: $e");
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() {
      _isLoading = true;
    });

    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$_googleMapsApiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final address = data['results'][0]['formatted_address'];
          setState(() {
            _searchController.text = address;
          });
        }
      }
    } catch (e) {
      debugPrint("Error reverse geocoding: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    // Hide keyboard and results
    FocusScope.of(context).unfocus();
    setState(() {
      _predictions = [];
      _isLoading = true;
    });

    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleMapsApiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final lat = data['result']['geometry']['location']['lat'];
          final lng = data['result']['geometry']['location']['lng'];
          final address = data['result']['formatted_address'];

          final newLocation = LatLng(lat, lng);
          _isMovingCamera = true; // Prevent reverse geocode during programmatic move
          await _mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
          
          setState(() {
            _selectedLocation = newLocation;
            _searchController.text = address;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching place details: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        _isMovingCamera = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Pick Location",
          style: TextStyle(fontFamily: AppConstants.fontFamily_Acre, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: {
                'lat': _selectedLocation.latitude,
                'lng': _selectedLocation.longitude,
                'address': _searchController.text.isNotEmpty ? _searchController.text : "Selected Location"
              });
            },
            child: const Text(
              "DONE",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: (position) {
              _selectedLocation = position.target;
              if (_predictions.isNotEmpty) {
                setState(() {
                  _predictions = [];
                });
              }
            },
            onCameraIdle: () {
              if (!_isMovingCamera) {
                _getAddressFromLatLng(_selectedLocation);
              }
            },
            onTap: (_) {
              FocusScope.of(context).unfocus();
              setState(() {
                _predictions = [];
              });
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            padding: const EdgeInsets.only(top: 100), // Move my location button down
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 35), // Offset for pin point
              child: Icon(
                Icons.location_on,
                color: AppColors.primaryColor,
                size: 45,
              ),
            ),
          ),
          // Search Bar
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 2))
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: "Search location...",
                      prefixIcon: _isLoading 
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2)),
                          )
                        : const Icon(Icons.search, color: AppColors.primaryColor),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _predictions = [];
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                if (_predictions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    constraints: BoxConstraints(maxHeight: Get.height * 0.4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 2))
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _predictions.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final prediction = _predictions[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
                          title: Text(prediction['description'], style: const TextStyle(fontSize: 14)),
                          onTap: () => _getPlaceDetails(prediction['place_id']),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
