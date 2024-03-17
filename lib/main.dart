// import 'package:evacon/history.dart';
import 'package:ev/dummy_files/qr.dart';
import 'package:ev/dummy_files/rating.dart';
import 'package:ev/dummy_files/searchPage.dart';
import 'package:ev/dummy_files/settings.dart';
import 'package:ev/dummy_files/status.dart';
import 'package:ev/dummy_files/history.dart';
import 'package:ev/screens/main_screen_avatars.dart';
import 'package:ev/screens/main_screen_cards.dart';
import 'package:ev/screens/map_screen.dart';
import 'package:ev/stationpage/AddStationPage.dart';
import 'package:ev/stationpage/addVehicle.dart';
//import 'package:ev/screens/search.dart';
import 'package:flutter/material.dart';
// Import for route management
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Define initial route
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeEv(),
        '/status': (context) => const statusPage(),
        '/qr': (context) => const QR(),
        '/history': (context) => FeedbackPage(),
        '/settings': (context) => Settings(),
      },
    );
  }
}

class HomeEv extends StatelessWidget {
  const HomeEv({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.person_2_outlined),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(
          "EVacon",
          style: TextStyle(
            color: Colors.green[400],
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // showModalBottomSheet(context: context, builder: (context) {
              //   return SearchStation();
              // },);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EVFeaturesPage();
              },));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text(
                "Your profile",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(" "),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Icon(Icons.person_2_outlined),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff9600FF),
                    Color(0xffAEBAF8),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book_outlined),
              title: const Text("Your Profile"),
              onTap: () => {

              }, // Add your onTap functionality here
            ),
            ListTile(
              leading: const Icon(Icons.ev_station),
              title: const Text("Add Station"),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddStationPage();
                },))
              }, // Add your onTap functionality here
            ),
            ListTile(
              leading: const Icon(Icons.car_rental_outlined),
              title: const Text("My Vehicle"),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return VehicleForm();
                },))
              }, // Add your onTap functionality here
            ),
          ],
        ),
        // Add your drawer content here
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                MidScreen(),
                const SizedBox(height: 5),
                MidScreenAvatar(),
                const SizedBox(height: 5),
                MapScreen(),
              ],
            ),
          ),
        ),
      ), // Replace with your actual Home Page content
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.blue,
        iconSize: 24,

        onTap: (int index) => _navigateToPage(context, index), // Use new navigation function
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_2, size: 47, color: Colors.green,),
            label: 'QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Function to navigate to different pages based on index
void _navigateToPage(BuildContext context, int index) {
  final String routeName;
  switch (index) {
    case 0:
      routeName = '/';
      break;
    case 1:
      routeName = '/status';
      break;
    case 2:
      routeName = '/qr';
      break;
    case 3:
      routeName = '/history';
      break;
    case 4:
      routeName = '/settings';
      break;
    default:
      routeName = '/';
  }
  Navigator.pushNamed(context, routeName);
}