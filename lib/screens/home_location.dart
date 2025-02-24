import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeLocationScreen extends StatefulWidget {
  static const String routeName = 'homeLocationScreen';
  final String patientId;

  const HomeLocationScreen({super.key, required this.patientId});

  @override
  _HomeLocationScreenState createState() => _HomeLocationScreenState();
}

class _HomeLocationScreenState extends State<HomeLocationScreen> {
  GoogleMapController? _mapController;
  double? latitude;
  double? longitude;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchHomeLocation();
  }

  Future<void> _fetchHomeLocation() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.patientId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null &&
            data.containsKey('home_location') &&
            data['home_location'] is Map<String, dynamic>) {
          final homeLocation = data['home_location'];
          setState(() {
            latitude = homeLocation['latitude'];
            longitude = homeLocation['longitude'];
          });
        } else {
          setState(() {
            errorMessage = 'Home location not set for this patient.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Patient data not found.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch home location: $e';
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (latitude != null && longitude != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latitude!, longitude!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Location',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: latitude != null && longitude != null
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude!, longitude!),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('homeLocation'),
                  position: LatLng(latitude!, longitude!),
                  infoWindow: const InfoWindow(
                    title: 'Home Location',
                  ),
                ),
              },
            )
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
    );
  }
}
