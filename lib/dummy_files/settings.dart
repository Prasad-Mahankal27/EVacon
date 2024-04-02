import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _darkMode = false;

  ThemeData _getTheme() {
    if (_darkMode) {
      return ThemeData.dark();
    } else {
      return ThemeData.light();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _getTheme(),
      home: Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: Text('General'),
              tiles: [
                SettingsTile.switchTile(
                  title: Text('Dark Mode'),
                  initialValue: _darkMode,
                  onToggle: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                ),
                // Add more settings options here
                SettingsTile(title: Text("Languages")),
                SettingsTile(title: Text("Privacy and security")),
                SettingsTile(title: Text("Terms & Conditions")),
                SettingsTile(title: Text("Help?")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}