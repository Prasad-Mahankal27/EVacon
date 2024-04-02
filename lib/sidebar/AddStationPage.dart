import 'dart:io';
import 'package:ev/stationpage/qrscreenview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../stationpage/qrscreenview.dart';
import '../stationpage/qrscreenview.dart'; // Updated import path for QR code generator screen

class AddStationPage extends StatefulWidget {
  @override
  _AddStationPageState createState() => _AddStationPageState();
}

class _AddStationPageState extends State<AddStationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _ownerName;
  String? _address;
  String? _accountNumber;
  File? _stationImage;
  bool _isACSelected = false;
  bool _isDCSelected = false;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _stationImage = File(pickedFile.path);
      });
    }
  }

  void _addStation() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String qrInfo = _accountNumber! + '|' + _ownerName!; // Format the QR info
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QRScreenView(qrInfo: qrInfo)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Station'),
        backgroundColor: Colors.blue, // Custom color for app bar
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.blueAccent], // Custom gradient colors
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Owner Name',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the owner name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _ownerName = value;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Address',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _address = value;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Account Number (8 digits)',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Account Number';
                          } else if (value.length != 8) {
                            return 'Account number must be 8 digits long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _accountNumber = value;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        height: 300.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[200],
                        ),
                        child: _stationImage == null
                            ? const Center(
                          child: Text(
                            'No image selected',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 36.0,
                            ),
                          ),
                        )
                            : Image.file(_stationImage!),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isACSelected = !_isACSelected;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isACSelected ? Colors.green : Colors.grey,
                            ),
                            child: Text(
                              'AC',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isDCSelected = !_isDCSelected;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isDCSelected ? Colors.green : Colors.grey,
                            ),
                            child: Text(
                              'DC',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Text('Select Image from Gallery'),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                  child: const Text('Take a Picture'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _addStation, // Call _addStation function
                  child: const Text('Add Station'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
