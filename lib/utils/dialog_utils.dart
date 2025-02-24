import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_app/model/user_data.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/screens/theming/app_colors.dart';
import 'package:google_maps_webservice/places.dart'; // Add this package for Google Places API
import 'package:geolocator/geolocator.dart'; // Add this package for accessing the user's location

// apiKey: AIzaSyDIn3mg9P7pHt9hJ5FDLc4A5PB75PBnsoo
class DialogUtils {
  static void showMessage({
    required BuildContext context,
    required String title,
    required String message,
    Color? titleColor,
    Color? messageColor,
    String closeButtonText = 'Ok',
    void Function()? onClose,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: titleColor ?? AppColors.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: messageColor ?? AppColors.darkBlue, // Default color
              ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed:
                onClose ?? () => Navigator.pop(context), // Default action
            child: Text(
              closeButtonText,
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  static void showLoading({
    required BuildContext context,
    required String loadingLabel,
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text(loadingLabel),
          ],
        ),
      ),
    );
  }

  static void showNoInternetDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please check your network and try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // static Future<void> showHomeLocationPopup(MyUser user,
  //     {required BuildContext context}) async {
  //   TextEditingController locationController = TextEditingController();
  //   await showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Save Home Location testtt"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // TextField(
  //             //   controller: locationController,
  //             //   decoration: InputDecoration(
  //             //     labelText: "Enter Home Location",
  //             //     hintText: "e.g., Street, City, Country",
  //             //   ),
  //             // ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               String homeLocation = locationController.text.trim();
  //               if (homeLocation.isNotEmpty) {
  //                 await FirebaseFirestore.instance
  //                     .collection('users')
  //                     .doc(user.id)
  //                     .update({'homeLocation': homeLocation});
  //                 Navigator.pop(context); // Close the popup
  //                 Navigator.pushReplacementNamed(
  //                     context, PatientScreen.routeName);
  //               } else {
  //                 DialogUtils.showMessage(
  //                   context: context,
  //                   title: "Error",
  //                   message: "Home location cannot be empty.",
  //                   titleColor: AppColors.redColor,
  //                 );
  //               }
  //             },
  //             child: Text("Save"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // last
  // static void showHomeLocationDialog({
  //   required BuildContext context,
  //   required String patientId,
  //   required VoidCallback onComplete,
  // }) {
  //   LatLng? selectedLocation;
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (ctx) {
  //       return AlertDialog(
  //         title: const Text(
  //           'Save Home Location',
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //         ),
  //         content: SizedBox(
  //           height: 300, // Set height for the map
  //           width: double.maxFinite,
  //           child: GoogleMap(
  //             initialCameraPosition: const CameraPosition(
  //               target: LatLng(30.033333, 31.233334), // Default center
  //               zoom: 12,
  //             ),
  //             onTap: (LatLng position) {
  //               selectedLocation = position; // Store selected location
  //             },
  //             markers: selectedLocation != null
  //                 ? {
  //                     Marker(
  //                       markerId: const MarkerId('home'),
  //                       position: selectedLocation!,
  //                     )
  //                   }
  //                 : {},
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(ctx).pop(),
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               if (selectedLocation != null) {
  //                 // Save to Firestore
  //                 await FirebaseFirestore.instance
  //                     .collection('users')
  //                     .doc(patientId)
  //                     .set({
  //                   'home_location': {
  //                     'latitude': selectedLocation!.latitude,
  //                     'longitude': selectedLocation!.longitude,
  //                   },
  //                 }, SetOptions(merge: true));
  //                 Navigator.of(ctx).pop(); // Close dialog
  //                 onComplete(); // Navigate to PatientScreen
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     content: Text('Please select a location on the map'),
  //                     backgroundColor: AppColors.redColor,
  //                   ),
  //                 );
  //               }
  //             },
  //             child: const Text('Save Location'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // static void showHomeLocationDialog({
  //   required BuildContext context,
  //   required String patientId,
  //   required VoidCallback onComplete,
  // }) {
  //   LatLng? selectedLocation;
  //   GoogleMapController? mapController;
  //   final TextEditingController searchController = TextEditingController();

  //   Future<void> moveToLocation(LatLng location) async {
  //     if (mapController != null) {
  //       mapController?.animateCamera(
  //         CameraUpdate.newLatLng(location),
  //       );
  //       selectedLocation = location;
  //     }
  //   }

  //   Future<void> fetchCurrentLocation() async {
  //     try {
  //       final position = await Geolocator.getCurrentPosition(
  //         locationSettings: LocationSettings(
  //           accuracy: LocationAccuracy.high,
  //         ),
  //       );
  //       selectedLocation = LatLng(position.latitude, position.longitude);
  //       print('Current location: $selectedLocation');
  //       moveToLocation(selectedLocation!);
  //     } catch (e) {
  //       // Handle the error (e.g., show a retry option)
  //       print('Location fetch failed: $e');
  //     }
  //   }

  //   Future<void> searchLocation(String query) async {
  //     final places =
  //         GoogleMapsPlaces(apiKey: 'AIzaSyDIn3mg9P7pHt9hJ5FDLc4A5PB75PBnsoo');
  //     final response = await places.searchByText(query);

  //     if (response.isOkay && response.results.isNotEmpty) {
  //       final result = response.results.first;
  //       final location = LatLng(
  //         result.geometry!.location.lat,
  //         result.geometry!.location.lng,
  //       );
  //       moveToLocation(location);
  //     }
  //   }

  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (ctx) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: const Text(
  //               'Save Home Location',
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //             ),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 TextField(
  //                   controller: searchController,
  //                   decoration: InputDecoration(
  //                     hintText: 'Search location',
  //                     suffixIcon: IconButton(
  //                       icon: const Icon(Icons.search),
  //                       onPressed: () {
  //                         if (searchController.text.isNotEmpty) {
  //                           searchLocation(searchController.text);
  //                         }
  //                       },
  //                     ),
  //                   ),
  //                   onChanged: (query) {
  //                     if (query.isNotEmpty) {
  //                       searchLocation(query);
  //                     }
  //                   },
  //                 ),
  //                 const SizedBox(height: 10),
  //                 SizedBox(
  //                   height: 300,
  //                   width: double.maxFinite,
  //                   child: GoogleMap(
  //                     onMapCreated: (controller) {
  //                       mapController = controller;
  //                       fetchCurrentLocation();
  //                     },
  //                     initialCameraPosition: const CameraPosition(
  //                       target: LatLng(30.033333, 31.233334),
  //                       zoom: 12,
  //                     ),
  //                     onTap: (LatLng position) {
  //                       setState(() {
  //                         selectedLocation = position;
  //                       });
  //                     },
  //                     markers: selectedLocation != null
  //                         ? {
  //                             Marker(
  //                               markerId: const MarkerId('home'),
  //                               position: selectedLocation!,
  //                             )
  //                           }
  //                         : {},
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.of(ctx).pop(),
  //                 child: const Text('Cancel'),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () async {
  //                   if (selectedLocation != null) {
  //                     await FirebaseFirestore.instance
  //                         .collection('users')
  //                         .doc(patientId)
  //                         .set({
  //                       'home_location': {
  //                         'latitude': selectedLocation!.latitude,
  //                         'longitude': selectedLocation!.longitude,
  //                       },
  //                     }, SetOptions(merge: true));

  //                     Navigator.of(ctx).pop();
  //                     onComplete();
  //                   } else {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         content: Text('Please select a location on the map'),
  //                         backgroundColor: Colors.red,
  //                       ),
  //                     );
  //                   }
  //                 },
  //                 child: const Text('Save Location'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  static void showHomeLocationDialog({
    required BuildContext context,
    required String patientId,
    required VoidCallback onComplete,
  }) {
    LatLng? selectedLocation; // To store the selected location
    GoogleMapController? mapController; // Controller for Google Maps
    final TextEditingController searchController = TextEditingController();
    List<String> searchResults = []; // To store search results

    final places = GoogleMapsPlaces(
        apiKey:
            'AIzaSyDIn3mg9P7pHt9hJ5FDLc4A5PB75PBnsoo'); // Define places API key

    // Method to move the map to the given location
    Future<void> moveToLocation(LatLng location) async {
      if (mapController != null) {
        mapController?.animateCamera(
          CameraUpdate.newLatLng(location),
        );
        selectedLocation = location;
      }
    }

    // Method to fetch and move to the current location
    Future<void> fetchCurrentLocation() async {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        selectedLocation = LatLng(position.latitude, position.longitude);
        print('Current location: $selectedLocation');
        moveToLocation(selectedLocation!); // Move to current location
      } catch (e) {
        print('Location fetch failed: $e');
      }
    }

    // Method to search and show locations based on query
    // Future<void> searchLocation(String query) async {
    //   final response = await places.searchByText(query);

    //   if (response.isOkay && response.results.isNotEmpty) {
    //     searchResults.clear();
    //     for (var result in response.results) {
    //       searchResults.add(result.formattedAddress ?? 'Unknown Location');
    //     }

    //     // Optionally move to the first result on the map
    //     final firstResult = response.results.first;
    //     final location = LatLng(
    //       firstResult.geometry!.location.lat,
    //       firstResult.geometry!.location.lng,
    //     );
    //     moveToLocation(location);
    //   }
    // }

    // Show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Save Home Location',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search text field
                  // TextField(
                  //   controller: searchController,
                  //   decoration: InputDecoration(
                  //     hintText: 'Search location',
                  //     suffixIcon: IconButton(
                  //       icon: const Icon(Icons.search),
                  //       onPressed: () {
                  //         if (searchController.text.isNotEmpty) {
                  //           searchLocation(searchController.text);
                  //         }
                  //       },
                  //     ),
                  //   ),
                  //   onChanged: (query) {
                  //     if (query.isNotEmpty) {
                  //       searchLocation(query);
                  //     }
                  //   },
                  // ),
                  // if (searchResults.isNotEmpty) ...[
                  //   // Display search results
                  //   ListView.builder(
                  //     shrinkWrap: true,
                  //     itemCount: searchResults.length,
                  //     itemBuilder: (context, index) {
                  //       return ListTile(
                  //         title: Text(searchResults[index]),
                  //         onTap: () async {
                  //           // Select location from search result
                  //           final selectedResult = searchResults[index];
                  //           final response =
                  //               await places.searchByText(selectedResult);
                  //           final location = LatLng(
                  //             response.results.first.geometry!.location.lat,
                  //             response.results.first.geometry!.location.lng,
                  //           );
                  //           moveToLocation(location);
                  //           searchController.text = selectedResult;
                  //           setState(() {}); // Redraw to close the dropdown
                  //         },
                  //       );
                  //     },
                  //   ),
                  // ],
                  const SizedBox(height: 10),
                  // Map to display and select the location
                  SizedBox(
                    height: 300,
                    width: double.maxFinite,
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        mapController = controller;
                        fetchCurrentLocation(); // Fetch current location when map is created
                      },
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(
                            31.221606, 29.947980), // Default initial location
                        zoom: 12,
                      ), //
                      /// 30.033333, 31.233334
                      onTap: (LatLng position) {
                        setState(() {
                          selectedLocation =
                              position; // Set location on map tap
                        });
                      },
                      markers: selectedLocation != null
                          ? {
                              Marker(
                                markerId: const MarkerId('home'),
                                position: selectedLocation!,
                              )
                            }
                          : {},
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedLocation != null) {
                      // Save the selected location in Firestore
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(patientId)
                          .set({
                        'home_location': {
                          'latitude': selectedLocation!.latitude,
                          'longitude': selectedLocation!.longitude,
                        },
                      }, SetOptions(merge: true));

                      Navigator.of(ctx).pop();
                      onComplete(); // Notify completion
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a location on the map'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Save Location',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
