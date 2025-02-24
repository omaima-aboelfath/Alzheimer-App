import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomableChartScreen extends StatelessWidget {
  final String chartUrl;

  ZoomableChartScreen({required this.chartUrl});

  void showFullScreenPhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Dismiss dialog on outside tap
          },
          child: Container(
            color: Colors.black, // Background color for fullscreen view
            child: PhotoView(
              imageProvider: NetworkImage('http://10.0.2.2:5000/$chartUrl'),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.5,
              backgroundDecoration: BoxDecoration(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showFullScreenPhoto(context),
      child: Image.network(
        'http://10.0.2.2:5000/$chartUrl',
        loadingBuilder: (context, child, progress) {
          return progress == null ? child : CircularProgressIndicator();
        },
      ),
    );
  }
}
