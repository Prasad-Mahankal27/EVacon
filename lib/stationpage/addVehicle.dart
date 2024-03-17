import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vehicle Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Vehicle Name*'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the vehicle name'
                    : null,
                onSaved: (value) => _make = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Model*'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter the model' : null,
                onSaved: (value) => _model = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
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
                onSaved: (value) => _vehicleRegistrationNumber = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'VIN*'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter the VIN' : null,
                onSaved: (value) => _vin = value!,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Vehicle added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
