
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Default Download Quality'),
            subtitle: const Text('Highest'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Download Location'),
            subtitle: const Text('Internal Storage'),
            onTap: () {},
          ),
          SwitchListTile(
            title: const Text('Download on Wi-Fi Only'),
            value: true,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
