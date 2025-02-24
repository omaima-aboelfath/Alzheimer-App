import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore

class CaregiverLocationTracker extends StatefulWidget {
  final String patientId; // Add patientId as a parameter

  const CaregiverLocationTracker({super.key, required this.patientId});

  @override
  _CaregiverLocationTrackerState createState() =>
      _CaregiverLocationTrackerState();
}

class _CaregiverLocationTrackerState extends State<CaregiverLocationTracker> {
  GoogleMapController? _mapController; // Controller for Google Map
  LatLng? _patientLocation; // To store the patient's location
  bool _isLoading = true; // To track loading state
  StreamSubscription<DocumentSnapshot>?
      _locationStream; // Stream for real-time location updates

  @override
  void initState() {
    super.initState();
    _startPatientLocationStream(); // Start listening to the patient's location updates
  }

  // Start listening to the patient's location updates in real-time
  void _startPatientLocationStream() {
    final firestore = FirebaseFirestore.instance;
    _locationStream = firestore
        .collection('users')
        .doc(widget.patientId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        final latitude = data?['latitude'] as double?;
        final longitude = data?['longitude'] as double?;

        if (latitude != null && longitude != null) {
          setState(() {
            _patientLocation = LatLng(latitude, longitude);
            _isLoading = false;
          });

          // Move the camera to the patient's location
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(_patientLocation!),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          Center(child: Text('No location data found for the patient.'));
          // _showError('No location data found for the patient.');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        Center(child: Text('Patient not found.'));
        // _showError('Patient not found.');
      }
    });
  }

  // // Show an error message
  // void _showError(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  // Callback when the map is created to assign the controller
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Move the camera to the patient's location once the map is ready
    if (_patientLocation != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_patientLocation!),
      );
    }
  }

  @override
  void dispose() {
    _locationStream?.cancel(); // Cancel the patient's location stream
    _mapController?.dispose(); // Dispose of the map controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Location',
            style: Theme.of(context).textTheme.displayMedium),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading icon
          : _patientLocation == null
              ? const Center(child: Text('No location data available.'))
              : GoogleMap(
                  onMapCreated: _onMapCreated, // Assign the map controller
                  initialCameraPosition: CameraPosition(
                    target: _patientLocation!,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('patientLocation'),
                      position: _patientLocation!,
                      infoWindow: const InfoWindow(title: 'Patient Location'),
                    ),
                  },
                  myLocationEnabled: false, // Disable 'my location' button
                  myLocationButtonEnabled: false,
                ),
    );
  }
}
