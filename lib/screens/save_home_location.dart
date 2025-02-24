import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation_app/screens/patient_screen.dart';

class RegisterPatient extends StatelessWidget {
  final String patientId; // Patient ID after registration

  const RegisterPatient({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register as Patient')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showSaveHomeLocationDialog(context, patientId);
          },
          child: const Text('Register and Save Home Location'),
        ),
      ),
    );
  }

  // Function to show dialog for saving home location
  void _showSaveHomeLocationDialog(BuildContext context, String patientId) {
    showDialog(
      context: context,
      barrierDismissible: false, // Force user to save location
      builder: (context) => Dialog(
        child: SizedBox(
          height: 500,
          child: SaveHomeLocationDialogContent(patientId: patientId),
        ),
      ),
    );
  }
}

// Widget for the home location map and save logic
class SaveHomeLocationDialogContent extends StatefulWidget {
  final String patientId;

  const SaveHomeLocationDialogContent({super.key, required this.patientId});

  @override
  _SaveHomeLocationDialogContentState createState() =>
      _SaveHomeLocationDialogContentState();
}

class _SaveHomeLocationDialogContentState
    extends State<SaveHomeLocationDialogContent> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation; // Store selected home location

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showPermissionDeniedDialog();
    }
  }

  void _saveHomeLocationToFirestore() {
    if (_selectedLocation != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.patientId)
          .set({
            'home_location': {
              'latitude': _selectedLocation!.latitude,
              'longitude': _selectedLocation!.longitude,
            },
          }, SetOptions(merge: true))
          .then((_) {
            Navigator.pop(context); // Close dialog
            _navigateToPatientScreen();
          })
          .catchError((error) {
            print('Error saving location: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to save location!')),
            );
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map!')),
      );
    }
  }

  void _navigateToPatientScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PatientScreen()),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text(
            'Location permission is required to select your home location.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Select Your Home Location',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.033333, 31.233334), // Default to Cairo
              zoom: 12,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (LatLng position) {
              setState(() {
                _selectedLocation = position;
              });
            },
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId("home_location"),
                      position: _selectedLocation!,
                      infoWindow:
                          const InfoWindow(title: "Your Selected Home Location"),
                    ),
                  }
                : {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _saveHomeLocationToFirestore,
            child: const Text('Save Home Location'),
          ),
        ),
      ],
    );
  }
}


