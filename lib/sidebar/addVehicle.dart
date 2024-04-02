import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VehicleForm extends StatefulWidget {
  @override
  _VehicleFormState createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _make;
  String? _model;
  String? _vehicleRegistrationNumber;
  String? _vin;
  File? _vehicleImage;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _vehicleImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle Info'),
        backgroundColor: Colors.blue, // Custom app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Vehicle Name*'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter the vehicle name' : null,
                onSaved: (value) => _make = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Model*'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter the model' : null,
                onSaved: (value) => _model = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Vehicle Registration Number*'),
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
                onSaved: (value) => _vehicleRegistrationNumber = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'VIN*'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the VIN' : null,
                onSaved: (value) => _vin = value!,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: const Text('Select Image'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: const Text('Take Photo'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vehicle added successfully'),
                        backgroundColor: Colors.green, // Custom success snackbar color
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
              if (_vehicleImage != null) // Display selected image
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Image.file(_vehicleImage!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
