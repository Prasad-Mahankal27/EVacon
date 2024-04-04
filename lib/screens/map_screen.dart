import 'package:ev/screens/map_api.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _mapLoaded = false;

  @override
  void initState() {
    super.initState();
    // Initialize map after the widget builds for the first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _mapLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 11, left: 11),
      child: Card(
        elevation: 10,
        color: Colors.white,
        shadowColor: Colors.black,
        child: Column(
          children: [
            if (_mapLoaded)
              Container(
                height: 200,
                width: 330,
                child: HomePage(
                  nSearch: 'ev station',
                ), // Embed your HomePage here
              )
            else // Show a loader while map initializes
              Container(
                height: 200,
                width: 330,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
