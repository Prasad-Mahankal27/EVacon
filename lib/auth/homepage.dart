import 'package:ev/auth/login.dart';
import 'package:ev/sidebar/display_vehicle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ev/dummy_files/qr.dart';
import 'package:ev/dummy_files/rating.dart';
import 'package:ev/stationpage/searchPage.dart';
import 'package:ev/dummy_files/settings.dart';
import 'package:ev/dummy_files/status.dart';
import 'package:ev/screens/main_screen_avatars.dart';
import 'package:ev/screens/main_screen_cards.dart';
import 'package:ev/screens/map_screen.dart';
import 'package:ev/sidebar/profile.dart';
import 'package:ev/sidebar/show_profile.dart';
import 'package:ev/sidebar/AddStationPage.dart';
import 'package:ev/sidebar/addVehicle.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define initial route
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeEv(),
        '/status': (context) => const StatusPage(),
        '/qr': (context) => const QR(),
        '/history': (context) => FeedbackPage(),
        '/settings': (context) => Settings(),
      },
    );
  }
}

class HomeEv extends StatefulWidget {
  const HomeEv({Key? key});

  @override
  _HomeEvState createState() => _HomeEvState();
}

class _HomeEvState extends State<HomeEv> {
  late User? user;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userEmail = user!.email!;
  }

  void handleLogoTap(String searchTerm) {
    // Handle the tap action here
    print('Logo tapped with search term: $searchTerm');
    // You can perform any action you want here, such as updating the UI or navigating to a new screen
  }

  Future<String?> getImageUrl(String userEmail) async {
    try {
      // Check if the image exists for the user in Firebase Storage
      String imageUrl =
          await FirebaseStorage.instance.ref(userEmail).getDownloadURL();
      return imageUrl;
    } catch (error) {
      // If the image doesn't exist or there's an error, return null
      print("Error getting image URL: $error");
      return null;
    }
  }

  Widget buildProfilePic(String userEmail) {
    return FutureBuilder<String?>(
      future: getImageUrl(userEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the future is still loading, return a loading indicator or placeholder
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error fetching the image URL, return the default icon
          return const Icon(Icons.person);
        } else if (snapshot.hasData && snapshot.data != null) {
          // If the image URL is available, return the image widget
          return CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(snapshot.data!),
          );
        } else {
          // If the image doesn't exist, return the default icon
          return const Icon(Icons.person);
        }
      },
    );
  }

  logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const LoginPage(); // Assuming LoginPage is your login screen
      }));
    } catch (e) {
      print("Error logging out: $e");
    }
  }

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
                setState(() {}); // Update drawer when opened
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
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return EVFeaturesPage();
                },
              ));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(
                "Your profile",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text(" "),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: buildProfilePic(userEmail),
                ),
              ),
              decoration: const BoxDecoration(
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
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return show_profile();
                  },
                ))
              }, // Add your onTap functionality here
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profile"),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileInputForm();
                  },
                ))
              }, // Add your onTap functionality here
            ),
            ListTile(
              leading: const Icon(Icons.ev_station),
              title: const Text("Add Station"),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AddStationPage();
                  },
                ))
              }, // Add your onTap functionality here
            ),
            ListTile(
              leading: const Icon(Icons.car_rental_outlined),
              title: const Text("Add/Update Vehicle"),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return VehicleForm();
                  },
                ))
              }, // Add your onTap functionality here
            ),
            ListTile(
              leading: const Icon(Icons.car_rental_outlined),
              title: const Text("My Vehicle"),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const displayVehicle();
                  },
                ))
              }, // Add your onTap functionality here
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ElevatedButton.icon(
                onPressed: () {
                  logout(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
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
                SizedBox(height: 5),
                // ignore: avoid_types_as_parameter_names
                MidScreenAvatar(),
                SizedBox(height: 5),
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

        onTap: (int index) =>
            _navigateToPage(context, index), // Use new navigation function
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
            icon: Icon(
              Icons.qr_code_2,
              size: 47,
              color: Colors.green,
            ),
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
