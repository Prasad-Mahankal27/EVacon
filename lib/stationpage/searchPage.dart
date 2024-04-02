import 'package:flutter/material.dart';
import 'dart:math';
import 'stationDetail.dart'; // Import the stationDetail.dart file

void main() {
  runApp(const EVFeaturesPage());
}

class EVFeaturesPage extends StatefulWidget {
  const EVFeaturesPage({super.key});

  @override
  _EVFeaturesPageState createState() => _EVFeaturesPageState();
}

class _EVFeaturesPageState extends State<EVFeaturesPage> {
  List<String> evStationNames = [
    'ChargePoint',
    'Tesla Supercharger Network',
    'EVgo',
    'Electrify America',
    'Blink Charging',
    'Greenlots',
    'SemaConnect',
    'Volta Charging',
    'Shell Recharge',
    'Petro-Canada EV Charging'
  ];

  Map<String, bool> availabilityMap = {
    'ChargePoint': true,
    'Tesla Supercharger Network': true,
    'EVgo': false,
    'Electrify America': true,
    'Blink Charging': false,
    'Greenlots': true,
    'SemaConnect': false,
    'Volta Charging': true,
    'Shell Recharge': false,
    'Petro-Canada EV Charging': true,
  };

  Map<String, int?> estimatedTimeMap = {
    'ChargePoint': 30,
    'Tesla Supercharger Network': 45,
  };

  List<String> filteredStationNames = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredStationNames = evStationNames;
  }

  void _filterStations(String filter) {
    setState(() {
      if (filter == 'availability') {
        filteredStationNames = evStationNames
            .where((stationName) => availabilityMap[stationName] == true)
            .toList();
      } else if (filter == 'busy') {
        filteredStationNames = evStationNames
            .where((stationName) => availabilityMap[stationName] == false)
            .toList();
      } else if (filter == 'reset') {
        filteredStationNames = evStationNames;
      }
    });
  }

  Widget _buildEVStationSuggestions(String query) {
    List<String> suggestions = evStationNames
        .where((stationName) =>
            stationName.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        final String suggestion = suggestions[index];
        final bool isAvailable = availabilityMap[suggestion] ?? false;
        return _buildEVStationTile(context, suggestion, isAvailable);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black, Colors.greenAccent],
              ),
            ),
            child: const Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    'EVSathi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Colors.greenAccent],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search EV stations...',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    _buildFilterButton(context),
                  ],
                ),
              ),
              Expanded(
                child: _searchQuery.isNotEmpty
                    ? _buildEVStationSuggestions(_searchQuery)
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: filteredStationNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String stationName =
                              filteredStationNames[index];
                          final bool isAvailable =
                              availabilityMap[stationName] ?? false;
                          return _buildEVStationTile(
                              context, stationName, isAvailable);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEVStationTile(
      BuildContext context, String stationName, bool isAvailable) {
    int? estimatedTime = estimatedTimeMap[stationName];

    if (estimatedTime == null) {
      final random = Random();
      estimatedTime = random.nextInt(61) + 30;
    }

    final random = Random();
    final double rating = (random.nextDouble() * 5).clamp(0.0, 5.0);

    return Card(
      color: _searchQuery.isNotEmpty &&
              stationName.toLowerCase().contains(_searchQuery.toLowerCase())
          ? Colors.blueGrey[900]
          : null,
      child: ListTile(
        title: Row(
          children: [
            isAvailable
                ? CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Container(
                      child: const Text("A"),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Container(
                      child: const Text("B"),
                    ),
                  ),
            const SizedBox(width: 8.0),
            Expanded(
                child:
                    Text('$stationName (${rating.toStringAsFixed(1)} stars)')),
          ],
        ),
        subtitle: isAvailable ? const Text('Available') : const Text('Busy'),
        onTap: () {
          if (isAvailable) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm Booking"),
                  content: Text("Do you want to book $stationName?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Navigate to station detail page with station object
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            if (stationName == 'Tesla Supercharger Network') {
                              return const stationDetailPage(type: "ts");
                            } else if (stationName == 'Greenlots') {
                              return const stationDetailPage(type: "gl"); }
                            return const stationDetailPage(type: "cp");
                      }));
                      },
                      child: const Text("Explore"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Station is Busy"),
                  content: const Text(
                      "Do you want to wait for the estimated time or book in advance?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Wait"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showAdvancedBookingDialog(context, stationName);
                      },
                      child: const Text("Book in Advance"),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showAdvancedBookingDialog(BuildContext context, String stationName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Advanced Booking"),
          content: Text("Booking in advance for $stationName..."),
          actions: [
            TextButton(
              onPressed: () {
                print("Booking in advance for $stationName...");
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                   return const stationDetailPage(type: "ts");               
                },));
              },
              child: const Text("Book"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.filter_list,
        color: Colors.white,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'availability',
          child: Text('Availability'),
        ),
        const PopupMenuItem<String>(
          value: 'busy',
          child: Text('Busy'),
        ),
        const PopupMenuItem<String>(
          value: 'reset',
          child: Text('Reset'),
        ),
      ],
      onSelected: (String value) {
        _filterStations(value);
      },
    );
  }
}
