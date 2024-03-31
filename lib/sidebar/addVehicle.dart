import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev/auth/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VehicleForm extends StatefulWidget {
  @override
  _VehicleFormState createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _make = TextEditingController();
  TextEditingController _model = TextEditingController();
  TextEditingController _vehicleRegistrationNumber = TextEditingController();
  TextEditingController _vin = TextEditingController();

  void deleteCollection() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userEmail = user!.email!;
      // Reference to the 'vehicle' document inside the userEmail collection
      DocumentSnapshot vehicleDocSnapshot =
          await FirebaseFirestore.instance.collection(userEmail).doc('vehicle').get();
      if (vehicleDocSnapshot.exists) {
        // Delete the document if it exists
        await vehicleDocSnapshot.reference.delete();
        print('Vehicle document deleted successfully');
      } else {
        print('Vehicle document does not exist');
      }
    } catch (error) {
      print("Error deleting vehicle document: $error");
      // Handle any errors
    }
  }

  void submitProfile(
      String _make, String _model, String _vehicleRegistrationNumber, String _vin, BuildContext context) async {
    try {
      // Get the currently authenticated user
      User? user = FirebaseAuth.instance.currentUser;
      // Use the user's email as the document ID
      String userEmail = user!.email!;

      // Set profile details in Firestore using the user's email as the document ID
      await FirebaseFirestore.instance.collection(userEmail).doc('vehicle').set({
        'name': _make,
        'model': _model,
        'vehicle no.': _vehicleRegistrationNumber,
        'VIN': _vin,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Changes saved!")),
      );

      // Navigate back to previous screen
      Navigator.pop(context);
    } catch (error) {
      // Handle any errors
      print("Error submitting profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error submitting profile!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("VEHICLE REGISTRATION", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _make,
                  decoration: const InputDecoration(labelText: 'Vehicle Name*'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter the vehicle name' : null,
                ),
                 SizedBox(height: 20,),
                TextFormField(
                  controller: _model,
                  decoration: const InputDecoration(labelText: 'Model*'),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the model' : null,
                ),
                 SizedBox(height: 20,),
                TextFormField(
                  controller: _vehicleRegistrationNumber,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Registration Number*',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the vehicle registration number';
                    }
                    if (value.length != 10 ||
                        !RegExp(r'[A-Z]{2}[0-9]{2}[A-Z]{2}[0-9]{4}').hasMatch(value)) {
                      return 'Please enter a valid vehicle registration number (e.g. MH11AA1111)';
                    }
                    return null;
                  },
                ),
                 SizedBox(height: 20,),
                TextFormField(
                  controller: _vin,
                  decoration: const InputDecoration(labelText: 'VIN*'),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the VIN' : null,
                ),
                const SizedBox(height: 36),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      submitProfile(_make.text.toString(), _model.text.toString(),
                          _vehicleRegistrationNumber.text.toString(), _vin.text.toString(), context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vehicle added successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _make.dispose();
    _vehicleRegistrationNumber.dispose();
    _model.dispose();
    _vin.dispose();
    super.dispose();
  }
}
