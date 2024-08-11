import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:community_energy_optimizer/services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Account Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Change Email'),
              onTap: () {
                // Navigate to change email screen
              },
            ),
            ListTile(
              title: Text('Change Password'),
              onTap: () {
                // Navigate to change password screen
              },
            ),
            ListTile(
              title: Text('Notification Preferences'),
              onTap: () {
                // Navigate to notification preferences screen
              },
            ),
            SizedBox(height: 20),
            Text(
              'App Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Theme'),
              trailing: DropdownButton<String>(
                value: 'Light',
                items: <String>['Light', 'Dark']
                    .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
                onChanged: (_) {},
              ),
            ),
            ListTile(
              title: Text('Language'),
              trailing: DropdownButton<String>(
                value: 'English',
                items: <String>['English', 'Spanish', 'French']
                    .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
                onChanged: (_) {},
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                await AuthService().logout();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
