import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';


class LocationTracker extends StatefulWidget {
  @override
  _LocationTrackerState createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  Position? _currentPosition; // To store the current location
  StreamSubscription<Position>? _positionStream; // Stream for continuous location updates
  GoogleMapController? _mapController; // Controller for Google Map

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  // Request location permission from user
  void _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      _startLocationUpdates();
    } else {
      print('Location permission denied');
    }
  }

  // Start listening to location updates and move the camera to the updated location
  void _startLocationUpdates() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
      // Move the camera to the current location if map controller is initialized
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      }
    });
  }

  // Callback when the map is created to assign the controller
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  void dispose() {
    _positionStream?.cancel(); // Cancel the location updates stream
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GPS Tracker')),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator()) // Show loading icon if location is not available
          : GoogleMap(
        onMapCreated: _onMapCreated, // Assign the map controller
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 15,
        ),
        myLocationEnabled: true, // Enable 'my location' button
        myLocationButtonEnabled: true,
      ),
    );
  }
}
