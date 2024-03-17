  import 'package:ev/dummy_files/stationDetail.dart';
import 'package:flutter/material.dart';
  import 'dart:math';

  void main() {
    runApp(EVFeaturesPage());
  }

  class EVFeaturesPage extends StatefulWidget {
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
          filteredStationNames = evStationNames.where((stationName) => availabilityMap[stationName] == true).toList();
        } else if (filter == 'busy') {
          filteredStationNames = evStationNames.where((stationName) => availabilityMap[stationName] == false).toList();
        } else if (filter == 'reset') {
          filteredStationNames = evStationNames;
        }
      });
    }

    Widget _buildEVStationSuggestions(String query) {
      List<String> suggestions = evStationNames.where((stationName) => stationName.toLowerCase().startsWith(query.toLowerCase())).toList();

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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.black, Colors.greenAccent],
                ),
              ),
              child: Center(
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
            decoration: BoxDecoration(
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
                            decoration: InputDecoration(
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
                      SizedBox(width: 8.0),
                      _buildFilterButton(context),
                    ],
                  ),
                ),
                Expanded(
                  child: _searchQuery.isNotEmpty
                      ? _buildEVStationSuggestions(_searchQuery)
                      : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: filteredStationNames.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String stationName = filteredStationNames[index];
                            final bool isAvailable = availabilityMap[stationName] ?? false;
                            return _buildEVStationTile(context, stationName, isAvailable);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildEVStationTile(BuildContext context, String stationName, bool isAvailable) {
      int? estimatedTime = estimatedTimeMap[stationName];

      if (estimatedTime == null) {
        final random = Random();
        estimatedTime = random.nextInt(61) + 30;
      }

      final random = Random();
      final double rating = (random.nextDouble() * 5).clamp(0.0, 5.0);

      return Card(
        color: _searchQuery.isNotEmpty && stationName.toLowerCase().contains(_searchQuery.toLowerCase())
            ? Colors.blueGrey[900]
            : null,
        child: ListTile(
          title: Row(
            children: [
              isAvailable
                  ? CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Container(
                        child: Text("A"),
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Container(
                        child: Text("B"),
                      ),
                    ),
              SizedBox(width: 8.0),
              Expanded(child: Text('$stationName (${rating.toStringAsFixed(1)} stars)')),
            ],
          ),
          subtitle: isAvailable ? Text('Available') : Text('Busy'),
          onTap: () {
            if (isAvailable) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirm Booking"),
                    content: Text("Do you want to book $stationName?"),
                    actions: [
                      TextButton(
    onPressed: () {
      Navigator.of(context).pop();
      // Navigate to station detail page with station object
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return stationDetailPage();
      },));
    },
    child: Text("Explore"),
  ),

                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
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
                    title: Text("Station is Busy"),
                    content: Text("Do you want to wait for the estimated time or book in advance?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          print("Waiting for estimated time at $stationName...");
                          Navigator.of(context).pop();
                        },
                        child: Text("Wait"),
                      ),
                      TextButton(
                        onPressed: () {
      Navigator.of(context).pop();
      // Navigate to station detail page with station object
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => stationDetailPage(),
        ),
      );
    },
                        child: Text("Book in Advance"),
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
            title: Text("Advanced Booking"),
            content: Text("Booking in advance for $stationName..."),
            actions: [
              TextButton(
                onPressed: () {
                  print("Booking in advance for $stationName...");
                  Navigator.of(context).pop();
                },
                child: Text("Book"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
            ],
          );
        },
      );
    }

    Widget _buildFilterButton(BuildContext context) {
      return PopupMenuButton<String>(
        icon: Icon(
          Icons.filter_list,
          color: Colors.white,
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'availability',
            child: Text('Availability'),
          ),
          PopupMenuItem<String>(
            value: 'busy',
            child: Text('Busy'),
          ),
          PopupMenuItem<String>(
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
