import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import for icons

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  _HelpSupportPageState createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  bool _isHelpExpanded = false;
  bool _isFAQExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[700], // EV-themed green
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // FAQ & Tutorials
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.greenAccent[400],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  // Help & Support
                  ListTile(
                    leading: _isHelpExpanded
                        ? FaIcon(FontAwesomeIcons.arrowCircleDown,
                            color: Colors.white)
                        : FaIcon(FontAwesomeIcons.arrowCircleRight,
                            color: Colors.white),
                    title: Text('Help & Support',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(() {
                        _isHelpExpanded = !_isHelpExpanded;
                      });
                    },
                  ),
                  if (_isHelpExpanded)
                    Column(
                      children: [
                        ListTile(
                          title: Text('Contact Us',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        ListTile(
                          leading: FaIcon(FontAwesomeIcons.envelope,
                              color: Colors.white),
                          title: Text('Send Email',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {/* Send email */},
                        ),
                        ListTile(
                          leading: FaIcon(FontAwesomeIcons.phone,
                              color: Colors.white),
                          title: Text('Call Us',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {/* Call support */},
                        ),
                      ],
                    ),
                  // General FAQ
                  ListTile(
                    leading: _isFAQExpanded
                        ? FaIcon(FontAwesomeIcons.arrowCircleDown,
                            color: Colors.white)
                        : FaIcon(FontAwesomeIcons.arrowCircleRight,
                            color: Colors.white),
                    title: Text('General FAQ',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(() {
                        _isFAQExpanded = !_isFAQExpanded;
                      });
                    },
                  ),
                  if (_isFAQExpanded)
                    Column(
                      children: [
                        ListTile(
                          title: Text('FAQ Content',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        // Add your FAQ content here
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
