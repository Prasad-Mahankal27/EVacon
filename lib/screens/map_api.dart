import 'dart:async';
import 'dart:convert';
import 'package:ev/auth/homepage.dart';
import 'package:ev/screens/ev_station_detail_page.dart';
import 'package:ev/screens/upi.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.nSearch,
  }) : super(key: key);

  final String nSearch;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _completer = Completer();
  final List<Marker> _markers = [];
  Marker? _currentLocationMarker;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError(
      (error, stackTrace) {
        print(error.toString());
      },
    );

    Position position = await Geolocator.getCurrentPosition();

    _currentLocationMarker = Marker(
      markerId: const MarkerId("current_location"),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: const InfoWindow(title: "My Current Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure,
      ),
    );

    _markers.clear();
    if (_currentLocationMarker != null) {
      _markers.add(_currentLocationMarker!);
    }
    _markers
        .addAll(await fetchEVStations(position.latitude, position.longitude));

    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14,
    );
    GoogleMapController controller = await _completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<Marker>> fetchEVStations(
      double latitude, double longitude) async {
    final apiKey = 'YOUR_API_KEY'; // Replace with your Google Maps API Key
    final radius = 5000;
    String searched = widget.nSearch;
    final searchTerm = '$searched near me';

    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&keyword=$searchTerm&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        return (data['results'] as List)
            .map((placeData) => Marker(
                  markerId: MarkerId(placeData['place_id']),
                  position: LatLng(placeData['geometry']['location']['lat'],
                      placeData['geometry']['location']['lng']),
                  infoWindow: InfoWindow(title: placeData['name']),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen,
                  ),
                  onTap: () => _getEVStationDetails(placeData['place_id']),
                ))
            .toList();
      } else {
        throw Exception('Places API: ${data['status']}');
      }
    } else {
      throw Exception('Failed to load EV stations');
    }
  }

  Future<void> _getEVStationDetails(String placeId) async {
    final apiKey = 'YOUR_API_KEY'; // Replace with your Google Maps API Key
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,rating,formatted_address,photo,review,geometry&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        EVStationDetails details = EVStationDetails.fromJson(data['result']);
        List<dynamic>? photosData = data['result']['photos'];
        String? photoReference = photosData != null && photosData.isNotEmpty
            ? photosData[0]['photo_reference']
            : null;

        String imageUrl = '';
        if (photoReference != null) {
          imageUrl =
              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
        }
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    details.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (imageUrl.isNotEmpty)
                    AspectRatio(
                      aspectRatio: 16 / 9, // Set the aspect ratio as needed
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(height: 8),
                  Text('Address: ${details.formattedAddress}'),
                  SizedBox(height: 8),
                  Text('Rating: ${details.rating}'),
                  // Add other information you want to display here
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () => {
                        // Add your booking functionality here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhonePePayment()),
                        ),
                      },
                      child: Text('Book'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        print('Places Details API error: ${data['status']}');
      }
    } else {
      print('Failed to get EV station details');
    }
  }

  void _refreshLocation() {
    _getUserLocation();
  }

  void _refreshMap() {
    _markers.clear();
    // Clear markers and fetch new ones
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          // Pune Location
          target: LatLng(18.5204, 73.8567),
          zoom: 12,
        ),
        onMapCreated: (controller) {
          _completer.complete(controller);
        },
        markers: Set<Marker>.of(_markers),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeEv(),
                  ),
                );
              },
              backgroundColor: Colors.white, // Set FAB color
              child: Icon(Icons.arrow_back),
            ),
          ),
          FloatingActionButton(
            onPressed: _refreshLocation,
            backgroundColor: Colors.white, // Set FAB color
            child: const Icon(Icons.location_searching_rounded),
          ),
        ],
      ),
    );
  }
}

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

  static List<dynamic>? _extractPhotos(List<dynamic>? photosData) {
    return photosData?.map((photo) => photo['photo_reference']).toList();
  }
}
