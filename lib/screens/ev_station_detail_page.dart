import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class EVStationDetails {
  final String name;
  final double? rating;
  final String formattedAddress;
  final List<dynamic>? photos; // Reference photos (fetch later)
  final List<dynamic>? reviews; // Will contain maps
  final LatLng location;

  EVStationDetails.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        rating = json['rating']?.toDouble() ?? 0.0,
        formattedAddress = json['formatted_address'],
        photos = _extractPhotos(json['photos']),
        reviews = json['reviews'],
        location = LatLng(
          json['geometry']['location']['lat'],
          json['geometry']['location']['lng'],
        );

  // Helper to extract photo references
  static List<dynamic>? _extractPhotos(List<dynamic>? photosData) {
    return photosData?.map((photo) => photo['photo_reference']).toList();
  }
}

class EVStationDetailPage extends StatelessWidget {
  final EVStationDetails stationDetails;

  const EVStationDetailPage({super.key, required this.stationDetails});

  Future<void> _launchDirections(LatLng destination) async {
    final url = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': '${destination.latitude},${destination.longitude}'
    }).toString();

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch directions';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(stationDetails.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stationDetails.rating != null
                ? 'Rating: ${stationDetails.rating}'
                : 'Rating unavailable'),
            if (stationDetails.photos != null)
              SizedBox(
                height: 250,
                child: FutureBuilder(
                    future: _fetchPhoto(stationDetails.photos![0]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.memory(snapshot.data!);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stationDetails.formattedAddress),
                  const SizedBox(height: 5),
                  Text('Rating: ${stationDetails.rating}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _launchDirections(stationDetails.location),
                    child: const Text('Get Directions'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Function to fetch a single photo
  Future<Uint8List> _fetchPhoto(String photoReference) async {
    final apiKey = 'AIzaSyBaULQ2frkIPpr9Uw62dqBTreT3tT9GHJc';
    final url =
        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to fetch photo');
    }
  }
}
