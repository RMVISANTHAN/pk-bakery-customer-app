import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _orderUpdates = true;
  bool _offers = true;
  bool _newProducts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text('Notification Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            title: const Text('Order updates'),
            value: _orderUpdates,
            onChanged: (v) => setState(() => _orderUpdates = v),
          ),
          SwitchListTile(
            title: const Text('Offers & promotions'),
            value: _offers,
            onChanged: (v) => setState(() => _offers = v),
          ),
          SwitchListTile(
            title: const Text('New products'),
            value: _newProducts,
            onChanged: (v) => setState(() => _newProducts = v),
          ),
          const Divider(),
          ListTile(title: const Text('App version'), trailing: const Text('1.0.0')),
          ListTile(title: const Text('Terms of Service'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
          ListTile(title: const Text('Privacy Policy'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ],
      ),
    );
  }
}
