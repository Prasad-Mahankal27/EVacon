import 'package:flutter/material.dart' show AppBar, BuildContext, Center, Colors, Column, MainAxisAlignment, Scaffold, SizedBox, StatelessWidget, Text, TextStyle, Widget;
import 'package:qr_flutter/qr_flutter.dart'; // Import QR Flutter package for generating QR code

class QRScreenView extends StatelessWidget {
  final String qrInfo;

  QRScreenView({required this.qrInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated QR Code'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrInfo,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Scan the QR Code to add station',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
